use ipl;

show tables;
select * from ipl_match;
select * from ipl_bidder_Details;
select * from ipl_bidder_points;
select * from ipl_bidding_details;
select * from ipl_match_schedule;
select * from ipl_player;
select * from ipl_Stadium;
select * from ipl_team;
select * from ipl_team_players;
select * from ipl_team_Standings;
select * from ipl_tournament;
select * from ipl_user;

# 1.	Show the percentage of wins of each bidder in the order of highest to lowest percentage.

select ibd.bidder_id,ibd.bidder_name,round(((bids_won*100)/no_of_bids),2) as percent_wins from ipl_bidder_details ibd join ipl_bidder_points ibp 
on ibd.bidder_id=ibp.bidder_id 
join (select bidder_id,bid_status,count(bid_Status) as bids_won from ipl_bidding_Details 
where bid_Status='won'group by bidder_id,bid_status)t on t.bidder_id=ibp.bidder_id group by ibd.bidder_id,ibd.bidder_name
order by percent_wins desc;




# 2.	Display the number of matches conducted at each stadium with stadium name, city from the database.
select stadium_name,city,count(*) matches_played from ipl_Stadium ist 
right join ipl_match_schedule ims on ist.stadium_id=ims.stadium_id 
group by stadium_name;

select count(*) from ipl_match_Schedule where stadium_id=7;-- for checking


# 3.	In a given stadium, what is the percentage of wins by a team which has won the toss?
select s.stadium_name,count(status) as total_matches,wins_by_toss_team,
round(((wins_by_toss_team/count(status))*100),2) as percentage_of_wins
from ipl_stadium s 
join ipl_match_schedule ms
on s.stadium_id=ms.stadium_id 
and status='Completed' 
join
(
select stadium_name,count(*) as wins_by_toss_team from 
(select stadium_name,team_id1,team_id2,toss_winner,match_winner,
if(toss_winner=1,team_id1,team_id2) as winning_teamid
from ipl_stadium s
join ipl_match_schedule ms
on s.stadium_id=ms.stadium_id
join ipl_match m 
on m.match_id=ms.match_id
and toss_winner=match_winner) as t
join ipl_team it
on it.team_id=winning_teamid
group by stadium_name
order by stadium_name) as tt
on s.stadium_name=tt.stadium_name
group by s.stadium_name
order by percentage_of_wins desc;


# 4.	Show the total bids along with bid team and team name.
select count(*)bid_count,bid_team,team_name 
from ipl_bidding_details ibd join ipl_team it 
on ibd.bid_team=it.team_id group by bid_team,team_name;

# 5.	Show the team id who won the match as per the win details.
select if(match_winner=1,team_id1,team_id2) winner_team_id,win_Details 
from ipl_match;

# 6.	Display total matches played, total matches won and total matches lost by team along with its team name.
select * from ipl_team_standings;
select its.team_id,it.team_name,sum(its.matches_played) total_matches_played,sum(its.matches_won) total_matches_won,
sum(its.matches_lost) total_matches_lost from ipl_team_Standings its inner join ipl_team it on its.team_id=it.team_id group by its.team_id;

# 7.	Display the bowlers for Mumbai Indians team.
select * from ipl_player;
select * from ipl_team_players;
select * from ipl_team;

select itp.player_id,player_name from ipl_team it 
join ipl_team_Players itp on it.team_id=itp.team_id
join ipl_player ip on ip.player_id=itp.player_id 
where team_name ='mumbai indians' and player_role ='bowler';


# 8.	How many all-rounders are there in each team, Display the teams with more than 4 
# all-rounder in descending order.

select * from (select it.team_id,it.team_name,count(player_role) total_all_rounders
from ipl_team it join ipl_team_players itp on it.team_id=itp.team_id
where player_role='all-rounder' group by team_name order by total_all_rounders desc) t1
where total_all_rounders>4;





