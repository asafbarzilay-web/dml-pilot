-- One row per person who used the photo app: an account, or a browser that never signed in.
drop view if exists analysis.people cascade;
create or replace view analysis.people as
  with signed_in as (
    select distinct i.account, v.user_id
    from analysis.photo_visits v
    join public.identities i on i.session_id = v.session_id
  )
  select distinct account as person, 'account' as counted_by
  from signed_in
  union all
  select distinct v.user_id::text as person, 'browser' as counted_by
  from analysis.photo_visits v
  where v.user_id not in (select user_id from signed_in);

comment on view analysis.people is
  'We count different accounts (sign-ins in identities), plus one person per browser that never signed in, from photo_visits (the photo app''s visits, excluding the team''s own test runs). A browser that signed in on any visit is counted only by its account, because its visits without a sign-in are the same person.';
