-- One row per group: browsers used with no account, with a single account, and with more than one.
create or replace view analysis.browser_account_groups as
  select case when accounts = 0 then 'no account'
              when accounts = 1 then 'one account'
              else 'more than one account' end as account_group,
         count(*) as browsers
  from (
    select s.user_id, count(distinct i.account) as accounts
    from public.sessions s
    left join public.identities i on i.session_id = s.session_id
    where not s.is_test
    group by s.user_id
  ) b
  group by 1;

comment on view analysis.browser_account_groups is
  'We count different browsers (user_id), from sessions, excluding the team''s own test runs, split in three: browsers where no account signed in, browsers where a single account signed in, and browsers where more than one account signed in (accounts from identities).';
