create or replace view analysis.task_run_endings as
  select
    case coalesce(r.ended_by, 'never ended')
      when 'success' then 'success'
      when 'gave_up' then 'gave up'
      else 'never ended'
    end as ending,
    count(*) as runs
  from public.task_runs r
  join public.sessions s on s.session_id = r.session_id
  where r.task = 'On Jane''s profile, like the photo of the woman with purple hair'
    and not s.is_test
  group by 1;

comment on view analysis.task_run_endings is
  'We count runs of the team''s task, from task_runs, only rows whose task is: On Jane''s profile, like the photo of the woman with purple hair; excluding the team''s own test runs (is_test in sessions), split by how the run ended (ended_by): success, gave up, or never ended.';
