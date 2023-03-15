package List::MoreUtils;use 5.00503;use strict;use Exporter();use DynaLoader();use vars qw{$VERSION @ISA @EXPORT_OK %EXPORT_TAGS};BEGIN{$VERSION='0.33';@ISA=qw{Exporter DynaLoader};@EXPORT_OK=qw{any all none notall true false firstidx first_index lastidx last_index insert_after insert_after_string apply indexes after after_incl before before_incl firstval first_value lastval last_value each_array each_arrayref pairwise natatime mesh zip uniq distinct minmax part};%EXPORT_TAGS=(all=>\@EXPORT_OK,);eval{local$ENV{PERL_DL_NONLAZY}=0 if$ENV{PERL_DL_NONLAZY};bootstrap List::MoreUtils$VERSION;1;}unless$ENV{LIST_MOREUTILS_PP};}eval<<'END_PERL'unless defined&any;die$@if$@;*first_index=\&firstidx;*last_index=\&lastidx;*first_value=\&firstval;*last_value=\&lastval;*zip=\&mesh;*distinct=\&uniq;1;__END__
use constant YES=>!0;use constant NO=>!1;sub any(&@){my$f=shift;foreach(@_){return YES if$f->();}return NO;}sub all(&@){my$f=shift;foreach(@_){return NO unless$f->();}return YES;}sub none(&@){my$f=shift;foreach(@_){return NO if$f->();}return YES;}sub notall(&@){my$f=shift;foreach(@_){return YES unless$f->();}return NO;}sub true(&@){my$f=shift;my$count=0;foreach(@_){$count++if$f->();}return$count;}sub false(&@){my$f=shift;my$count=0;foreach(@_){$count++unless$f->();}return$count;}sub firstidx(&@){my$f=shift;foreach my$i(0..$#_){local*_=\$_[$i];return$i if$f->();}return-1;}sub lastidx(&@){my$f=shift;foreach my$i(reverse 0..$#_){local*_=\$_[$i];return$i if$f->();}return-1;}sub insert_after(&$\@){my($f,$val,$list)=@_;my$c=-1;local*_;foreach my$i(0..$#$list){$_=$list->[$i];$c=$i,last if$f->();}@$list=(@{$list}[0..$c],$val,@{$list}[$c+1..$#$list],)and return 1 if$c!=-1;return 0;}sub insert_after_string($$\@){my($string,$val,$list)=@_;my$c=-1;foreach my$i(0..$#$list){local$^W=0;$c=$i,last if$string eq$list->[$i];}@$list=(@{$list}[0..$c],$val,@{$list}[$c+1..$#$list],)and return 1 if$c!=-1;return 0;}sub apply(&@){my$action=shift;&$action foreach my@values=@_;wantarray?@values:$values[-1];}sub after(&@){my$test=shift;my$started;my$lag;grep$started||=do{my$x=$lag;$lag=$test->();$x},@_;}sub after_incl(&@){my$test=shift;my$started;grep$started||=$test->(),@_;}sub before(&@){my$test=shift;my$more=1;grep$more&&=!$test->(),@_;}sub before_incl(&@){my$test=shift;my$more=1;my$lag=1;grep$more&&=do{my$x=$lag;$lag=!$test->();$x},@_;}sub indexes(&@){my$test=shift;grep{local*_=\$_[$_];$test->()}0..$#_;}sub lastval(&@){my$test=shift;my$ix;for($ix=$#_;$ix>=0;$ix--){local*_=\$_[$ix];my$testval=$test->();$_[$ix]=$_;return$_ if$testval;}return undef;}sub firstval(&@){my$test=shift;foreach(@_){return$_ if$test->();}return undef;}sub pairwise(&\@\@){my$op=shift;use vars qw{@A @B};local(*A,*B)=@_;my($caller_a,$caller_b)=do{my$pkg=caller();no strict 'refs';\*{$pkg.'::a'},\*{$pkg.'::b'};};my$limit=$#A>$#B?$#A:$#B;local(*$caller_a,*$caller_b);map{(*$caller_a,*$caller_b)=\($A[$_],$B[$_]);$op->();}0..$limit;}sub each_array(\@;\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@){return each_arrayref(@_);}sub each_arrayref{my@list=@_;my$index=0;my$max=0;foreach(@list){unless(ref$_ eq 'ARRAY'){require Carp;Carp::croak("each_arrayref: argument is not an array reference\n");}$max=@$_ if@$_>$max;}return sub{if(@_){my$method=shift;unless($method eq 'index'){require Carp;Carp::croak("each_array: unknown argument '$method' passed to iterator.");}return undef if$index==0||$index>$max;return$index-1;}return if$index>=$max;my$i=$index++;return map$_->[$i],@list;}}sub natatime($@){my$n=shift;my@list=@_;return sub{return splice@list,0,$n;}}sub mesh(\@\@;\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@){my$max=-1;$max<$#$_&&($max=$#$_)foreach@_;map{my$ix=$_;map$_->[$ix],@_;}0..$max;}sub uniq(@){my%seen=();grep{not$seen{$_}++}@_;}sub minmax(@){return unless@_;my$min=my$max=$_[0];for(my$i=1;$i<@_;$i+=2){if($_[$i-1]<=$_[$i]){$min=$_[$i-1]if$min>$_[$i-1];$max=$_[$i]if$max<$_[$i];}else{$min=$_[$i]if$min>$_[$i];$max=$_[$i-1]if$max<$_[$i-1];}}if(@_&1){my$i=$#_;if($_[$i-1]<=$_[$i]){$min=$_[$i-1]if$min>$_[$i-1];$max=$_[$i]if$max<$_[$i];}else{$min=$_[$i]if$min>$_[$i];$max=$_[$i-1]if$max<$_[$i-1];}}return($min,$max);}sub part(&@){my($code,@list)=@_;my@parts;push@{$parts[$code->($_)]},$_ foreach@list;return@parts;}sub _XScompiled{return 0;}
END_PERL