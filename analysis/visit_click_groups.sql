-- One row per group: the visits that had a click, and the visits without any click.
create or replace view analysis.visit_click_groups as
  select case when exists (select 1 from public.clicks c where c.session_id = v.session_id)
              then 'had a click' else 'no click' end as visit_group,
         count(*) as visits
  from analysis.photo_visits v
  group by 1;

comment on view analysis.visit_click_groups is
  'We count visits from photo_visits (the photo app''s visits, excluding the team''s own test runs), split in two: visits with at least one click, and visits with no click at all, because we want to find the visits without clicks.';
