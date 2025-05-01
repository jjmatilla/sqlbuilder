module github.com/jjmatilla/sqlbuilder/integration

go 1.24.2

require (
	github.com/go-sql-driver/mysql v1.9.2
	github.com/jjmatilla/sqlbuilder v1.5.5
	github.com/lib/pq v1.10.9
	github.com/mattn/go-sqlite3 v1.14.28
	github.com/stretchr/testify v1.10.0
)

require (
	filippo.io/edwards25519 v1.1.0 // indirect
	github.com/davecgh/go-spew v1.1.1 // indirect
	github.com/lann/builder v0.0.0-20180802200727-47ae307949d0 // indirect
	github.com/lann/ps v0.0.0-20150810152359-62de8c46ede0 // indirect
	github.com/pmezard/go-difflib v1.0.0 // indirect
	gopkg.in/yaml.v3 v3.0.1 // indirect
)

replace github.com/jjmatilla/sqlbuilder => ../
