package CGI::Session::Driver::sqlite;use strict;use File::Spec;use base 'CGI::Session::Driver::DBI';use DBI qw(SQL_BLOB);use Fcntl;$CGI::Session::Driver::sqlite::VERSION='4.43';sub init{my$self=shift;unless($self->{Handle}){$self->{DataSource}="dbi:SQLite:dbname=".$self->{DataSource}unless($self->{DataSource}=~/^dbi:sqlite/i);}$self->SUPER::init()or return;$self->{Handle}->{sqlite_handle_binary_nulls}=1;return 1;}sub store{my$self=shift;my($sid,$datastr)=@_;return$self->set_error("store(): usage error")unless$sid&&$datastr;my$dbh=$self->{Handle};my$sth=$dbh->prepare("SELECT $self->{IdColName} FROM ".$self->table_name." WHERE $self->{IdColName}=?");unless(defined$sth){return$self->set_error("store(): \$sth->prepare failed with message ".$dbh->errstr);}$sth->execute($sid)or return$self->set_error("store(): \$sth->execute failed with message ".$dbh->errstr);if($sth->fetchrow_array){__ex_and_ret($dbh,"UPDATE ".$self->table_name." SET $self->{DataColName}=? WHERE $self->{IdColName}=?",$datastr,$sid)or return$self->set_error("store(): serialize to db failed ".$dbh->errstr);}else{__ex_and_ret($dbh,"INSERT INTO ".$self->table_name." ($self->{DataColName},$self->{IdColName}) VALUES(?, ?)",$datastr,$sid)or return$self->set_error("store(): serialize to db failed ".$dbh->errstr);}return 1;}sub DESTROY{my$self=shift;unless(defined($self->{Handle})&&$self->{Handle}->ping){$self->set_error(__PACKAGE__.'::DESTROY(). Database handle has gone away');return;}unless($self->{Handle}->{AutoCommit}){$self->{Handle}->commit;}if($self->{_disconnect}){undef$self->{Handle};}}sub __ex_and_ret{my($dbh,$sql,$datastr,$sid)=@_;local$@;eval{my$sth=$dbh->prepare($sql)or return 0;$sth->bind_param(1,$datastr,SQL_BLOB)or return 0;$sth->bind_param(2,$sid)or return 0;$sth->execute()or return 0;};return!$@;}1;__END__