create type "public"."team_member_role" as enum ('coach', 'athlete');

create type "public"."team_type" as enum ('high-school', 'collegiate', 'club');

create type "public"."workout_type" as enum ('tempo', 'speed-endurance', 'max-velocity');


  create table "public"."athletes" (
    "id" uuid not null default gen_random_uuid(),
    "name" text not null,
    "user" uuid,
    "created_at" timestamp with time zone not null default now(),
    "team" uuid not null
      );


alter table "public"."athletes" enable row level security;

alter table "public"."teams" add column "creator" uuid not null;

alter table "public"."teams" add column "type" public.team_type not null;

alter table "public"."users" drop column "role";

alter table "public"."users" add column "main_role" public.user_role not null;

CREATE UNIQUE INDEX athletes_pkey ON public.athletes USING btree (id);

alter table "public"."athletes" add constraint "athletes_pkey" PRIMARY KEY using index "athletes_pkey";

alter table "public"."athletes" add constraint "athletes_team_fkey" FOREIGN KEY (team) REFERENCES public.teams(id) ON DELETE CASCADE not valid;

alter table "public"."athletes" validate constraint "athletes_team_fkey";

alter table "public"."athletes" add constraint "athletes_user_fkey" FOREIGN KEY ("user") REFERENCES public.users(id) not valid;

alter table "public"."athletes" validate constraint "athletes_user_fkey";

alter table "public"."teams" add constraint "teams_creator_fkey" FOREIGN KEY (creator) REFERENCES public.users(id) not valid;

alter table "public"."teams" validate constraint "teams_creator_fkey";

grant delete on table "public"."athletes" to "anon";

grant insert on table "public"."athletes" to "anon";

grant references on table "public"."athletes" to "anon";

grant select on table "public"."athletes" to "anon";

grant trigger on table "public"."athletes" to "anon";

grant truncate on table "public"."athletes" to "anon";

grant update on table "public"."athletes" to "anon";

grant delete on table "public"."athletes" to "authenticated";

grant insert on table "public"."athletes" to "authenticated";

grant references on table "public"."athletes" to "authenticated";

grant select on table "public"."athletes" to "authenticated";

grant trigger on table "public"."athletes" to "authenticated";

grant truncate on table "public"."athletes" to "authenticated";

grant update on table "public"."athletes" to "authenticated";

grant delete on table "public"."athletes" to "postgres";

grant insert on table "public"."athletes" to "postgres";

grant references on table "public"."athletes" to "postgres";

grant select on table "public"."athletes" to "postgres";

grant trigger on table "public"."athletes" to "postgres";

grant truncate on table "public"."athletes" to "postgres";

grant update on table "public"."athletes" to "postgres";

grant delete on table "public"."athletes" to "service_role";

grant insert on table "public"."athletes" to "service_role";

grant references on table "public"."athletes" to "service_role";

grant select on table "public"."athletes" to "service_role";

grant trigger on table "public"."athletes" to "service_role";

grant truncate on table "public"."athletes" to "service_role";

grant update on table "public"."athletes" to "service_role";


  create policy "Enable all for team owners"
  on "public"."athletes"
  as permissive
  for all
  to authenticated
using ((( SELECT auth.uid() AS uid) = ( SELECT teams.creator
   FROM public.teams
  WHERE (teams.id = athletes.team))))
with check ((( SELECT auth.uid() AS uid) = ( SELECT teams.creator
   FROM public.teams
  WHERE (teams.id = athletes.team))));



  create policy "Enable delete for team owners"
  on "public"."teams"
  as permissive
  for delete
  to authenticated
using ((( SELECT auth.uid() AS uid) = creator));



  create policy "Enable insert based on uid"
  on "public"."teams"
  as permissive
  for insert
  to authenticated
with check ((( SELECT auth.uid() AS uid) = creator));



  create policy "Enable select for authenticated users only"
  on "public"."teams"
  as permissive
  for select
  to authenticated
using (true);



  create policy "Enable insert for users based on user_id"
  on "public"."users"
  as permissive
  for insert
  to authenticated
with check ((( SELECT auth.uid() AS uid) = id));



  create policy "Enable read access for authenticated users"
  on "public"."users"
  as permissive
  for select
  to authenticated
using (true);
