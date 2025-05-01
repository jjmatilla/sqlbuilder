module github.com/jjmatilla/go-sqlbuilder/integration

go 1.12

require (
	github.com/jjmatilla/go-sqlbuilder v1.5.5
	github.com/go-sql-driver/mysql v1.9.2
	github.com/lib/pq v1.10.9
	github.com/stretchr/testify v1.10.0
	google.golang.org/appengine v1.6.8 // indirect
)

replace github.com/jjmatilla/go-sqlbuilder => ../
