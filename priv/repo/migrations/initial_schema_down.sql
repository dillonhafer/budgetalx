drop table public.allocation_plan_budget_items;
drop table public.allocation_plans;
drop table public.annual_budget_items;
drop table public.annual_budgets;
drop table public.budget_item_expenses;
drop table public.budget_items;
drop table public.budget_categories;
drop table public.budgets;
drop table public.net_worth_items;
drop table public.assets_liabilities;
drop table public.net_worths;
drop table public.sessions;
drop table public.users cascade;

drop extension if exists citext cascade;
drop extension if exists pgcrypto cascade;