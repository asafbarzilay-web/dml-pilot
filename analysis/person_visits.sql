-- One row per visit to the photo app, with the person it belongs to.
create or replace view analysis.person_visits as
  with signed_in as (
    select session_id, min(account) as account
    from public.identities
    group by session_id
  ),
  browser_accounts as (
    select v.user_id, min(s.account) as account
    from analysis.photo_visits v
    join signed_in s on s.session_id = v.session_id
    group by v.user_id
  )
  select v.session_id,
         v.user_id,
         v.started_at,
         coalesce(s.account, b.account, v.user_id::text) as person,
         case when coalesce(s.account, b.account) is null then 'browser' else 'account' end as counted_by
  from analysis.photo_visits v
  left join signed_in s on s.session_id = v.session_id
  left join browser_accounts b on b.user_id = v.user_id;

comment on view analysis.person_visits is
  'One row is one visit from photo_visits (the photo app''s visits, excluding the team''s own test runs), with its person: the account signed in on that visit; if none, the account that browser signed in with on another visit; if the browser never signed in, the browser itself.';
