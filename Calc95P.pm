package Calc95P;

use strict;
use warnings;
use POSIX;
use base 'Exporter';

my $debug_mode = 0;

our @EXPORT = qw( 
	calc_speed 
	select_95PP
	select_max
	adjust_time
);

sub calc_speed
{
	my($time_arr_ref, $traff_arr_ref) = @_;
	my @time_arr = @{$time_arr_ref};
	my @data_arr = @{$traff_arr_ref};
	my @speed_arr = ();
	my $time_arr_len = scalar(@time_arr);
	for(my $i = 0; $i < $time_arr_len ; $i++){
	#for(my $i = 0; $i < @time_arr - 1; $i++){
		my $dTime = $time_arr[$i] - $time_arr[$i + 1];
		my $dTraff = ($data_arr[$i] - $data_arr[$i + 1]);
		my $dTraffDTime = $dTraff / $dTime;
		#my $dTraffDTime = $data_arr[$i] / $time_arr[$i] ;
		# print "dTraffDTime = $dTraffDTime\n" if $debug_mode;
		# print "dTime = $dTime\n" if $debug_mode;
		# print "dTraff = $dTraff\n" if $debug_mode;
		push(@speed_arr, $dTraffDTime);
	}
	return @speed_arr;
}

sub select_95PP
{
	my($time_arr_ref, $speed_arr_ref) = @_;
	my @time_arr = @{$time_arr_ref};
	my @data_arr = @{$speed_arr_ref};
	my @speed_95P = ();
	@data_arr = sort_array(@data_arr);
	my $sorted_arr_len = scalar(@data_arr);
	my $result_arr_len = floor(0.95 * $sorted_arr_len);
	#print "\nresult_arr_len = $result_arr_len sorted_arr_len = $sorted_arr_len\n";
	for(my $i = 0; $i <$result_arr_len; $i++){
		push(@speed_95P, $data_arr[$i]);
		print $data_arr[$i]."\n" if $debug_mode;
	}
	return @speed_95P;
}

sub select_max
{
	my($arr_ref) = @_;
	my @arr = @{$arr_ref};
	my $arr_len = scalar(@arr);
	if($arr_len == 0){
		return 0;
	}else{
		return $arr[$arr_len - 1];
	}
}

sub adjust_time
{
	my($time_step, $arr_time_ref, $smpl_cnt) = @_;
	my @loc_time_arr = @{$arr_time_ref}; 
	
	if(scalar(@loc_time_arr) == 0){
		return -1;
	}
	@loc_time_arr = sort_array(@loc_time_arr);
	my $min_time = $loc_time_arr[0];
	my @loc_time_arr_ideal = ();
	my @loc_time_arr_result = ();
	for(my $i = 0; $i < $smpl_cnt; $i++){
		my $next_time = $min_time + $i*$time_step;
		push(@loc_time_arr_ideal, $next_time);
	}
	
	my $loc_diff = 0;
	my $nearest_time = 0;
	for(my $i = 0; $i < $smpl_cnt; $i++){
		my $loc_min_time = $loc_time_arr_ideal[$i];
		$loc_diff = abs($loc_time_arr[0] - $loc_min_time);
		$nearest_time = $loc_time_arr[0];
		for(my $j = 0; $j < scalar(@loc_time_arr); $j++){
			my $curr_diff = abs($loc_time_arr[$j] - $loc_min_time);
			if( $curr_diff < $loc_diff){
				$loc_diff = $curr_diff;
				$nearest_time = $loc_time_arr[$j];
			}
			push(@loc_time_arr_result, $nearest_time);
		}
	}
	return @loc_time_arr_result;
}

sub sort_array
{
	my (@arr_to_sort) = @_;
	my @vals = sort {$a <=> $b} @arr_to_sort;#@_;
	return @vals;
}

1;

__END__
