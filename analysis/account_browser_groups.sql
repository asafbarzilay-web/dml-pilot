-- One row per group: accounts that signed in from a single browser, and from more than one.
create or replace view analysis.account_browser_groups as
  select case when browsers = 1 then 'one browser' else 'more than one browser' end as browser_group,
         count(*) as accounts
  from (
    select i.account, count(distinct s.user_id) as browsers
    from public.identities i
    join public.sessions s on s.session_id = i.session_id
    where not s.is_test
    group by i.account
  ) a
  group by 1;

comment on view analysis.account_browser_groups is
  'We count different accounts that signed in, from the identities table, excluding sign-ins made during the team''s own test runs (is_test in sessions), split in two: accounts that signed in from a single browser (user_id in sessions), and accounts that signed in from more than one browser.';
