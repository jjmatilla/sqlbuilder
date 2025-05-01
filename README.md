[![Stability: Maintenance](https://jjmatilla.github.io/stability/maintenance.svg)](https://jjmatilla.github.io/stability/maintenance.html)
### sqlbuilder is "complete".
Bug fixes will still be merged (slowly). Bug reports are welcome, but I will not necessarily respond to them. If another fork (or substantially similar project) actively improves on what sqlbuilder does, let me know and I may link to it here.


# sqlbuilder - fluent SQL generator for Go

```go
import "github.com/jjmatilla/sqlbuilder"
```


[![GoDoc](https://godoc.org/github.com/jjmatilla/sqlbuilder?status.png)](https://godoc.org/github.com/jjmatilla/sqlbuilder)
[![Build Status](https://api.travis-ci.org/jjmatilla/sqlbuilder.svg?branch=master)](https://travis-ci.org/jjmatilla/sqlbuilder)

**sqlbuilder is not an ORM.** For an application of sqlbuilder, check out
[structable, a table-struct mapper](https://github.com/jjmatilla/structable)


sqlbuilder helps you build SQL queries from composable parts:

```go
import sq "github.com/jjmatilla/sqlbuilder"

users := sq.Select("*").From("users").Join("emails USING (email_id)")

active := users.Where(sq.Eq{"deleted_at": nil})

sql, args, err := active.ToSql()

sql == "SELECT * FROM users JOIN emails USING (email_id) WHERE deleted_at IS NULL"
```

```go
sql, args, err := sq.
    Insert("users").Columns("name", "age").
    Values("moe", 13).Values("larry", sq.Expr("? + 5", 12)).
    ToSql()

sql == "INSERT INTO users (name,age) VALUES (?,?),(?,? + 5)"
```

sqlbuilder can also execute queries directly:

```go
stooges := users.Where(sq.Eq{"username": []string{"moe", "larry", "curly", "shemp"}})
three_stooges := stooges.Limit(3)
rows, err := three_stooges.RunWith(db).Query()

// Behaves like:
rows, err := db.Query("SELECT * FROM users WHERE username IN (?,?,?,?) LIMIT 3",
                      "moe", "larry", "curly", "shemp")
```

sqlbuilder makes conditional query building a breeze:

```go
if len(q) > 0 {
    users = users.Where("name LIKE ?", fmt.Sprint("%", q, "%"))
}
```

sqlbuilder wants to make your life easier:

```go
// StmtCache caches Prepared Stmts for you
dbCache := sq.NewStmtCache(db)

// StatementBuilder keeps your syntax neat
mydb := sq.StatementBuilder.RunWith(dbCache)
select_users := mydb.Select("*").From("users")
```

sqlbuilder loves PostgreSQL:

```go
psql := sq.StatementBuilder.PlaceholderFormat(sq.Dollar)

// You use question marks for placeholders...
sql, _, _ := psql.Select("*").From("elephants").Where("name IN (?,?)", "Dumbo", "Verna").ToSql()

/// ...sqlbuilder replaces them using PlaceholderFormat.
sql == "SELECT * FROM elephants WHERE name IN ($1,$2)"


/// You can retrieve id ...
query := sq.Insert("nodes").
    Columns("uuid", "type", "data").
    Values(node.Uuid, node.Type, node.Data).
    Suffix("RETURNING \"id\"").
    RunWith(m.db).
    PlaceholderFormat(sq.Dollar)

query.QueryRow().Scan(&node.id)
```

You can escape question marks by inserting two question marks:

```sql
SELECT * FROM nodes WHERE meta->'format' ??| array[?,?]
```

will generate with the Dollar Placeholder:

```sql
SELECT * FROM nodes WHERE meta->'format' ?| array[$1,$2]
```

## FAQ

* **How can I build an IN query on composite keys / tuples, e.g. `WHERE (col1, col2) IN ((1,2),(3,4))`? ([#104](https://github.com/jjmatilla/sqlbuilder/issues/104))**

    sqlbuilder does not explicitly support tuples, but you can get the same effect with e.g.:

    ```go
    sq.Or{
      sq.Eq{"col1": 1, "col2": 2},
      sq.Eq{"col1": 3, "col2": 4}}
    ```

    ```sql
    WHERE (col1 = 1 AND col2 = 2) OR (col1 = 3 AND col2 = 4)
    ```

    (which should produce the same query plan as the tuple version)

* **Why doesn't `Eq{"mynumber": []uint8{1,2,3}}` turn into an `IN` query? ([#114](https://github.com/jjmatilla/sqlbuilder/issues/114))**

    Values of type `[]byte` are handled specially by `database/sql`. In Go, [`byte` is just an alias of `uint8`](https://golang.org/pkg/builtin/#byte), so there is no way to distinguish `[]uint8` from `[]byte`.

* **Some features are poorly documented!**

    This isn't a frequent complaints section!

* **Some features are poorly documented?**

    Yes. The tests should be considered a part of the documentation; take a look at those for ideas on how to express more complex queries.

## License

sqlbuilder is released under the
[MIT License](http://www.opensource.org/licenses/MIT).
