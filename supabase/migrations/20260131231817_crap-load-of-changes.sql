create extension if not exists "pg_cron" with schema "pg_catalog";

drop policy "Enable all for team owners" on "public"."athletes";

drop policy "Enable delete for team owners" on "public"."teams";

drop policy "Enable insert based on uid" on "public"."teams";

alter table "public"."athletes" drop constraint "athletes_team_fkey";

alter table "public"."athletes" drop constraint "athletes_user_fkey";

alter table "public"."teams" drop constraint "teams_creator_fkey";

  create table "public"."athlete_groups" (
    "id" uuid not null default gen_random_uuid(),
    "team" uuid not null,
    "name" text not null,
    "created_at" timestamp with time zone not null default now(),
    "archived_at" timestamp with time zone
      );


alter table "public"."athlete_groups" enable row level security;


  create table "public"."coaches" (
    "user" uuid not null,
    "team" uuid not null,
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."coaches" enable row level security;


  create table "public"."team_invite_codes" (
    "id" text not null,
    "team" uuid not null,
    "expires_at" timestamp with time zone not null
      );


alter table "public"."team_invite_codes" enable row level security;


  create table "public"."team_join_requests" (
    "team" uuid not null,
    "user" uuid not null,
    "invite_code" text,
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."team_join_requests" enable row level security;


  create table "public"."workout_rep_results" (
    "rep" uuid not null,
    "athlete" uuid not null,
    "time_seconds" real,
    "team" uuid not null,
    "workout" uuid not null
      );


alter table "public"."workout_rep_results" enable row level security;


  create table "public"."workout_reps" (
    "id" uuid not null default gen_random_uuid(),
    "set" uuid not null,
    "rep_number" smallint not null,
    "distance_m" integer not null,
    "rest_after_seconds" smallint,
    "team" uuid not null,
    "template_rep" uuid
      );


alter table "public"."workout_reps" enable row level security;


  create table "public"."workout_sessions" (
    "id" uuid not null default gen_random_uuid(),
    "type" public.workout_type not null,
    "team" uuid not null,
    "creator" uuid not null,
    "finished_at" timestamp with time zone not null,
    "started_at" timestamp with time zone not null,
    "template_used" uuid
      );


alter table "public"."workout_sessions" enable row level security;


  create table "public"."workout_sets" (
    "id" uuid not null default gen_random_uuid(),
    "session" uuid not null,
    "set_number" smallint not null,
    "rep_count" smallint not null,
    "rest_after_seconds" smallint,
    "team" uuid not null,
    "athlete_group" uuid
      );


alter table "public"."workout_sets" enable row level security;


  create table "public"."workout_template_rep_result_targets" (
    "athlete" uuid not null,
    "target_time_seconds" real not null,
    "team" uuid not null,
    "rep" uuid not null,
    "template" uuid not null
      );


alter table "public"."workout_template_rep_result_targets" enable row level security;


  create table "public"."workout_template_reps" (
    "set" uuid not null,
    "rep_number" smallint not null,
    "distance_m" smallint not null,
    "rest_after_seconds" smallint,
    "team" uuid not null,
    "id" uuid not null default gen_random_uuid()
      );


alter table "public"."workout_template_reps" enable row level security;


  create table "public"."workout_template_sets" (
    "id" uuid not null default gen_random_uuid(),
    "set_number" smallint not null,
    "athlete_group" uuid,
    "rep_count" smallint not null,
    "rest_after_seconds" smallint,
    "team" uuid not null,
    "template" uuid not null
      );


alter table "public"."workout_template_sets" enable row level security;


  create table "public"."workout_templates" (
    "type" public.workout_type not null,
    "team" uuid not null,
    "creator" uuid,
    "created_at" timestamp with time zone not null default now(),
    "name" text not null,
    "id" uuid not null
      );


alter table "public"."workout_templates" enable row level security;

alter table "public"."athletes" add column "group" uuid;

alter table "public"."teams" drop column "creator";

alter table "public"."teams" add column "owner" uuid not null;

CREATE UNIQUE INDEX athlete_groups_pkey ON public.athlete_groups USING btree (id);

CREATE UNIQUE INDEX coaches_pkey ON public.coaches USING btree ("user", team);

CREATE UNIQUE INDEX team_invite_codes_pkey ON public.team_invite_codes USING btree (id);

CREATE UNIQUE INDEX team_join_requests_pkey ON public.team_join_requests USING btree (team, "user");

CREATE UNIQUE INDEX team_join_requests_user_team_key ON public.team_join_requests USING btree ("user", team);

CREATE UNIQUE INDEX workout_rep_results_pkey ON public.workout_rep_results USING btree (rep, athlete);

CREATE UNIQUE INDEX workout_reps_pkey ON public.workout_reps USING btree (id);

CREATE UNIQUE INDEX workout_sessions_pkey ON public.workout_sessions USING btree (id);

CREATE UNIQUE INDEX workout_sets_pkey1 ON public.workout_sets USING btree (id);

CREATE UNIQUE INDEX workout_template_rep_result_targets_pkey ON public.workout_template_rep_result_targets USING btree (athlete, rep);

CREATE UNIQUE INDEX workout_template_reps_pkey ON public.workout_template_reps USING btree (id);

CREATE UNIQUE INDEX workout_template_sets_pkey ON public.workout_template_sets USING btree (id);

CREATE UNIQUE INDEX workout_templates_pkey ON public.workout_templates USING btree (id);

alter table "public"."athlete_groups" add constraint "athlete_groups_pkey" PRIMARY KEY using index "athlete_groups_pkey";

alter table "public"."coaches" add constraint "coaches_pkey" PRIMARY KEY using index "coaches_pkey";

alter table "public"."team_invite_codes" add constraint "team_invite_codes_pkey" PRIMARY KEY using index "team_invite_codes_pkey";

alter table "public"."team_join_requests" add constraint "team_join_requests_pkey" PRIMARY KEY using index "team_join_requests_pkey";

alter table "public"."workout_rep_results" add constraint "workout_rep_results_pkey" PRIMARY KEY using index "workout_rep_results_pkey";

alter table "public"."workout_reps" add constraint "workout_reps_pkey" PRIMARY KEY using index "workout_reps_pkey";

alter table "public"."workout_sessions" add constraint "workout_sessions_pkey" PRIMARY KEY using index "workout_sessions_pkey";

alter table "public"."workout_sets" add constraint "workout_sets_pkey1" PRIMARY KEY using index "workout_sets_pkey1";

alter table "public"."workout_template_rep_result_targets" add constraint "workout_template_rep_result_targets_pkey" PRIMARY KEY using index "workout_template_rep_result_targets_pkey";

alter table "public"."workout_template_reps" add constraint "workout_template_reps_pkey" PRIMARY KEY using index "workout_template_reps_pkey";

alter table "public"."workout_template_sets" add constraint "workout_template_sets_pkey" PRIMARY KEY using index "workout_template_sets_pkey";

alter table "public"."workout_templates" add constraint "workout_templates_pkey" PRIMARY KEY using index "workout_templates_pkey";

alter table "public"."athlete_groups" add constraint "athlete_groups_team_fkey" FOREIGN KEY (team) REFERENCES public.teams(id) ON DELETE CASCADE not valid;

alter table "public"."athlete_groups" validate constraint "athlete_groups_team_fkey";

alter table "public"."athletes" add constraint "athletes_group_fkey" FOREIGN KEY ("group") REFERENCES public.athlete_groups(id) ON DELETE SET NULL not valid;

alter table "public"."athletes" validate constraint "athletes_group_fkey";

alter table "public"."athletes" add constraint "athletes_team_fkey1" FOREIGN KEY (team) REFERENCES public.teams(id) ON DELETE CASCADE not valid;

alter table "public"."athletes" validate constraint "athletes_team_fkey1";

alter table "public"."athletes" add constraint "athletes_user_fkey1" FOREIGN KEY ("user") REFERENCES public.users(id) ON DELETE SET NULL not valid;

alter table "public"."athletes" validate constraint "athletes_user_fkey1";

alter table "public"."coaches" add constraint "coaches_team_fkey" FOREIGN KEY (team) REFERENCES public.teams(id) ON DELETE CASCADE not valid;

alter table "public"."coaches" validate constraint "coaches_team_fkey";

alter table "public"."coaches" add constraint "coaches_user_fkey" FOREIGN KEY ("user") REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."coaches" validate constraint "coaches_user_fkey";

alter table "public"."team_invite_codes" add constraint "team_invite_codes_id_check" CHECK ((length(id) = 7)) not valid;

alter table "public"."team_invite_codes" validate constraint "team_invite_codes_id_check";

alter table "public"."team_invite_codes" add constraint "team_invite_codes_team_fkey" FOREIGN KEY (team) REFERENCES public.teams(id) ON DELETE CASCADE not valid;

alter table "public"."team_invite_codes" validate constraint "team_invite_codes_team_fkey";

alter table "public"."team_join_requests" add constraint "team_join_requests_invite_code_fkey" FOREIGN KEY (invite_code) REFERENCES public.team_invite_codes(id) ON DELETE CASCADE not valid;

alter table "public"."team_join_requests" validate constraint "team_join_requests_invite_code_fkey";

alter table "public"."team_join_requests" add constraint "team_join_requests_team_fkey" FOREIGN KEY (team) REFERENCES public.teams(id) ON DELETE CASCADE not valid;

alter table "public"."team_join_requests" validate constraint "team_join_requests_team_fkey";

alter table "public"."team_join_requests" add constraint "team_join_requests_user_fkey" FOREIGN KEY ("user") REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."team_join_requests" validate constraint "team_join_requests_user_fkey";

alter table "public"."team_join_requests" add constraint "team_join_requests_user_team_key" UNIQUE using index "team_join_requests_user_team_key";

alter table "public"."teams" add constraint "teams_owner_fkey" FOREIGN KEY (owner) REFERENCES public.users(id) not valid;

alter table "public"."teams" validate constraint "teams_owner_fkey";

alter table "public"."workout_rep_results" add constraint "workout_rep_results_athlete_fkey" FOREIGN KEY (athlete) REFERENCES public.athletes(id) ON DELETE CASCADE not valid;

alter table "public"."workout_rep_results" validate constraint "workout_rep_results_athlete_fkey";

alter table "public"."workout_rep_results" add constraint "workout_rep_results_rep_fkey" FOREIGN KEY (rep) REFERENCES public.workout_reps(id) ON DELETE CASCADE not valid;

alter table "public"."workout_rep_results" validate constraint "workout_rep_results_rep_fkey";

alter table "public"."workout_rep_results" add constraint "workout_rep_results_team_fkey" FOREIGN KEY (team) REFERENCES public.teams(id) ON DELETE CASCADE not valid;

alter table "public"."workout_rep_results" validate constraint "workout_rep_results_team_fkey";

alter table "public"."workout_rep_results" add constraint "workout_rep_results_workout_fkey" FOREIGN KEY (workout) REFERENCES public.workout_sessions(id) ON DELETE CASCADE not valid;

alter table "public"."workout_rep_results" validate constraint "workout_rep_results_workout_fkey";

alter table "public"."workout_reps" add constraint "workout_reps_set_fkey" FOREIGN KEY (set) REFERENCES public.workout_sets(id) ON DELETE CASCADE not valid;

alter table "public"."workout_reps" validate constraint "workout_reps_set_fkey";

alter table "public"."workout_reps" add constraint "workout_reps_team_fkey" FOREIGN KEY (team) REFERENCES public.teams(id) ON DELETE CASCADE not valid;

alter table "public"."workout_reps" validate constraint "workout_reps_team_fkey";

alter table "public"."workout_reps" add constraint "workout_reps_template_rep_fkey" FOREIGN KEY (template_rep) REFERENCES public.workout_template_reps(id) ON DELETE SET NULL not valid;

alter table "public"."workout_reps" validate constraint "workout_reps_template_rep_fkey";

alter table "public"."workout_sessions" add constraint "workout_sessions_creator_fkey" FOREIGN KEY (creator) REFERENCES public.users(id) not valid;

alter table "public"."workout_sessions" validate constraint "workout_sessions_creator_fkey";

alter table "public"."workout_sessions" add constraint "workout_sessions_team_fkey" FOREIGN KEY (team) REFERENCES public.teams(id) ON DELETE CASCADE not valid;

alter table "public"."workout_sessions" validate constraint "workout_sessions_team_fkey";

alter table "public"."workout_sessions" add constraint "workout_sessions_template_used_fkey" FOREIGN KEY (template_used) REFERENCES public.workout_templates(id) ON DELETE SET NULL not valid;

alter table "public"."workout_sessions" validate constraint "workout_sessions_template_used_fkey";

alter table "public"."workout_sets" add constraint "workout_sets_athlete_group_fkey" FOREIGN KEY (athlete_group) REFERENCES public.athlete_groups(id) not valid;

alter table "public"."workout_sets" validate constraint "workout_sets_athlete_group_fkey";

alter table "public"."workout_sets" add constraint "workout_sets_session_fkey1" FOREIGN KEY (session) REFERENCES public.workout_sessions(id) ON DELETE CASCADE not valid;

alter table "public"."workout_sets" validate constraint "workout_sets_session_fkey1";

alter table "public"."workout_sets" add constraint "workout_sets_team_fkey" FOREIGN KEY (team) REFERENCES public.teams(id) ON DELETE CASCADE not valid;

alter table "public"."workout_sets" validate constraint "workout_sets_team_fkey";

alter table "public"."workout_template_rep_result_targets" add constraint "workout_template_rep_result_targets_athlete_fkey" FOREIGN KEY (athlete) REFERENCES public.athletes(id) ON DELETE CASCADE not valid;

alter table "public"."workout_template_rep_result_targets" validate constraint "workout_template_rep_result_targets_athlete_fkey";

alter table "public"."workout_template_rep_result_targets" add constraint "workout_template_rep_result_targets_rep_fkey1" FOREIGN KEY (rep) REFERENCES public.workout_template_reps(id) ON DELETE CASCADE not valid;

alter table "public"."workout_template_rep_result_targets" validate constraint "workout_template_rep_result_targets_rep_fkey1";

alter table "public"."workout_template_rep_result_targets" add constraint "workout_template_rep_result_targets_team_fkey" FOREIGN KEY (team) REFERENCES public.teams(id) ON DELETE CASCADE not valid;

alter table "public"."workout_template_rep_result_targets" validate constraint "workout_template_rep_result_targets_team_fkey";

alter table "public"."workout_template_rep_result_targets" add constraint "workout_template_rep_result_targets_template_fkey" FOREIGN KEY (template) REFERENCES public.workout_templates(id) ON DELETE CASCADE not valid;

alter table "public"."workout_template_rep_result_targets" validate constraint "workout_template_rep_result_targets_template_fkey";

alter table "public"."workout_template_reps" add constraint "workout_template_reps_set_fkey" FOREIGN KEY (set) REFERENCES public.workout_template_sets(id) ON DELETE CASCADE not valid;

alter table "public"."workout_template_reps" validate constraint "workout_template_reps_set_fkey";

alter table "public"."workout_template_reps" add constraint "workout_template_reps_team_fkey" FOREIGN KEY (team) REFERENCES public.teams(id) ON DELETE CASCADE not valid;

alter table "public"."workout_template_reps" validate constraint "workout_template_reps_team_fkey";

alter table "public"."workout_template_sets" add constraint "workout_template_sets_athlete_group_fkey" FOREIGN KEY (athlete_group) REFERENCES public.athlete_groups(id) ON DELETE CASCADE not valid;

alter table "public"."workout_template_sets" validate constraint "workout_template_sets_athlete_group_fkey";

alter table "public"."workout_template_sets" add constraint "workout_template_sets_team_fkey" FOREIGN KEY (team) REFERENCES public.teams(id) ON DELETE CASCADE not valid;

alter table "public"."workout_template_sets" validate constraint "workout_template_sets_team_fkey";

alter table "public"."workout_template_sets" add constraint "workout_template_sets_template_fkey" FOREIGN KEY (template) REFERENCES public.workout_templates(id) ON DELETE CASCADE not valid;

alter table "public"."workout_template_sets" validate constraint "workout_template_sets_template_fkey";

alter table "public"."workout_templates" add constraint "workout_templates_creator_fkey" FOREIGN KEY (creator) REFERENCES public.users(id) ON DELETE SET NULL not valid;

alter table "public"."workout_templates" validate constraint "workout_templates_creator_fkey";

alter table "public"."workout_templates" add constraint "workout_templates_team_fkey" FOREIGN KEY (team) REFERENCES public.teams(id) ON DELETE CASCADE not valid;

alter table "public"."workout_templates" validate constraint "workout_templates_team_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.generate_team_invite_code(team_id uuid)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$DECLARE
    new_code TEXT;
BEGIN
    -- Ensure the user making invoking this fn is the team owner
    IF (SELECT auth.uid() as uid) != (SELECT teams.owner FROM teams WHERE teams.id = team_id) THEN
        RAISE EXCEPTION 'Not enough privileges';
    END IF;

    new_code :=
      upper(
        substring(
          regexp_replace(
            encode(gen_random_bytes(6), 'base64'),
            '[^A-Za-z0-9]',
            '',
            'g'
          ),
          1,
          7
        )
      );

    INSERT INTO team_invite_codes (id, team, expires_at)
    VALUES (new_code, team_id, now() + INTERVAL '72 hours');

    RETURN new_code;
END;$function$
;

CREATE OR REPLACE FUNCTION public.has_coach_privileges(user_id uuid, team_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$BEGIN
  RETURN EXISTS (
    SELECT 1 FROM coaches
    WHERE coaches."user" = user_id AND coaches.team = team_id
  );
END;$function$
;

CREATE OR REPLACE FUNCTION public.submit_workout(workout_id uuid, team_id uuid, started_at timestamp with time zone, finished_at timestamp with time zone, workout_data jsonb, creator uuid)
 RETURNS void
 LANGUAGE plpgsql
AS $function$BEGIN
    -- Create workout session
    INSERT INTO workout_sessions
    (id, type, team, creator, started_at, finished_at, template_used)
    VALUES (workout_id, (workout_data->>'type')::workout_type, team_id, creator, started_at, finished_at, (workout_data->>'template')::uuid);

    -- Insert workout sets
    INSERT INTO workout_sets
    (id, session, set_number, athlete_group, rep_count, rest_after_seconds, team)
    SELECT
      sets.id,
      workout_id AS session,
      sets."setNumber" AS set_number,
      sets."athleteGroup" AS athlete_group,
      sets."repCount" as rep_count,
      sets."restAfterSeconds" AS rest_after_seconds,
      team_id AS team
    FROM jsonb_to_recordset(workout_data->'sets')
        AS sets(
            id uuid,
            "athleteGroup" uuid,
            "setNumber" int,
            "repCount" int,
            "restAfterSeconds" int,
            "defaultRepDistance" int,
            "defaultRestAfterRepSeconds" int
        );

    -- Insert reps for every set
    INSERT INTO workout_reps
    (id, "set", rep_number, distance_m, rest_after_seconds, template_rep, team)
    SELECT
        reps.id,
        (outer_set->>'id')::uuid AS set,
        reps."repNumber" as rep_number,
        reps.distance AS distance_m,
        reps."restAfterSeconds" AS rest_after_seconds,
        reps."templateRepId" AS template_rep,
        team_id AS team
    FROM jsonb_array_elements(workout_data->'sets') AS outer_set
    CROSS JOIN LATERAL jsonb_to_recordset(outer_set->'reps')
        AS reps(
            id uuid,
            "repNumber" int,
            distance int,
            "restAfterSeconds" int,
            "templateRepId" uuid
        );

    -- Insert rep results for every rep
    INSERT INTO workout_rep_results
    (rep, athlete, time_seconds, team, workout)
    SELECT
        (outer_rep->>'id')::uuid AS rep,
        athlete_id::uuid AS athlete,
        result.time AS time_seconds,
        team_id AS team,
        workout_id AS workout
    FROM jsonb_array_elements(workout_data->'sets') AS outer_set
    CROSS JOIN LATERAL jsonb_array_elements(outer_set->'reps') AS outer_rep
    CROSS JOIN LATERAL jsonb_each(outer_rep->'results')
        AS result_kv(athlete_id, result_obj)
    CROSS JOIN LATERAL jsonb_to_record(result_obj)
        AS result(time float4);
END;$function$
;

CREATE OR REPLACE FUNCTION public.submit_workout_template(template_id uuid, team_id uuid, template_data jsonb, creator uuid)
 RETURNS void
 LANGUAGE plpgsql
AS $function$BEGIN
    -- Create workout template
    INSERT INTO workout_templates
    (id, name, type, team, creator)
    VALUES (template_id, template_data->>'name', (template_data->>'type')::workout_type, team_id, creator);

    -- Insert template sets
    INSERT INTO workout_template_sets
    (id, template, set_number, athlete_group, rep_count, rest_after_seconds, team)
    SELECT
        sets.id,
        template_id AS template,
        sets."setNumber" AS set_number,
        sets."athleteGroup" AS athlete_group,
        sets."repCount" as rep_count,
        sets."restAfterSeconds" AS rest_after_seconds,
        team_id AS team
    FROM jsonb_to_recordset(template_data->'sets')
        AS sets(
            id uuid,
            "athleteGroup" uuid,
            "setNumber" int,
            "repCount" int,
            "restAfterSeconds" int,
            "defaultRepDistance" int,
            "defaultRestAfterRepSeconds" int
        );

    -- Insert reps for every set
    INSERT INTO workout_template_reps
    (id, "set", rep_number, distance_m, rest_after_seconds, team)
    SELECT
        reps.id,
        (outer_set->>'id')::uuid AS set,
        reps."repNumber" as rep_number,
        reps.distance AS distance_m,
        reps."restAfterSeconds" AS rest_after_seconds,
        team_id AS team
    FROM jsonb_array_elements(template_data->'sets') AS outer_set
    CROSS JOIN LATERAL jsonb_to_recordset(outer_set->'reps')
        AS reps(
            id uuid,
            "repNumber" int,
            distance int,
            "restAfterSeconds" int
        );

    -- Insert rep result targets for every rep
    INSERT INTO workout_template_rep_result_targets
    (rep, athlete, target_time_seconds, team, template)
    SELECT
        (outer_rep->>'id')::uuid AS rep,
        athlete_id::uuid AS athlete,
        result.time AS target_time_seconds,
        team_id AS team,
        template_id AS template
    FROM jsonb_array_elements(template_data->'sets') AS outer_set
    CROSS JOIN LATERAL jsonb_array_elements(outer_set->'reps') AS outer_rep
    CROSS JOIN LATERAL jsonb_each(outer_rep->'targetResults')
        AS result_kv(athlete_id, result_obj)
    CROSS JOIN LATERAL jsonb_to_record(result_obj)
        AS result(time float4);
END;$function$
;

CREATE OR REPLACE FUNCTION public.use_team_invite_code(join_code text)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$DECLARE
  user_id uuid;
  team_id uuid;
BEGIN
  user_id := (SELECT auth.uid() as uid);
  team_id := (SELECT team_invite_codes.team
    FROM team_invite_codes
    WHERE team_invite_codes.id = join_code);

  INSERT INTO team_join_requests (team, "user", invite_code)
  VALUES (team_id, user_id, join_code);
END;$function$
;

grant delete on table "public"."athlete_groups" to "anon";

grant insert on table "public"."athlete_groups" to "anon";

grant references on table "public"."athlete_groups" to "anon";

grant select on table "public"."athlete_groups" to "anon";

grant trigger on table "public"."athlete_groups" to "anon";

grant truncate on table "public"."athlete_groups" to "anon";

grant update on table "public"."athlete_groups" to "anon";

grant delete on table "public"."athlete_groups" to "authenticated";

grant insert on table "public"."athlete_groups" to "authenticated";

grant references on table "public"."athlete_groups" to "authenticated";

grant select on table "public"."athlete_groups" to "authenticated";

grant trigger on table "public"."athlete_groups" to "authenticated";

grant truncate on table "public"."athlete_groups" to "authenticated";

grant update on table "public"."athlete_groups" to "authenticated";

grant delete on table "public"."athlete_groups" to "postgres";

grant insert on table "public"."athlete_groups" to "postgres";

grant references on table "public"."athlete_groups" to "postgres";

grant select on table "public"."athlete_groups" to "postgres";

grant trigger on table "public"."athlete_groups" to "postgres";

grant truncate on table "public"."athlete_groups" to "postgres";

grant update on table "public"."athlete_groups" to "postgres";

grant delete on table "public"."athlete_groups" to "service_role";

grant insert on table "public"."athlete_groups" to "service_role";

grant references on table "public"."athlete_groups" to "service_role";

grant select on table "public"."athlete_groups" to "service_role";

grant trigger on table "public"."athlete_groups" to "service_role";

grant truncate on table "public"."athlete_groups" to "service_role";

grant update on table "public"."athlete_groups" to "service_role";

grant delete on table "public"."athletes" to "postgres";

grant insert on table "public"."athletes" to "postgres";

grant references on table "public"."athletes" to "postgres";

grant select on table "public"."athletes" to "postgres";

grant trigger on table "public"."athletes" to "postgres";

grant truncate on table "public"."athletes" to "postgres";

grant update on table "public"."athletes" to "postgres";

grant delete on table "public"."coaches" to "anon";

grant insert on table "public"."coaches" to "anon";

grant references on table "public"."coaches" to "anon";

grant select on table "public"."coaches" to "anon";

grant trigger on table "public"."coaches" to "anon";

grant truncate on table "public"."coaches" to "anon";

grant update on table "public"."coaches" to "anon";

grant delete on table "public"."coaches" to "authenticated";

grant insert on table "public"."coaches" to "authenticated";

grant references on table "public"."coaches" to "authenticated";

grant select on table "public"."coaches" to "authenticated";

grant trigger on table "public"."coaches" to "authenticated";

grant truncate on table "public"."coaches" to "authenticated";

grant update on table "public"."coaches" to "authenticated";

grant delete on table "public"."coaches" to "postgres";

grant insert on table "public"."coaches" to "postgres";

grant references on table "public"."coaches" to "postgres";

grant select on table "public"."coaches" to "postgres";

grant trigger on table "public"."coaches" to "postgres";

grant truncate on table "public"."coaches" to "postgres";

grant update on table "public"."coaches" to "postgres";

grant delete on table "public"."coaches" to "service_role";

grant insert on table "public"."coaches" to "service_role";

grant references on table "public"."coaches" to "service_role";

grant select on table "public"."coaches" to "service_role";

grant trigger on table "public"."coaches" to "service_role";

grant truncate on table "public"."coaches" to "service_role";

grant update on table "public"."coaches" to "service_role";

grant delete on table "public"."team_invite_codes" to "anon";

grant insert on table "public"."team_invite_codes" to "anon";

grant references on table "public"."team_invite_codes" to "anon";

grant select on table "public"."team_invite_codes" to "anon";

grant trigger on table "public"."team_invite_codes" to "anon";

grant truncate on table "public"."team_invite_codes" to "anon";

grant update on table "public"."team_invite_codes" to "anon";

grant delete on table "public"."team_invite_codes" to "authenticated";

grant insert on table "public"."team_invite_codes" to "authenticated";

grant references on table "public"."team_invite_codes" to "authenticated";

grant select on table "public"."team_invite_codes" to "authenticated";

grant trigger on table "public"."team_invite_codes" to "authenticated";

grant truncate on table "public"."team_invite_codes" to "authenticated";

grant update on table "public"."team_invite_codes" to "authenticated";

grant delete on table "public"."team_invite_codes" to "postgres";

grant insert on table "public"."team_invite_codes" to "postgres";

grant references on table "public"."team_invite_codes" to "postgres";

grant select on table "public"."team_invite_codes" to "postgres";

grant trigger on table "public"."team_invite_codes" to "postgres";

grant truncate on table "public"."team_invite_codes" to "postgres";

grant update on table "public"."team_invite_codes" to "postgres";

grant delete on table "public"."team_invite_codes" to "service_role";

grant insert on table "public"."team_invite_codes" to "service_role";

grant references on table "public"."team_invite_codes" to "service_role";

grant select on table "public"."team_invite_codes" to "service_role";

grant trigger on table "public"."team_invite_codes" to "service_role";

grant truncate on table "public"."team_invite_codes" to "service_role";

grant update on table "public"."team_invite_codes" to "service_role";

grant delete on table "public"."team_join_requests" to "anon";

grant insert on table "public"."team_join_requests" to "anon";

grant references on table "public"."team_join_requests" to "anon";

grant select on table "public"."team_join_requests" to "anon";

grant trigger on table "public"."team_join_requests" to "anon";

grant truncate on table "public"."team_join_requests" to "anon";

grant update on table "public"."team_join_requests" to "anon";

grant delete on table "public"."team_join_requests" to "authenticated";

grant insert on table "public"."team_join_requests" to "authenticated";

grant references on table "public"."team_join_requests" to "authenticated";

grant select on table "public"."team_join_requests" to "authenticated";

grant trigger on table "public"."team_join_requests" to "authenticated";

grant truncate on table "public"."team_join_requests" to "authenticated";

grant update on table "public"."team_join_requests" to "authenticated";

grant delete on table "public"."team_join_requests" to "postgres";

grant insert on table "public"."team_join_requests" to "postgres";

grant references on table "public"."team_join_requests" to "postgres";

grant select on table "public"."team_join_requests" to "postgres";

grant trigger on table "public"."team_join_requests" to "postgres";

grant truncate on table "public"."team_join_requests" to "postgres";

grant update on table "public"."team_join_requests" to "postgres";

grant delete on table "public"."team_join_requests" to "service_role";

grant insert on table "public"."team_join_requests" to "service_role";

grant references on table "public"."team_join_requests" to "service_role";

grant select on table "public"."team_join_requests" to "service_role";

grant trigger on table "public"."team_join_requests" to "service_role";

grant truncate on table "public"."team_join_requests" to "service_role";

grant update on table "public"."team_join_requests" to "service_role";

grant delete on table "public"."workout_rep_results" to "anon";

grant insert on table "public"."workout_rep_results" to "anon";

grant references on table "public"."workout_rep_results" to "anon";

grant select on table "public"."workout_rep_results" to "anon";

grant trigger on table "public"."workout_rep_results" to "anon";

grant truncate on table "public"."workout_rep_results" to "anon";

grant update on table "public"."workout_rep_results" to "anon";

grant delete on table "public"."workout_rep_results" to "authenticated";

grant insert on table "public"."workout_rep_results" to "authenticated";

grant references on table "public"."workout_rep_results" to "authenticated";

grant select on table "public"."workout_rep_results" to "authenticated";

grant trigger on table "public"."workout_rep_results" to "authenticated";

grant truncate on table "public"."workout_rep_results" to "authenticated";

grant update on table "public"."workout_rep_results" to "authenticated";

grant delete on table "public"."workout_rep_results" to "postgres";

grant insert on table "public"."workout_rep_results" to "postgres";

grant references on table "public"."workout_rep_results" to "postgres";

grant select on table "public"."workout_rep_results" to "postgres";

grant trigger on table "public"."workout_rep_results" to "postgres";

grant truncate on table "public"."workout_rep_results" to "postgres";

grant update on table "public"."workout_rep_results" to "postgres";

grant delete on table "public"."workout_rep_results" to "service_role";

grant insert on table "public"."workout_rep_results" to "service_role";

grant references on table "public"."workout_rep_results" to "service_role";

grant select on table "public"."workout_rep_results" to "service_role";

grant trigger on table "public"."workout_rep_results" to "service_role";

grant truncate on table "public"."workout_rep_results" to "service_role";

grant update on table "public"."workout_rep_results" to "service_role";

grant delete on table "public"."workout_reps" to "anon";

grant insert on table "public"."workout_reps" to "anon";

grant references on table "public"."workout_reps" to "anon";

grant select on table "public"."workout_reps" to "anon";

grant trigger on table "public"."workout_reps" to "anon";

grant truncate on table "public"."workout_reps" to "anon";

grant update on table "public"."workout_reps" to "anon";

grant delete on table "public"."workout_reps" to "authenticated";

grant insert on table "public"."workout_reps" to "authenticated";

grant references on table "public"."workout_reps" to "authenticated";

grant select on table "public"."workout_reps" to "authenticated";

grant trigger on table "public"."workout_reps" to "authenticated";

grant truncate on table "public"."workout_reps" to "authenticated";

grant update on table "public"."workout_reps" to "authenticated";

grant delete on table "public"."workout_reps" to "postgres";

grant insert on table "public"."workout_reps" to "postgres";

grant references on table "public"."workout_reps" to "postgres";

grant select on table "public"."workout_reps" to "postgres";

grant trigger on table "public"."workout_reps" to "postgres";

grant truncate on table "public"."workout_reps" to "postgres";

grant update on table "public"."workout_reps" to "postgres";

grant delete on table "public"."workout_reps" to "service_role";

grant insert on table "public"."workout_reps" to "service_role";

grant references on table "public"."workout_reps" to "service_role";

grant select on table "public"."workout_reps" to "service_role";

grant trigger on table "public"."workout_reps" to "service_role";

grant truncate on table "public"."workout_reps" to "service_role";

grant update on table "public"."workout_reps" to "service_role";

grant delete on table "public"."workout_sessions" to "anon";

grant insert on table "public"."workout_sessions" to "anon";

grant references on table "public"."workout_sessions" to "anon";

grant select on table "public"."workout_sessions" to "anon";

grant trigger on table "public"."workout_sessions" to "anon";

grant truncate on table "public"."workout_sessions" to "anon";

grant update on table "public"."workout_sessions" to "anon";

grant delete on table "public"."workout_sessions" to "authenticated";

grant insert on table "public"."workout_sessions" to "authenticated";

grant references on table "public"."workout_sessions" to "authenticated";

grant select on table "public"."workout_sessions" to "authenticated";

grant trigger on table "public"."workout_sessions" to "authenticated";

grant truncate on table "public"."workout_sessions" to "authenticated";

grant update on table "public"."workout_sessions" to "authenticated";

grant delete on table "public"."workout_sessions" to "postgres";

grant insert on table "public"."workout_sessions" to "postgres";

grant references on table "public"."workout_sessions" to "postgres";

grant select on table "public"."workout_sessions" to "postgres";

grant trigger on table "public"."workout_sessions" to "postgres";

grant truncate on table "public"."workout_sessions" to "postgres";

grant update on table "public"."workout_sessions" to "postgres";

grant delete on table "public"."workout_sessions" to "service_role";

grant insert on table "public"."workout_sessions" to "service_role";

grant references on table "public"."workout_sessions" to "service_role";

grant select on table "public"."workout_sessions" to "service_role";

grant trigger on table "public"."workout_sessions" to "service_role";

grant truncate on table "public"."workout_sessions" to "service_role";

grant update on table "public"."workout_sessions" to "service_role";

grant delete on table "public"."workout_sets" to "anon";

grant insert on table "public"."workout_sets" to "anon";

grant references on table "public"."workout_sets" to "anon";

grant select on table "public"."workout_sets" to "anon";

grant trigger on table "public"."workout_sets" to "anon";

grant truncate on table "public"."workout_sets" to "anon";

grant update on table "public"."workout_sets" to "anon";

grant delete on table "public"."workout_sets" to "authenticated";

grant insert on table "public"."workout_sets" to "authenticated";

grant references on table "public"."workout_sets" to "authenticated";

grant select on table "public"."workout_sets" to "authenticated";

grant trigger on table "public"."workout_sets" to "authenticated";

grant truncate on table "public"."workout_sets" to "authenticated";

grant update on table "public"."workout_sets" to "authenticated";

grant delete on table "public"."workout_sets" to "postgres";

grant insert on table "public"."workout_sets" to "postgres";

grant references on table "public"."workout_sets" to "postgres";

grant select on table "public"."workout_sets" to "postgres";

grant trigger on table "public"."workout_sets" to "postgres";

grant truncate on table "public"."workout_sets" to "postgres";

grant update on table "public"."workout_sets" to "postgres";

grant delete on table "public"."workout_sets" to "service_role";

grant insert on table "public"."workout_sets" to "service_role";

grant references on table "public"."workout_sets" to "service_role";

grant select on table "public"."workout_sets" to "service_role";

grant trigger on table "public"."workout_sets" to "service_role";

grant truncate on table "public"."workout_sets" to "service_role";

grant update on table "public"."workout_sets" to "service_role";

grant delete on table "public"."workout_template_rep_result_targets" to "anon";

grant insert on table "public"."workout_template_rep_result_targets" to "anon";

grant references on table "public"."workout_template_rep_result_targets" to "anon";

grant select on table "public"."workout_template_rep_result_targets" to "anon";

grant trigger on table "public"."workout_template_rep_result_targets" to "anon";

grant truncate on table "public"."workout_template_rep_result_targets" to "anon";

grant update on table "public"."workout_template_rep_result_targets" to "anon";

grant delete on table "public"."workout_template_rep_result_targets" to "authenticated";

grant insert on table "public"."workout_template_rep_result_targets" to "authenticated";

grant references on table "public"."workout_template_rep_result_targets" to "authenticated";

grant select on table "public"."workout_template_rep_result_targets" to "authenticated";

grant trigger on table "public"."workout_template_rep_result_targets" to "authenticated";

grant truncate on table "public"."workout_template_rep_result_targets" to "authenticated";

grant update on table "public"."workout_template_rep_result_targets" to "authenticated";

grant delete on table "public"."workout_template_rep_result_targets" to "postgres";

grant insert on table "public"."workout_template_rep_result_targets" to "postgres";

grant references on table "public"."workout_template_rep_result_targets" to "postgres";

grant select on table "public"."workout_template_rep_result_targets" to "postgres";

grant trigger on table "public"."workout_template_rep_result_targets" to "postgres";

grant truncate on table "public"."workout_template_rep_result_targets" to "postgres";

grant update on table "public"."workout_template_rep_result_targets" to "postgres";

grant delete on table "public"."workout_template_rep_result_targets" to "service_role";

grant insert on table "public"."workout_template_rep_result_targets" to "service_role";

grant references on table "public"."workout_template_rep_result_targets" to "service_role";

grant select on table "public"."workout_template_rep_result_targets" to "service_role";

grant trigger on table "public"."workout_template_rep_result_targets" to "service_role";

grant truncate on table "public"."workout_template_rep_result_targets" to "service_role";

grant update on table "public"."workout_template_rep_result_targets" to "service_role";

grant delete on table "public"."workout_template_reps" to "anon";

grant insert on table "public"."workout_template_reps" to "anon";

grant references on table "public"."workout_template_reps" to "anon";

grant select on table "public"."workout_template_reps" to "anon";

grant trigger on table "public"."workout_template_reps" to "anon";

grant truncate on table "public"."workout_template_reps" to "anon";

grant update on table "public"."workout_template_reps" to "anon";

grant delete on table "public"."workout_template_reps" to "authenticated";

grant insert on table "public"."workout_template_reps" to "authenticated";

grant references on table "public"."workout_template_reps" to "authenticated";

grant select on table "public"."workout_template_reps" to "authenticated";

grant trigger on table "public"."workout_template_reps" to "authenticated";

grant truncate on table "public"."workout_template_reps" to "authenticated";

grant update on table "public"."workout_template_reps" to "authenticated";

grant delete on table "public"."workout_template_reps" to "postgres";

grant insert on table "public"."workout_template_reps" to "postgres";

grant references on table "public"."workout_template_reps" to "postgres";

grant select on table "public"."workout_template_reps" to "postgres";

grant trigger on table "public"."workout_template_reps" to "postgres";

grant truncate on table "public"."workout_template_reps" to "postgres";

grant update on table "public"."workout_template_reps" to "postgres";

grant delete on table "public"."workout_template_reps" to "service_role";

grant insert on table "public"."workout_template_reps" to "service_role";

grant references on table "public"."workout_template_reps" to "service_role";

grant select on table "public"."workout_template_reps" to "service_role";

grant trigger on table "public"."workout_template_reps" to "service_role";

grant truncate on table "public"."workout_template_reps" to "service_role";

grant update on table "public"."workout_template_reps" to "service_role";

grant delete on table "public"."workout_template_sets" to "anon";

grant insert on table "public"."workout_template_sets" to "anon";

grant references on table "public"."workout_template_sets" to "anon";

grant select on table "public"."workout_template_sets" to "anon";

grant trigger on table "public"."workout_template_sets" to "anon";

grant truncate on table "public"."workout_template_sets" to "anon";

grant update on table "public"."workout_template_sets" to "anon";

grant delete on table "public"."workout_template_sets" to "authenticated";

grant insert on table "public"."workout_template_sets" to "authenticated";

grant references on table "public"."workout_template_sets" to "authenticated";

grant select on table "public"."workout_template_sets" to "authenticated";

grant trigger on table "public"."workout_template_sets" to "authenticated";

grant truncate on table "public"."workout_template_sets" to "authenticated";

grant update on table "public"."workout_template_sets" to "authenticated";

grant delete on table "public"."workout_template_sets" to "postgres";

grant insert on table "public"."workout_template_sets" to "postgres";

grant references on table "public"."workout_template_sets" to "postgres";

grant select on table "public"."workout_template_sets" to "postgres";

grant trigger on table "public"."workout_template_sets" to "postgres";

grant truncate on table "public"."workout_template_sets" to "postgres";

grant update on table "public"."workout_template_sets" to "postgres";

grant delete on table "public"."workout_template_sets" to "service_role";

grant insert on table "public"."workout_template_sets" to "service_role";

grant references on table "public"."workout_template_sets" to "service_role";

grant select on table "public"."workout_template_sets" to "service_role";

grant trigger on table "public"."workout_template_sets" to "service_role";

grant truncate on table "public"."workout_template_sets" to "service_role";

grant update on table "public"."workout_template_sets" to "service_role";

grant delete on table "public"."workout_templates" to "anon";

grant insert on table "public"."workout_templates" to "anon";

grant references on table "public"."workout_templates" to "anon";

grant select on table "public"."workout_templates" to "anon";

grant trigger on table "public"."workout_templates" to "anon";

grant truncate on table "public"."workout_templates" to "anon";

grant update on table "public"."workout_templates" to "anon";

grant delete on table "public"."workout_templates" to "authenticated";

grant insert on table "public"."workout_templates" to "authenticated";

grant references on table "public"."workout_templates" to "authenticated";

grant select on table "public"."workout_templates" to "authenticated";

grant trigger on table "public"."workout_templates" to "authenticated";

grant truncate on table "public"."workout_templates" to "authenticated";

grant update on table "public"."workout_templates" to "authenticated";

grant delete on table "public"."workout_templates" to "postgres";

grant insert on table "public"."workout_templates" to "postgres";

grant references on table "public"."workout_templates" to "postgres";

grant select on table "public"."workout_templates" to "postgres";

grant trigger on table "public"."workout_templates" to "postgres";

grant truncate on table "public"."workout_templates" to "postgres";

grant update on table "public"."workout_templates" to "postgres";

grant delete on table "public"."workout_templates" to "service_role";

grant insert on table "public"."workout_templates" to "service_role";

grant references on table "public"."workout_templates" to "service_role";

grant select on table "public"."workout_templates" to "service_role";

grant trigger on table "public"."workout_templates" to "service_role";

grant truncate on table "public"."workout_templates" to "service_role";

grant update on table "public"."workout_templates" to "service_role";


  create policy "Enable all for coaches"
  on "public"."athlete_groups"
  as permissive
  for all
  to authenticated
using (public.has_coach_privileges(( SELECT auth.uid() AS uid), team))
with check (public.has_coach_privileges(( SELECT auth.uid() AS uid), team));



  create policy "Enable all for coaches"
  on "public"."athletes"
  as permissive
  for all
  to authenticated
using (public.has_coach_privileges(( SELECT auth.uid() AS uid), team))
with check (public.has_coach_privileges(( SELECT auth.uid() AS uid), team));



  create policy "Allow insert for team owners"
  on "public"."coaches"
  as permissive
  for insert
  to authenticated
with check ((( SELECT auth.uid() AS uid) = ( SELECT teams.owner
   FROM public.teams
  WHERE (teams.id = coaches.team))));



  create policy "Enable delete for team owner"
  on "public"."coaches"
  as permissive
  for delete
  to authenticated
using ((( SELECT auth.uid() AS uid) = ( SELECT teams.owner
   FROM public.teams
  WHERE (teams.id = coaches.team))));



  create policy "Enable read for coaches within the same team"
  on "public"."coaches"
  as permissive
  for select
  to authenticated
using (public.has_coach_privileges(( SELECT auth.uid() AS uid), team));



  create policy "Enable delete for team owner"
  on "public"."team_join_requests"
  as permissive
  for delete
  to authenticated
using ((( SELECT auth.uid() AS uid) = ( SELECT teams.owner
   FROM public.teams
  WHERE (teams.id = team_join_requests.team))));



  create policy "Enable select for team owner"
  on "public"."team_join_requests"
  as permissive
  for select
  to authenticated
using ((( SELECT auth.uid() AS uid) = ( SELECT teams.owner
   FROM public.teams
  WHERE (teams.id = team_join_requests.team))));



  create policy "Enable insert for coaches"
  on "public"."workout_rep_results"
  as permissive
  for insert
  to authenticated
with check ((public.has_coach_privileges(( SELECT auth.uid() AS uid), team) AND (EXISTS ( SELECT 1
   FROM public.workout_reps
  WHERE ((workout_reps.id = workout_rep_results.rep) AND (workout_reps.team = workout_rep_results.team))))));



  create policy "Enable read for coaches"
  on "public"."workout_rep_results"
  as permissive
  for select
  to authenticated
using (public.has_coach_privileges(( SELECT auth.uid() AS uid), team));



  create policy "Enable insert for coaches"
  on "public"."workout_reps"
  as permissive
  for insert
  to authenticated
with check ((public.has_coach_privileges(( SELECT auth.uid() AS uid), team) AND (EXISTS ( SELECT 1
   FROM public.workout_sets
  WHERE ((workout_sets.id = workout_reps.set) AND (workout_sets.team = workout_reps.team))))));



  create policy "Enable read for coaches"
  on "public"."workout_reps"
  as permissive
  for select
  to authenticated
using (public.has_coach_privileges(( SELECT auth.uid() AS uid), team));



  create policy "Enable insert for coaches"
  on "public"."workout_sessions"
  as permissive
  for insert
  to authenticated
with check (public.has_coach_privileges(( SELECT auth.uid() AS uid), team));



  create policy "Enable read for coaches"
  on "public"."workout_sessions"
  as permissive
  for select
  to authenticated
using (public.has_coach_privileges(( SELECT auth.uid() AS uid), team));



  create policy "Enable insert for coaches"
  on "public"."workout_sets"
  as permissive
  for insert
  to authenticated
with check ((public.has_coach_privileges(( SELECT auth.uid() AS uid), team) AND (EXISTS ( SELECT 1
   FROM public.workout_sessions
  WHERE ((workout_sessions.id = workout_sets.session) AND (workout_sessions.team = workout_sets.team))))));



  create policy "Enable read for coaches"
  on "public"."workout_sets"
  as permissive
  for select
  to authenticated
using (public.has_coach_privileges(( SELECT auth.uid() AS uid), team));



  create policy "Enable all for coaches"
  on "public"."workout_template_rep_result_targets"
  as permissive
  for all
  to authenticated
using ((public.has_coach_privileges(( SELECT auth.uid() AS uid), team) AND (EXISTS ( SELECT 1
   FROM public.workout_template_reps
  WHERE ((workout_template_reps.id = workout_template_rep_result_targets.rep) AND (workout_template_reps.team = workout_template_rep_result_targets.team))))))
with check ((public.has_coach_privileges(( SELECT auth.uid() AS uid), team) AND (EXISTS ( SELECT 1
   FROM public.workout_template_reps
  WHERE ((workout_template_reps.id = workout_template_rep_result_targets.rep) AND (workout_template_reps.team = workout_template_rep_result_targets.team))))));



  create policy "Enable insert for coaches"
  on "public"."workout_template_reps"
  as permissive
  for insert
  to authenticated
with check ((public.has_coach_privileges(( SELECT auth.uid() AS uid), team) AND (EXISTS ( SELECT 1
   FROM public.workout_template_sets
  WHERE ((workout_template_sets.id = workout_template_reps.set) AND (workout_template_sets.team = workout_template_reps.team))))));



  create policy "Enable read for coaches"
  on "public"."workout_template_reps"
  as permissive
  for select
  to authenticated
using (public.has_coach_privileges(( SELECT auth.uid() AS uid), team));



  create policy "Enable insert for coaches"
  on "public"."workout_template_sets"
  as permissive
  for insert
  to authenticated
with check ((public.has_coach_privileges(( SELECT auth.uid() AS uid), team) AND (EXISTS ( SELECT 1
   FROM public.workout_templates
  WHERE ((workout_templates.id = workout_template_sets.template) AND (workout_templates.team = workout_template_sets.team))))));



  create policy "Enable read for coaches"
  on "public"."workout_template_sets"
  as permissive
  for select
  to authenticated
using (public.has_coach_privileges(( SELECT auth.uid() AS uid), team));



  create policy "Enable all for coaches"
  on "public"."workout_templates"
  as permissive
  for all
  to authenticated
using (public.has_coach_privileges(( SELECT auth.uid() AS uid), team))
with check (public.has_coach_privileges(( SELECT auth.uid() AS uid), team));



  create policy "Enable delete for team owners"
  on "public"."teams"
  as permissive
  for delete
  to authenticated
using ((( SELECT auth.uid() AS uid) = owner));



  create policy "Enable insert based on uid"
  on "public"."teams"
  as permissive
  for insert
  to authenticated
with check ((( SELECT auth.uid() AS uid) = owner));
