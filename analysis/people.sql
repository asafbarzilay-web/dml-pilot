-- One row per person who used the photo app: an account, or a browser that never signed in.
create or replace view analysis.people as
  select person,
         min(counted_by) as counted_by,
         count(*) as visits
  from analysis.person_visits
  group by person;

comment on view analysis.people is
  'We count different accounts (sign-ins in identities), plus one person per browser that never signed in, from photo_visits (the photo app''s visits, excluding the team''s own test runs). A browser that signed in on any visit is counted only by its account, because its visits without a sign-in are the same person. visits = how many of those visits are this person''s (from person_visits).';
