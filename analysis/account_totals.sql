-- One row: how many different accounts signed in, from the whole identities table.
create or replace view analysis.account_totals as
  select count(distinct account) as accounts
  from public.identities;

comment on view analysis.account_totals is
  'We count different accounts that signed in, from the entire identities table, excluding nothing; an account that signed in more than once is counted once.';
