-DB Connection. 
database connection configuration is injected by module Config.pm package path as follow, 
IBM::AmTools::Db::Config

Configuration file path. 
my $filename = -r '/opt/common/utils/dbs.ini'
             ? '/opt/common/utils/dbs.ini'
             : '/gsa/pokgsa/projects/a/am-reporting/admin/dbs.ini'
             ;
