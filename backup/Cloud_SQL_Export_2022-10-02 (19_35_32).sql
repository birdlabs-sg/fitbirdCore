--
-- PostgreSQL database dump
--

-- Dumped from database version 14.4
-- Dumped by pg_dump version 14.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: Equipment; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."Equipment" AS ENUM (
    'DUMBBELL',
    'BARBELL',
    'KETTLEBELL',
    'CABLE',
    'LEVER',
    'SUSPENSION',
    'T_BAR',
    'TRAP_BAR',
    'SLED',
    'SMITH',
    'BENCH',
    'MEDICINE_BALL',
    'PREACHER',
    'PARALLEL_BARS',
    'PULL_UP_BAR',
    'STABILITY_BALL'
);


--
-- Name: ExcerciseForce; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."ExcerciseForce" AS ENUM (
    'PUSH',
    'PULL'
);


--
-- Name: ExcerciseMechanics; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."ExcerciseMechanics" AS ENUM (
    'COMPOUND',
    'ISOLATED'
);


--
-- Name: ExcerciseMetadataState; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."ExcerciseMetadataState" AS ENUM (
    'LEARNING',
    'INCREASED_DIFFICULTY',
    'DECREASED_DIFFICULTY',
    'MAINTAINENCE'
);


--
-- Name: ExcerciseSetGroupState; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."ExcerciseSetGroupState" AS ENUM (
    'DELETED_TEMPORARILY',
    'DELETED_PERMANANTLY',
    'REPLACEMENT_TEMPORARILY',
    'REPLACEMENT_PERMANANTLY',
    'NORMAL_OPERATION'
);


--
-- Name: ExcerciseUtility; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."ExcerciseUtility" AS ENUM (
    'BASIC',
    'AUXILIARY'
);


--
-- Name: FailureReason; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."FailureReason" AS ENUM (
    'INSUFFICIENT_TIME',
    'INSUFFICIENT_REST_TIME',
    'TOO_DIFFICULT',
    'LOW_MOOD',
    'INSUFFICIENT_SLEEP'
);


--
-- Name: Gender; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."Gender" AS ENUM (
    'MALE',
    'FEMALE',
    'RATHER_NOT_SAY'
);


--
-- Name: Goal; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."Goal" AS ENUM (
    'BODY_RECOMPOSITION',
    'STRENGTH',
    'KEEPING_FIT',
    'ATHLETICISM',
    'OTHERS'
);


--
-- Name: LengthUnit; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."LengthUnit" AS ENUM (
    'CM',
    'MM',
    'MTR',
    'FT'
);


--
-- Name: LevelOfExperience; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."LevelOfExperience" AS ENUM (
    'BEGINNER',
    'MID',
    'ADVANCED',
    'EXPERT'
);


--
-- Name: MuscleRegionType; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."MuscleRegionType" AS ENUM (
    'HIPS',
    'UPPER_ARM',
    'SHOULDER',
    'WAIST',
    'CALVES',
    'THIGHS',
    'BACK',
    'CHEST',
    'FORE_ARM',
    'NECK'
);


--
-- Name: WeightUnit; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."WeightUnit" AS ENUM (
    'KG',
    'LB'
);


--
-- Name: WorkoutState; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."WorkoutState" AS ENUM (
    'UNATTEMPTED',
    'IN_PROGRESS',
    'COMPLETED',
    'DRAFT'
);


--
-- Name: WorkoutType; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."WorkoutType" AS ENUM (
    'AI_MANAGED',
    'SELF_MANAGED',
    'COACH_MANAGED'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: BroadCast; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."BroadCast" (
    broad_cast_id integer NOT NULL,
    broadcast_message text NOT NULL,
    scheduled_start timestamp(3) without time zone NOT NULL,
    scheduled_end timestamp(3) without time zone NOT NULL
);


--
-- Name: BroadCast_broad_cast_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."BroadCast_broad_cast_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: BroadCast_broad_cast_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."BroadCast_broad_cast_id_seq" OWNED BY public."BroadCast".broad_cast_id;


--
-- Name: Excercise; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Excercise" (
    excercise_name text NOT NULL,
    excercise_preparation text,
    excercise_instructions text,
    excercise_tips text,
    excercise_utility public."ExcerciseUtility"[],
    excercise_mechanics public."ExcerciseMechanics"[],
    excercise_force public."ExcerciseForce"[],
    equipment_required public."Equipment"[],
    body_weight boolean NOT NULL,
    assisted boolean NOT NULL
);


--
-- Name: ExcerciseMetadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."ExcerciseMetadata" (
    excercise_metadata_state public."ExcerciseMetadataState" DEFAULT 'LEARNING'::public."ExcerciseMetadataState" NOT NULL,
    "haveRequiredEquipment" boolean,
    preferred boolean,
    last_excecuted timestamp(3) without time zone,
    best_weight double precision DEFAULT 0 NOT NULL,
    weight_unit public."WeightUnit" DEFAULT 'KG'::public."WeightUnit" NOT NULL,
    best_rep integer DEFAULT 0 NOT NULL,
    rest_time_lower_bound integer DEFAULT 90 NOT NULL,
    rest_time_upper_bound integer DEFAULT 180 NOT NULL,
    user_id integer NOT NULL,
    excercise_name text NOT NULL
);


--
-- Name: ExcerciseSet; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."ExcerciseSet" (
    excercise_set_id integer NOT NULL,
    target_weight double precision NOT NULL,
    weight_unit public."WeightUnit" NOT NULL,
    target_reps integer NOT NULL,
    actual_weight double precision,
    actual_reps integer,
    excercise_set_group_id integer NOT NULL
);


--
-- Name: ExcerciseSetGroup; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."ExcerciseSetGroup" (
    excercise_set_group_id integer NOT NULL,
    excercise_name text NOT NULL,
    workout_id integer NOT NULL,
    excercise_set_group_state public."ExcerciseSetGroupState" NOT NULL,
    failure_reason public."FailureReason"
);


--
-- Name: ExcerciseSetGroup_excercise_set_group_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."ExcerciseSetGroup_excercise_set_group_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ExcerciseSetGroup_excercise_set_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."ExcerciseSetGroup_excercise_set_group_id_seq" OWNED BY public."ExcerciseSetGroup".excercise_set_group_id;


--
-- Name: ExcerciseSet_excercise_set_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."ExcerciseSet_excercise_set_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ExcerciseSet_excercise_set_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."ExcerciseSet_excercise_set_id_seq" OWNED BY public."ExcerciseSet".excercise_set_id;


--
-- Name: Measurement; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Measurement" (
    measurement_id integer NOT NULL,
    measured_at timestamp(3) without time zone NOT NULL,
    measurement_value double precision NOT NULL,
    length_units public."LengthUnit" NOT NULL,
    user_id integer NOT NULL,
    muscle_region_id integer NOT NULL
);


--
-- Name: Measurement_measurement_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Measurement_measurement_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Measurement_measurement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Measurement_measurement_id_seq" OWNED BY public."Measurement".measurement_id;


--
-- Name: MuscleRegion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."MuscleRegion" (
    muscle_region_id integer NOT NULL,
    muscle_region_name text NOT NULL,
    muscle_region_description text,
    muscle_region_type public."MuscleRegionType" NOT NULL
);


--
-- Name: MuscleRegion_muscle_region_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."MuscleRegion_muscle_region_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: MuscleRegion_muscle_region_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."MuscleRegion_muscle_region_id_seq" OWNED BY public."MuscleRegion".muscle_region_id;


--
-- Name: Notification; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Notification" (
    notification_id integer NOT NULL,
    notification_message text NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: Notification_notification_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Notification_notification_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Notification_notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Notification_notification_id_seq" OWNED BY public."Notification".notification_id;


--
-- Name: User; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."User" (
    user_id integer NOT NULL,
    email text NOT NULL,
    firebase_uid text NOT NULL,
    "displayName" text NOT NULL,
    prior_years_of_experience double precision,
    level_of_experience public."LevelOfExperience",
    age integer,
    dark_mode boolean DEFAULT false NOT NULL,
    automatic_scheduling boolean DEFAULT true NOT NULL,
    workout_frequency integer,
    workout_duration integer,
    goal public."Goal",
    gender public."Gender",
    weight double precision,
    height double precision,
    weight_unit public."WeightUnit",
    height_unit public."LengthUnit",
    "phoneNumber" text,
    compound_movement_rep_lower_bound integer DEFAULT 3 NOT NULL,
    compound_movement_rep_upper_bound integer DEFAULT 10 NOT NULL,
    isolated_movement_rep_lower_bound integer DEFAULT 5 NOT NULL,
    isolated_movement_rep_upper_bound integer DEFAULT 15 NOT NULL,
    equipment_accessible public."Equipment"[],
    body_weight_rep_lower_bound integer DEFAULT 8 NOT NULL,
    body_weight_rep_upper_bound integer DEFAULT 20 NOT NULL,
    workout_type_enrollment public."WorkoutType" DEFAULT 'SELF_MANAGED'::public."WorkoutType" NOT NULL
);


--
-- Name: User_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."User_user_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: User_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."User_user_id_seq" OWNED BY public."User".user_id;


--
-- Name: Workout; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Workout" (
    workout_id integer NOT NULL,
    workout_name text NOT NULL,
    life_span integer NOT NULL,
    order_index integer NOT NULL,
    date_scheduled timestamp(3) without time zone,
    date_completed timestamp(3) without time zone,
    performance_rating double precision,
    user_id integer NOT NULL,
    workout_state public."WorkoutState" DEFAULT 'UNATTEMPTED'::public."WorkoutState" NOT NULL,
    workout_type public."WorkoutType" DEFAULT 'SELF_MANAGED'::public."WorkoutType" NOT NULL
);


--
-- Name: Workout_workout_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."Workout_workout_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: Workout_workout_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."Workout_workout_id_seq" OWNED BY public."Workout".workout_id;


--
-- Name: _BroadCastToUser; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."_BroadCastToUser" (
    "A" integer NOT NULL,
    "B" integer NOT NULL
);


--
-- Name: _dynamic; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public._dynamic (
    "A" text NOT NULL,
    "B" integer NOT NULL
);


--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


--
-- Name: _stabilizer; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public._stabilizer (
    "A" text NOT NULL,
    "B" integer NOT NULL
);


--
-- Name: _synergist; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public._synergist (
    "A" text NOT NULL,
    "B" integer NOT NULL
);


--
-- Name: _target; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public._target (
    "A" text NOT NULL,
    "B" integer NOT NULL
);


--
-- Name: BroadCast broad_cast_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."BroadCast" ALTER COLUMN broad_cast_id SET DEFAULT nextval('public."BroadCast_broad_cast_id_seq"'::regclass);


--
-- Name: ExcerciseSet excercise_set_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ExcerciseSet" ALTER COLUMN excercise_set_id SET DEFAULT nextval('public."ExcerciseSet_excercise_set_id_seq"'::regclass);


--
-- Name: ExcerciseSetGroup excercise_set_group_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ExcerciseSetGroup" ALTER COLUMN excercise_set_group_id SET DEFAULT nextval('public."ExcerciseSetGroup_excercise_set_group_id_seq"'::regclass);


--
-- Name: Measurement measurement_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Measurement" ALTER COLUMN measurement_id SET DEFAULT nextval('public."Measurement_measurement_id_seq"'::regclass);


--
-- Name: MuscleRegion muscle_region_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."MuscleRegion" ALTER COLUMN muscle_region_id SET DEFAULT nextval('public."MuscleRegion_muscle_region_id_seq"'::regclass);


--
-- Name: Notification notification_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Notification" ALTER COLUMN notification_id SET DEFAULT nextval('public."Notification_notification_id_seq"'::regclass);


--
-- Name: User user_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."User" ALTER COLUMN user_id SET DEFAULT nextval('public."User_user_id_seq"'::regclass);


--
-- Name: Workout workout_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Workout" ALTER COLUMN workout_id SET DEFAULT nextval('public."Workout_workout_id_seq"'::regclass);


--
-- Data for Name: BroadCast; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."BroadCast" (broad_cast_id, broadcast_message, scheduled_start, scheduled_end) FROM stdin;
\.


--
-- Data for Name: Excercise; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Excercise" (excercise_name, excercise_preparation, excercise_instructions, excercise_tips, excercise_utility, excercise_mechanics, excercise_force, equipment_required, body_weight, assisted) FROM stdin;
Barbell Close Grip Bench Press	Lie on bench and grasp barbell from rack with shoulder width grip.	Lower weight to chest with elbows close to body. Push barbell back up until arms are straight. Repeat.	Grip can be slightly narrower than shoulder width but not too close. Too close of grip can decrease range of motion, may tend to hyper-adduct wrist joint, and unnecessarily decrease stability of bar. Also see Bench Press Analysis.	{BASIC}	{COMPOUND}	{PUSH}	{BARBELL,BENCH}	f	f
Barbell Close Grip Incline Bench Press	Lie on bench with bar above chest. Grasp bar from rack with shoulder width or slightly narrower grip. Disengage bar by rotating bar back.	Lower weight to chest with elbows close to body. Push barbell up until arms are straight. Repeat.	Grip can be slightly narrower than shoulder width but not too close. Also see Bench Press Analysis.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{BARBELL,BENCH}	f	f
Barbell Lying Triceps Extension	Lie on bench with narrow overhand grip on barbell. Position barbell over forehead with arms extended.	Lower bar by bending elbows. As bar nears head, move elbows slightly back just enough to allow bar to clear around curvature of head. Extend arms. As bar clears head, reposition elbows to their former position until arms are fully extended. Repeat.	With arms fully extended, bar can be brought back over upper chest. Shoulders can be internally rotated between repetitions as needed to allow for relative release of tension in muscles. Barbell can be received from the floor or from rack either situated over abdomen or from behind head. Exercise can also be performed with straight barbell. Movement with cambared bar as shown above is also known as EZ Barbell or EZ Bar Lying Triceps Extension.	{BASIC}	{ISOLATED}	{PUSH}	{BARBELL,BENCH}	f	f
Barbell Decline Triceps Extension	Lie on decline bench with narrow overhand grip on barbell. Position barbell over shoulders with arms extended.	Lower bar by bending elbows. As bar nears head, move elbows slightly back just enough to allow bar to clear around curvature of head. Extend arms. As bar clears head, reposition elbows to its former position until arms are fully extended. Repeat.	With arms fully extended, bar can be brought back over shoulders. Shoulders can be internally rotated between repetitions as needed to allow for relative release of tension in muscles. Either straight barbell or EZ barbell can be used.	{BASIC}	{ISOLATED}	{PUSH}	{BARBELL,BENCH}	f	f
Barbell Incline Triceps Extension	Lie on slightly incline bench with narrow overhand grip on barbell. Position barbell over shoulders with arms extended.	Lower bar by bending elbows. As bar nears head, move elbows slightly back just enough to allow bar to clear around curvature of head. Extend arms. As bar clears head, reposition elbows to their former position until arms are fully extended. Repeat.	With arms fully extended, bar can be brought back over shoulders. Shoulders can be internally rotated between repetitions as needed to allow for relative release of tension in muscles. Either straight barbell or EZ barbell can be used. See exercise performed seated on incline bench with shorter back.	{BASIC}	{ISOLATED}	{PUSH}	{BARBELL,BENCH}	f	f
Barbell Lying Triceps Extension "Skull Crusher"	Lie on bench with narrow overhand grip on barbell. Position barbell over shoulders with arms extended.	Lower bar to forehead by bending elbows. Extend arms and repeat.	Slow barbell's descent as it approaches forehead. Exercise can also be performed with elbow traveling slightly back during extension. With this altered form, barbell essentially moves in straight line, up and down, over forehead. Either straight barbell or EZ barbell can be used. See Lying Triceps Extension Bench with rack.	{BASIC}	{ISOLATED}	{PUSH}	{BARBELL,BENCH}	f	f
Barbell Triceps Extension	Sit on utility weight bench with barbell. Position barbell overhead with narrow overhand grip.	Lower barbell behind upper shoulders by flexing elbows allowing forearms to travel behind upper arms with elbows remaining overhead. Raise barbell overhead by extending elbows until arms are positioned straight and vertical. Lower and repeat.	Let barbell pull arm back to maintain full shoulder flexion. Exercise may be performed standing or on seat with or without back support. Either straight barbell or EZ barbell can be used.	{BASIC,AUXILIARY}	{ISOLATED}	{PUSH}	{BARBELL,BENCH}	f	f
Barbell Reclined Triceps Extension	Sit on incline bench angled at 70° to 80° with barbell. Position barbell overhead with narrow overhand grip.	Lower barbell behind neck by flexing elbows allowing forearms to travel behind upper arms with elbows remaining overhead. Raise barbell overhead by extending elbows until arms are positioned straight and vertical. Lower and repeat.	Reclined position can be used instead of standard form for those who lack ability to fully flex shoulder. Bench inclined 70° to 80° is equivalent to reclined upright position 10° to 20° from vertical. Keep elbows pointed upward. Either straight barbell or EZ barbell can be used.	{BASIC,AUXILIARY}	{ISOLATED}	{PUSH}	{BARBELL,BENCH}	f	f
Cable Bar Bent-over Triceps Extension	Stand facing outward behind cable bar and pulleys. Grasp cable bar from medium high pulley with narrow or shoulder width overhand grip. Push cable bar down to straighten arms. Lunge forward and bend over with arms positioned straight forward. Allow bar to be pulled back over neck under resistance of weight while keeping elbows pointed forward.	Extend forearms forward until elbows are straight. Allow cable bar to return back over neck. Repeat.	Let cable resistance pull arms back to maintain degree of shoulder flexion, dependent upon flexibility.	{BASIC,AUXILIARY}	{ISOLATED}	{PUSH}	{CABLE}	f	f
Cable Incline Triceps Extension	Grasp cable bar from behind with narrow overhand grip. Position elbows overhead.	Extend forearm overhead until elbows are straight. Lower until forearms are against upper arms. Repeat.	Avoid using shoulders by attempting to press bar over head. If incline is designed to pivot back, lean seat back for mount & dismount.	{BASIC}	{ISOLATED}	{PUSH}	{CABLE}	f	f
Cable Lying Triceps Extension	Lie on bench and grasp bar with narrow overhand grip. With arms extended, position bar over face.	Lower bar by bending elbow. As bar nears head, move elbows slightly back just enough to allow bar to clear around curvature of head. Extend arm. As bar clears head, reposition elbows to its former position until arm is fully extended. Repeat.	Bar may be propped up with one end leaning against head of bench to allow easier access. With arms fully extended, shoulders can be internally rotated between repetitions as needed to allow for relative release of tension in muscles.	{BASIC}	{ISOLATED}	{PUSH}	{CABLE,BENCH}	f	f
Cable Bar Lying Triceps Extension	Lie on bench and grasp cable bar with narrow overhand grip. With arms extended, position bar over face.	Lower cable bar by bending elbow. As cable bar nears head, move elbows slightly back just enough to allow cable bar to clear around curvature of head. Extend arm. As cable bar clears head, reposition elbows to its former position until arm is fully extended. Repeat.	Cable bar may be propped up on end of bench to allow easier access. With arms fully extended, shoulders can be internally rotated between repetitions as needed to allow for relative release of tension in muscles.	{BASIC}	{ISOLATED}	{PUSH}	{CABLE,BENCH}	f	f
Cable Decline Triceps Extension	Position legs under lower leg pad and lie back on bench. Grasp bar with narrow overhand grip. Position bar near forehead or top of head.	Extend elbows to raise bar attachment until arms are straight. As arms extended, position them vertically. Lower bar by bending elbows. As bar nears head, reposition elbows back just enough to allow bar to clear around curvature of head. Repeat.	A very low pulley and/or high decline is needed to achieve full range of motion at bottom position. With arms fully extended, shoulders can be internally rotated between repetitions as needed to allow for relative release of tension in muscles.	{BASIC}	{ISOLATED}	{PUSH}	{CABLE,BENCH}	f	f
Cable Pushdown	Face high pulley and grasp cable attachment with narrow overhand grip. Position elbows to side.	Extend arms down. Return until forearm is close to upper arm. Repeat.	The elbow can travel up slightly at top of motion. Stay close to cable to provide resistance at top of motion.	{BASIC,AUXILIARY}	{ISOLATED}	{PUSH}	{CABLE}	f	f
Cable Alternating Seated Pushdown	Sit on seat or bench in font of two close high pulleys. Grasp stirrup with each hand (over or underhand grip). Position elbows to side.	Push one stirrup down by extending elbow until arm is straight. Return until forearm returns to original positon, keeping elbow close to side. Repeat with opposite arm and alternate.	If seat is positioned back behind pulleys as shown, bending forward can provide resistance at top of motion. See Angle of Pull.	{AUXILIARY}	{ISOLATED}	{PUSH}	{CABLE,BENCH}	f	f
Cable Bar Pushdown	Position adjustable pulleys slightly above head. Face cable bar and grasp with overhand narrow grip. Position elbows to side.	Extend arms down. Return until forearm is close to upper arm. Repeat.	The elbow can travel up slightly at top of motion. Stay close to cable to provide resistance at top of motion.	{BASIC,AUXILIARY}	{ISOLATED}	{PUSH}	{CABLE}	f	f
Cable Pushdown (forward leaning)	Face high pulley and grasp revolving bar cable attachment with overhand grip. Position one leg back and bend forward leg with body leaning forward. Position revolving bar down in front of face with forearms nearing vertical.	Push cable bar downward by extending arms until elbows are straight. Return to front of face until forearms are nearly vertical and close to upper arm. Repeat.	Position face close to cable to provide resistance at top of motion. Elbows is brought close to body so arms are vertical at bottom of motion, either at or near the end of full extension, or in one movement as bar is pushed downward.	{BASIC,AUXILIARY}	{ISOLATED}	{PUSH}	{CABLE}	f	f
Cable Incline Pushdown	Lie on incline bench facing away from high pulley. Grasp cable attachment overhead with overhand narrow grip. Position elbow to sides, slightly up.	Extend arms with elbows stationary. Return until forearm is close to upper arm. Repeat.	If high pulley is adjustable, lower pulley slightly to provide resistance at top of motion. If high pulley is fixed, position bench distance away from cable column. If incline is positioned too high, range of motion at lower position may be compromised.	{AUXILIARY}	{ISOLATED}	{PUSH}	{CABLE,BENCH}	f	f
Cable One Arm Pushdown	Grasp dumbbell cable attachment with underhand grip. Position elbow to side.	Extend arm down. Return until forearm is close to upper arm. Repeat. Continue with opposite arm.	The elbow can travel up few inches at top of motion. Step close to cable to provide resistance at top of motion.	{AUXILIARY}	{ISOLATED}	{PUSH}	{DUMBBELL,CABLE}	f	f
Cable Triceps Dip	Step between shoulder width dip bars with dip belt around waist. Kneel as close to low pulley and attach cable to dip belt. Stand up and mount dip bar, arms straight with shoulders above hands. Keep hips straight.	Lower body by bending arms until slight stretch is felt in shoulders. Push body up until arms are straight. Repeat.	If cable dip machine is not available, A dip bar placed in front of low pully cable. Also see rear view and Cable Chest Dip.	{BASIC}	{COMPOUND}	{PUSH}	{CABLE}	f	f
Lever Bent-over Fly	Stand on platform in front of Lever Iron Cross Machine. Grasp handles to each side. Bend over at hips with knees and elbows bent slightly. Internally rotate shoulders so elbows are pointing upward.	Bring lever handles together in hugging motion with elbows in fixed position. Keep shoulders internally rotated so elbows are pointed upward at top and out to sides at bottom. Return to starting position until chest muscles are stretched. Repeat.	Height of platform should allow shoulders to be near the same height of fulcrums. Secondary levers compensate somewhat for variations if alignment between points of rotation (lever fulcrum and shoulder girdle articulation). Under greater resistance, height of platform can be increased so torso can be positioned at lower angle downward (by bending over at hips). This will allow upper body weight to counterbalance upward pull of levers. See Lever Seated Iron Cross Fly and Lever Iron Cross for Lats.	{AUXILIARY}	{ISOLATED}	{PUSH}	{LEVER}	f	f
Sled 45° Leg Press	Sit on machine with back on padded support. Place feet on platform. Extend hips and knees. Release dock lever and grasp handles to sides.	Lower sled by flexing hips and knees until knees are just short of complete flexion. Return by extending knees and hips. Repeat.	Adjust safety brace and back support to accommodate near full range of motion without forcing hips to bend at waist. Keep knees pointed same directions as feet. Do not allow heels to raise off of platform, pushing with both heel and forefoot. Placing feet slightly high on platform emphasizes Gluteus Maximus. Placing feet slightly lower on platform emphasizes Quadriceps. See exercise performed on Bilateral Leg Press. Also see Locking Out Knees on Leg Press.	{BASIC}	{COMPOUND}	{PUSH}	{LEVER,SLED}	f	f
Cable Side Triceps Extension	Grasp stirrup from medium high pulley. Turn body so pulley is to side of free arm while lifting stirrup over head. Step forward, just slightly to allow stirrup to be placed behind head, just over shoulder. Place elbow just slightly higher than shoulder height and position palm down.	Push stirrup out to side by extending forearm until elbow is straight. Allow stirrup to return back over shoulder. Repeat and repeat. Continue with opposite arm.	Stand far enough away from pulley to keep cable taut in lowered position. Keep elbow approximately same position throughout movement.	{AUXILIARY}	{ISOLATED}	{PUSH}	{CABLE}	f	f
Cable Triceps Extension	Stand or sit on bench or seat with back support just below shoulders. Position cable bar behind neck or shoulders with narrow overhand grip. Position elbows overhead.	Raise cable bar overhead by extending elbows until arms are positioned straight and vertical. Lower cable bar behind neck by flexing elbows allowing forearms to travel behind upper arms with elbows remaining overhead. Repeat.	Let cable attachment pull arm back to maintain full shoulder flexion.	{BASIC,AUXILIARY}	{ISOLATED}	{PUSH}	{CABLE,BENCH}	f	f
Cable One Arm Triceps Extension (pronated grip)	Grasp stirrup cable attachment from behind. Place hand with cable behind neck, palm facing away from neck and elbow positioned upward.	Extend arm upward. Return and repeat. Continue with opposite arm.	Let cable pull arm back to maintain full shoulder flexion. Also see exercise with Supinated Grip.	{AUXILIARY}	{ISOLATED}	{PUSH}	{CABLE}	f	f
Cable One Arm Triceps Extension (supinated grip)	Grasp stirrup cable attachment from behind. Place hand with cable behind neck, palm facing toward neck and elbow positioned upward.	Extend arm upward. Return and repeat. Continue with opposite arm.	Let cable pull arm back to maintain full shoulder flexion. Exercise can also be performed on traditional low pulley setup. Also see exercise with Pronated Grip.	{AUXILIARY}	{ISOLATED}	{PUSH}	{CABLE}	f	f
Dumbbell Lying Triceps Extension	Lie on bench and position dumbbells over head with arms extended.	Lower dumbbells by bending elbow until they are to sides of head. Extend arm. Repeat.	With arms fully extended, dumbbells can be brought to upper chest between repetitions as needed to allow for relative release of tension in muscles.	{BASIC,AUXILIARY}	{ISOLATED}	{PUSH}	{DUMBBELL,BENCH}	f	f
Dumbbell Decline Triceps Extension	Lie on decline bench and position dumbbells over shoulders with arms extended.	Lower dumbbells by bending elbow until they are to sides of head; dumbbells touch shoulder. Extend arm. Repeat.	Keep elbows pointed up or just slightly back throughout movement.	{AUXILIARY}	{ISOLATED}	{PUSH}	{DUMBBELL,BENCH}	f	f
Dumbbell Incline Triceps Extension	Lie supine on incline bench with back of head on upper corner of bench. Position dumbbells over head with arms extended.	Lower dumbbells by bending elbow until they are to sides of head. Extend arm and repeat.	Movement can also be performed on old fashioned incline bench without seat.	{AUXILIARY}	{ISOLATED}	{PUSH}	{DUMBBELL,BENCH}	f	f
Lever Pushdown	Sit on seat and grasp handles by shoulders. Position elbows to sides.	Push lever down beyond hips until arm is fully extended. Return and repeat.	Also see movement performed on alternative machine.	{BASIC,AUXILIARY}	{ISOLATED}	{PUSH}	{LEVER}	f	f
Lever Triceps Dip	If possible, place handles in narrow position. Sit on seat with legs under pads. Grasp handles and position elbows back.	Push levers down by straightening arms downward. Allow lever bar to raise with elbows pointing back until shoulders are slightly stretched. Repeat.	See exercise on alternative machine. Also see Lever Chest Dip on machine facing away from fulcrum and Lever Chest Dip.	{BASIC}	{COMPOUND}	{PUSH}	{LEVER}	f	f
Lever Incline Triceps Extension	Sit on seat and lie back on back support. Push foot lever down with foot and grasp lever handles from behind. With lever handles behind head, place both feet on support or floor.	Push lever handles up over head until arms are fully extended. Return and repeat.	When finished, push foot lever down, release handles, then release foot lever.	{BASIC,AUXILIARY}	{ISOLATED}	{PUSH}	{LEVER}	f	f
Lever Overhead Triceps Extension	Sit on seat. Push foot lever down with foot and grasp lever handles from behind. With lever handles behind neck, place both feet on support or floor.	Push lever handles up over head until arms are fully extended. Return and repeat.	When finished, push foot lever down, release handles, then release foot lever.	{BASIC,AUXILIARY}	{ISOLATED}	{PUSH}	{LEVER}	f	f
Lever Seated Close Grip Press	Sit on seat with chest at height of handles. Grasp handles with shoulder width or slightly narrower overhand grip, just against sides of chest; elbows somewhat down to sides.	Press lever until arms are extended. Return weight until forearm is against upper arm. Repeat.	If lever arms freely move together or apart, keep moderately close grip throughout movement. Triceps will not be as involved in movement if grip is lower than chest. Seat height should be adjusted so bar is at least lower chest height. Also Lever Parallel Grip Bench Press for chest.	{BASIC}	{COMPOUND}	{PUSH}	{LEVER,BENCH}	f	f
Lever Close Grip Incline Bench Press	Lie on incline bench with parallel lever bars close to sides of chest. Grasp handles with shoulder width grip.	Press lever until arms are ext ended. Return weight until wrists are at side of chest. Repeat.	Also Lever Parallel Grip Incline Bench Press for upper chest.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{LEVER,BENCH}	f	f
Dumbbell Triceps Extension	Position one dumbbell over head with both hands under inner plate (heart shaped grip).	With elbows over head, lower forearm behind upper arm by flexing elbows. Flex wrists at bottom to avoid hitting dumbbell on back of neck. Raise dumbbell over head by extending elbows while hyperextending wrists. Return and repeat.	Position wrists closer together to keep elbows from pointing out too much. Let dumbbell pull back arm to maintain full shoulder flexion. Consider using seat with back support as illustrated. Back support should not be so high that it interferes with dumbbell being completely lowered (i.e. full range of motion). If shoulder flexion flexibility is not adequate, position hips slightly forward (as illustrated) so elbows are positioned upward. Position body more upright if shoulder flexion flexibility is adequate. See suggested mount & dismount.	{BASIC,AUXILIARY}	{ISOLATED}	{PUSH}	{DUMBBELL}	f	f
Dumbbell Reclined Triceps Extension	Sit on incline bench angled at 70° to 80° with dumbbells in each hand. Position dumbbells over each shoulder with arms straight and vertical.	Lower dumbbells behind each side of neck by flexing elbows allowing forearms to travel behind upper arms with elbows remaining overhead. Raise dumbbells overhead by extending elbows until arms are positioned straight and vertical. Lower and repeat.	Reclined position can be used instead of upright position for those who lack ability to fully flex shoulder. Bench inclined 70° to 80° is equivalent to reclined upright position 10° to 20° from vertical. Back support should not be so high that it interferes with dumbbells being completely lowered (ie: full range of motion). Keep elbow pointed upward so movement does not resemble overhead press.	{BASIC,AUXILIARY}	{ISOLATED}	{PUSH}	{DUMBBELL,BENCH}	f	f
Lever Overhand Triceps Dip	Sit on seat with back against pad. Gra sp end of handles with overhand grip and position elbows back.	Push levers down by straightening arms downward. Allow lever bar to raise with elbows pointing back until shoulders are slightly stretched. Repeat.	Also see parallel grip Lever Triceps Dip and Lever Chest Dip.	{BASIC}	{COMPOUND}	{PUSH}	{LEVER}	f	f
Smith Close Grip Bench Press	Lie on bench with bar above chest and grasp bar with shoulder width or slightly narrower grip. Disengage bar by rotating bar back.	Lower weight to chest with elbows close to body. Push bar back up until arms are straight. Repeat.	Grip can be slightly narrower than shoulder width but not too close. Also see Bench Press Analysis.	{BASIC}	{COMPOUND}	{PUSH}	{SMITH,BENCH}	f	f
Sled Standing Triceps Dip	Stand between handles facing machine. Grasp parallel handles and position elbows back. Squat down slightly by bending hips and knees, just enough to raise selected weight up from remaining weight stack.	Push levers down by straightening arms downward. Allow lever bar to raise with elbows pointing back until slight stretch is felt in shoulders. Repeat.	This particular machine design is rare. See typical dip machines:	{BASIC}	{COMPOUND}	{PUSH}	{LEVER,SLED}	f	f
Smith Close Grip Incline Bench Press	Lie on incline bench with bar above chest and grasp bar with shoulder width or slightly narrower grip. Disengage bar by rotating bar back.	Lower weight to chest with elbows close to body. Push bar back up until arms are straight. Repeat.	Grip can be slightly narrower than shoulder width but not too close. Also see Bench Press Analysis.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{SMITH,BENCH}	f	f
Bench Dip	Sit on inside of one of two benches placed parallel, slightly less than leg's length away. Place hands on edge of bench, straighten arms, slide rear end off of bench, and position heels on adjacent bench with legs straight.	Lower body by bending arms until slight stretch is felt in chest or shoulder, or rear end touches floor. Raise body and repeat.	Bench height should allow for full range of motion.	{BASIC}	{COMPOUND}	{PUSH}	{BENCH}	t	f
Close Grip Push-up	Lie prone on floor with hands under shoulders or slightly narrower. Position body up off floor with extended arms and body straight.	Keeping body straight, lower body to floor by bending arms. Push body up until arms are extended. Repeat.	Both upper and lower body must be kept straight throughout movement. See wider grip push-up.	{BASIC}	{COMPOUND}	{PUSH}	{}	t	f
Close Grip Decline Pushup	Kneel on floor with bench or elevation behind body. Position hands on floor with hands under shoulders or slightly narrower. Place feet on bench or elevation. Raise body in plank position with body straight and arms extended.	Keeping body straight, lower upper body to floor by bending arms. To allow for full descent, pull head back slightly without arching back. Push body up until arms are extended. Repeat.	Both upper and lower body must be kept straight throughout movement. Range of motion will be compromised if neck is protracted. Very high elevations may not involve sternal head of pectoralis major.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{BENCH}	t	f
Triceps Dip	Mount shoulder width dip bar, arms straight with shoulders above hands. Keep hips straight.	Lower body until slight stretch is felt in shoulders. Push body up until arms are straight. Repeat.	Also see Chest Dips.	{BASIC}	{COMPOUND}	{PUSH}	{}	t	f
Suspended Triceps Dip	Stand between two suspension handles and grasp handles on each side of torso. Hold position firmly and lift feet from floor.	Push body up until arms are straight. Lower body until slight stretch is felt in shoulders. Repeat.	This exercise can be performed on gymnastics rings or a dual anchored suspension trainer. To emphasize triceps, position body more upright than demonstrated by positioning hips straighter. Also see Chest Dips.	{BASIC}	{COMPOUND}	{PUSH}	{SUSPENSION}	t	f
Suspended Triceps Extension	Grasp handles and step forward between suspension trainers. Position arms downward and slightly forward, nearly parallel with suspension straps. Lean forward, placing upper body weight onto handles with arms straight, while stepping back onto forefeet so body is leaning forward at desired angle. Straighten body, so torso is in-line with legs.	Lower body by bending elbows, allowing head to travel between suspension handles. Raise body up and back up until arms are extended. Repeat.	Both upper and lower body should be kept straight throughout movement. Angle of body affects difficulty of movement. See Gravity Vectors for greater understanding of how body angle influences resistance. Also see Suspended Triceps Extension with Triceps Rope. This exercise can be performed on TRXⓇ style suspension trainer or adjustable length gymnastics rings.	{BASIC,AUXILIARY}	{ISOLATED}	{PUSH}	{SUSPENSION}	t	f
Barbell Curl	Grasp bar with shoulder width underhand grip.	With elbows to side, raise bar until forearms are vertical. Lower until arms are fully extended. Repeat.	When elbows are fully flexed, they can travel forward slightly allowing forearms to be no more than vertical. This additional movement allows for relative release of tension in muscles between repetitions. Exercise can also be performed with straight barbell. Movement with cambered bar as shown above is also known as EZ Barbell Curl or EZ Bar Curl. Also see mechanical analysis of arm curl and question regarding elbow position.	{BASIC}	{ISOLATED}	{PULL}	{BARBELL}	f	f
Barbell Drag Curl	Grasp bar with shoulder width underhand grip.	Raise barbell straight up so elbows travel back as elbows flex. Follow contour of hips and waist. As elbows continues to flex, begin bringing elbows forward when forearms rises past horizontal position. Continue upward over chest until forearms are perpendicular. Lower until arms are fully extended. Repeat.	Bringing elbows back forward, allowing forearms to be no more than vertical, permits a relative release of tension in muscles between repetitions. Exercise can also be performed with EZ barbell, in which case, making it also known as EZ Barbell or EZ Bar Drag Curl. Also see standard Barbell Curl. Also see side view.	{AUXILIARY}	{ISOLATED}	{PULL}	{BARBELL}	f	f
Cable Alternating Curl	Stand between or facing double low pulleys. Grasp stirrups to each side, palms facing forward.	Pull one stirrup up forward and upward toward shoulder while keeping elbow stationary. Return until arm is fully extended. Repeat on other arm, alternating between sides.	When elbow is fully flexed, it can travel forward slightly, allowing forearm to be no more than vertical. This additional movement allows for relative release of tension in muscles between repetitions. Pulleys should not be too far apart. Also see mechanical analysis of arm curl and question regarding elbow position.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable Curl	Grasp low pulley cable bar with shoulder width underhand grip. Stand close to pulley.	With elbows to side, raise bar until forearms are vertical. Lower until arms are fully extended. Repeat.	When elbows are fully flexed, they can travel forward slightly, allowing forearms to be no more than vertical. This additional movement allows for relative release of tension in muscles between repetitions.	{BASIC}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable Bar Curl	Grasp low cable bar with shoulder width underhand grip. Stand close to cable bar.	With elbows to side, raise bar until forearms are vertical. Lower until arms are fully extended. Repeat.	When elbows are fully flexed, they can travel slightly forward, allowing forearms to be no more than vertical. This additional movement allows for relative release of tension in muscles between repetitions. Platform can be placed in front of feet to rest cable bar in between sets. See exercise performed with platform.	{BASIC}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable Supine Curl	Sit on floor with feet or heels against pulley machine. Grasp low pulley cable bar with shoulder width underhand grip. Lie back on floor with arms to sides.	With elbows to side, pull bar until elbows are flexed. Lower until arms are fully extended. Repeat.	When elbows are fully flexed, they can travel upward, slightly allowing forearms to be no more than horizontal in this lying posture. This additional movement allows for relative release of tension in muscles between repetitions. Also see mechanical analysis of arm curl and question regarding elbow position.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable Seated Curl	Sit on seat situated between two low pulleys down to each side. Grasp stirrups in each hand, palms facing forward.	Pull both stirrups up toward shoulders while keeping elbows stationary. Return until arms are fully extended and repeat.	When elbows are fully flexed, they can travel forward slightly, allowing forearms to be no more than vertical. This additional movement allows for relative release of tension in muscles between repetitions. Pulleys should not be too far apart. Cables can be positioned under shoulders with ad hoc or customized set up. Also see Cable Alternating Seated Curl.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable One Arm Curl	Face low pulley and grasp stirrup cable attachment to one side with underhand grip.	With elbow to side, raise bar until forearms are vertical. Lower until arms are fully extended. Repeat. Continue with opposite arm.	An alternative method is to stand facing with side of exercise arm toward low pulley. When elbow is fully flexed, it can travel forward slightly allowing forearms to be no more than vertical. This additional movement allows for relative release of tension in muscles between repetitions. Also see mechanical analysis of arm curl and question regarding elbow position.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Chin-up	Step up and grasp bar with underhand shoulder width grip.	Pull body up until elbows are to sides. Lower body until arms and shoulders are fully extended. Repeat.	Easier	{BASIC}	{COMPOUND}	{PULL}	{}	t	f
Inverted Biceps Row	Lay on back under fixed horizontal bar. Grasp bar with shoulder width underhand grip.	Keeping body straight, pull body up to bar. Return until arms are extended and shoulders are stretched forward. Repeat.	Fixed bar should be just high enough to allow arm to fully extend. See Gravity Vectors for greater understanding of how body angle influences resistance. Also known as Underhand Body Row or Underhand Supine Row.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{}	t	f
Lever Curl	Sit on seat and grasp handles with underhand grip.	Raise lever handles until elbows are fully flexed with back of upper arm remaining on pad. Lower handles until arm is fully extended. Repeat.	The biceps may be exercised alternating or simultaneous. If machine does not provide support for back of arm, keep elbows from traveling back, particularly during initial flexion. Some machines do not offer adequate resistance at initial range of motion. Consider positioning wrists with slight flexion to compensate.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Lever Alternating Curl	Sit on seat and grasp handles with underhand grip.	Raise lever on handle until elbow is fully flexed with back of upper arm remaining on pad. Lower handle until arm is fully extended. Repeat with opposite arm. Continue to alternate movement between sides.	The biceps may be exercised simultaneous. If machine does not provide support for back of arm, keep elbows from traveling back, particularly during initial flexion. Some machines do not offer adequate resistance at initial range of motion. Consider positioning wrists with slight flexion to compensate.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Barbell Preacher Curl	Sit on preacher bench placing back of arms on pad. Grasp curl bar with shoulder width underhand grip.	Raise bar until forearms are vertical. Lower barbell until arms are fully extended. Repeat.	Seat should be adjusted to allow armpit to rest near top of pad. Back of upper arm should remain on pad throughout movement. The long head (lateral head) of Biceps Brachii is activated significantly more than short head (medial head) of Biceps Brachii since short head enters into active insufficiency as it continues to contract. Also known as Scott Curl.	{AUXILIARY}	{ISOLATED}	{PULL}	{BARBELL,BENCH,PREACHER}	f	f
Barbell Standing Preacher Curl	Placing back of arms on pad with one foot forward, grasp curl bar with shoulder width underhand grip.	Raise bar until forearms are vertical. Lower barbell until arms are fully extended. Repeat.	Body should be positioned to allow armpit to rest near top of pad. Back of upper arm should remain on pad throughout movement. The long head (lateral head) of Biceps Brachii is activated significantly more than short head (medial head) of Biceps Brachii since short head enters into active insufficiency as it continues to contract.	{AUXILIARY}	{ISOLATED}	{PULL}	{BARBELL,PREACHER}	f	f
Barbell Prone Incline Curl	Lie prone on incline bench with shoulders near top of incline. Knees can rest on seat or legs can be straddled to sides. From low rack or partner, grasp curl bar with shoulder width underhand grip.	Raise bar until arms are flexed. Lower barbell until arms are fully extended. Repeat.	The long head (lateral head) of Biceps Brachii is activated significantly more than short head (medial head) of Biceps Brachii since short head enters into active insufficiency as it continues to contract. Also known as Barbell Spider Curl.	{AUXILIARY}	{ISOLATED}	{PULL}	{BARBELL,BENCH}	f	f
Cable Concentration Curl	Facing low pulley cable, sit on seat or bench with legs apart to each side. Grasp stirrup attachment. Place upper arm against inner thigh.	Pull stirrup to front of shoulder until elbow is completely flexed. Lower stirrup until arm is fully extended. Repeat. Continue with opposite arm.	The long head (lateral head) of Biceps Brachii is activated significantly more than short head (medial head) of Biceps Brachii since short head enters into active insufficiency as it continues to contract.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE,BENCH}	f	f
Rear Pull-up	Step up and grasp bar with overhand wide grip.	Pull body up until bar touches back of neck. Lower body until arms and shoulders are fully extended. Repeat.	Range of motion will be compromised if grip is too wide.	{BASIC}	{COMPOUND}	{PULL}	{}	t	f
Dumbbell Incline Curl	Sit back on 45-60 degree incline bench. With arms hanging down straight, position two dumbbells with palms facing inward.	With elbows back to sides, raise one dumbbell and rotate forearm until forearm is vertical and palm faces shoulder. Lower to original position and repeat with opposite arm. Continue to alternate between sides.	This exercise may be performed by alternating (as described), simultaneous, or in simultaneous-alternating fashion. When elbow is fully flexed, it can travel forward slightly, allowing forearms to be no more than vertical. This additional movement allows for relative release of tension in muscles between repetitions. Also see mechanical analysis of arm curl and question regarding elbow position.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL,BENCH}	f	f
Cable Preacher Curl	Sit on preacher bench placing back of arms on pad. Grasp cable bar with shoulder width underhand grip.	Raise cable bar toward shoulders. Lower cable bar until arms are fully extended. Repeat.	Seat should be adjusted to allow armpit to rest near top of pad. Back of upper arm should remain on pad throughout movement. The long head (lateral head) of Biceps Brachii is activated significantly more than short head (medial head) of Biceps Brachii since short head enters into active insufficiency as it continues to contract. At bottom position, weight stack in use should not make contact with remaining weight stack. Also see movement on horizontal pad.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE,BENCH,PREACHER}	f	f
Cable Alternating Preacher Curl	Grasp cable stirrups with each hand. Sit on preacher bench placing back of arms on pad with palms up.	Raise one stirrup upward toward shoulder of same arm. Lower stirrup until arm is fully extended. Repeat with opposite arm. Continue alternating between arms.	Seat should be adjusted to allowarm pit to rest near top of pad. Back of upper arms should remain on pad throughout movement. The long head (lateral head) of Biceps Brachii is activated significantly more than short head (medial head) of Biceps Brachii since short head enters into active insufficiency as it continues to contract. At bottom position, weight stack in use should not make contact with remaining weight stack.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE,BENCH,PREACHER}	f	f
Cable Standing Preacher Curl	Stand behind preacher bench. Grasp cable bar with shoulder width underhand grip. Position back of arms on pad.	Raise cable bar toward shoulders. Lower cable bar until arms are fully extended. Repeat.	Feet can be staggered and bent slightly (if needed) to allow armpit to rest near top of pad. Back of upper arm should remain on pad throughout movement. The long head (lateral head) of Biceps Brachii is activated significantly more than short head (medial head) of Biceps Brachii since short head enters into active insufficiency as it continues to contract. At bottom position, weight stack in use should not make contact with remaining weight stack. Also see movement on horizontal pad.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE,BENCH,PREACHER}	f	f
Cable One Arm Standing Preacher Curl	Standing behind standing preacher bench and grasp cable stirrup. Place back of arm on pad with palm up.	Raise stirrup upward toward shoulder of same arm. Lower stirrup until arm is fully extended. Repeat.	Stirrup can be hung from one side of rack for easier access. Feet can be staggered and bent slightly (if needed) to allow armpit to rest near top of pad. Back of upper arm should remain on pad throughout movement. The long head (lateral head) of Biceps Brachii is activated significantly more than short head (medial head) of Biceps Brachii since short head enters into active insufficiency as it continues to contract. At bottom position, weight stack in use should not make contact with remaining weight stack.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE,BENCH,PREACHER}	f	f
Cable One Arm Preacher Curl	Grasp cable stirrup. Sit on preacher bench placing back of arm on pad with palm up.	Raise stirrup upward toward shoulder of same arm. Lower stirrup until arm is fully extended. Repeat.	Seat should be adjusted to allow armpit to rest near top of pad. Back of upper arm should remain on pad throughout movement. The long head (lateral head) of Biceps Brachii is activated significantly more than short head (medial head) of Biceps Brachii since short head enters into active insufficiency as it continues to contract. At bottom position, weight stack in use should not make contact with remaining weight stack.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE,BENCH,PREACHER}	f	f
Cable Prone Incline Curl	Lie prone on incline bench with shoulders near top of incline. Knees can rest on seat or legs can be straddled to sides. Grasp cable attachment with shoulder width underhand grip.	Raise bar until arms are flexed. Lower barbell until arms are fully extended. Repeat.	Also known as Cable Spider Curl. The long head (lateral head) of biceps brachii is activated significantly more than short head (medial head) of biceps brachii since short head enters into active insufficiency as it continues to contract. Also known as Cable Spider Curl.	{AUXILIARY}	{ISOLATED}	{PULL}	{BARBELL,CABLE,BENCH}	f	f
Dumbbell Preacher Curl	Grasp dumbbell and sit on preacher bench. With arm bent and palm facing shoulder, place back of arm down on pad.	Lower dumbbell until arm is fully extended. Raise dumbbell until forearm is vertical. Repeat. Continue with opposite arm.	Seat should be adjusted to allow armpit to rest near top of pad. Back of upper arm should remain on pad throughout movement. Long head (lateral head) of Biceps Brachii is activated significantly more than short head (medial head) of Biceps Brachii since short head enters into active insufficiency as it continues to contract.	{AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL,BENCH,PREACHER}	f	f
Dumbbell Standing Preacher Curl	With dummbell in hand, arm bent, and palm facing shoulder, place back of arm on pad.	Lower dumbbell until arm is fully extended. Raise dumbbell until forearm is vertical. Repeat. Continue with opposite arm.	Body should be positioned to allow armpit to rest near top of pad. Back of upper arm should remain on pad throughout movement. Long head (lateral head) of Biceps Brachii is activated significantly more than short head (medial head) of Biceps Brachii since short head enters into active insufficiency as it continues to contract.	{AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL,PREACHER}	f	f
Lever Preacher Curl	Sit on curl machine placing back of arms on pad. Grasp lever handles with underhand grip. Align elbows at same pivot point as fulcrum of lever.	Raise lever handles toward shoulders. Lower handles until arms are fully extended. Repeat.	Seat should be adjusted to allow armpit to rest near top of pad. Back of upper arm should remain on pad throughout movement. If machine has secondary lever (as shown), it is not as essential to position elbows in-line with the primary fulcrum, as would otherwise be required. Long head (lateral head) of Biceps Brachii is activated significantly more than short head (medial head) of Biceps Brachii since short head enters into active insufficiency as it continues to contract. Long head of Triceps Brachii is only significant activated as antagonist stabilizer when it approaches passive insufficiency as elbow nears full flexion. Also see movements performed on machine with no seat and arms positioned higher.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER,PREACHER}	f	f
Lever Alternating Underhand Seated Row	Sit on seat and position chest against pad. Grasp lever handles with underhand grip.	Pull one lever handle back until elbow is behind back and shoulder is pulled back. Return until arm is extended and shoulder is stretched forward. Repeat with opposite arm, alternating between sides.	Seat or grip should be adjusted to allow wrists to follow elbows.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{LEVER}	f	f
Dumbbell Prone Incline Curl	Lie prone on incline bench with shoulders near top of incline. Knees can rest on seat or legs can be straddled to sides. From elevated platform or partner, grasp dumbbell and position palms forward.	Raise dumbbells until arms are flexed. Lower dumbbells until arms are fully extended. Repeat.	Alternatively, knees can also be placed on seat. The long head (lateral head) of Biceps Brachii is activated significantly more than short head (medial head) of Biceps Brachii since short head enters into active insufficiency as it continues to contract. Also known as Dumbbell Spider Curl.	{AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL,BENCH}	f	f
Suspended Arm Curl	Grasp suspension handles and momentarily step back until arms are extended forward and straight. While keeping arms straight and shoulders back, step forward so body is reclined back. Position palms up or slightly inward.	Bring handles toward shoulders by flexing arms, while keeping elbows pointed forward. Return by straightening arms and repeat.	Dismounting can be achieved by walking backward until body is upright. Also known as Suspended Biceps Curl, arguably somewhat of a misnomer. The positioning of arms, with elbows high, places short head (medial head) of Bicep Brachii in active insufficiency as arm continues to flex. The long head of Biceps Brachii (lateral head) and in particular, Brachialis are primary movers in this position.	{AUXILIARY}	{ISOLATED}	{PULL}	{SUSPENSION}	t	f
Lever Alternating Preacher Curl (arms high)	Sit on curl machine. Grasp lever handles with underhand grip. Align elbows at same pivot point as fulcrum of lever while placing back of arms up on pads.	Pull one lever handle toward shoulder. Return handle until arm is fully extended. Repeat with opposite arm. Continue alternating movement between arms.	Back of upper arms should remain on pad throughout movement. If machine has secondary lever (as shown), elbows can be positioned further away from primary fulcrum. Long head (lateral head) of Biceps Brachii is activated significantly more than short head (medial head) of Biceps Brachii since short head enters into active insufficiency as it continues to contract. Long head of Triceps Brachii is only significantly activated as antagonist stabilizer when it approaches passive insufficiency as elbow nears full flexion. See exercise performed with both arms simultaneously.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER,PREACHER}	f	f
Lever Standing Preacher Curl	Stand behind arm pad and face lever handles on opposite side. Place one foot forward under arm pad and opposite foot back on foot bar. Lean over arm pads and grasp handles with slightly narrower than shoulder width underhand grip. Squat down and position back of upper arms on arm pads.	Raise lever handles toward shoulders. Lower handles until arms are fully extended. Repeat.	Position armpit to rest near top of pad. Back of upper arm should remain on pad throughout movement. Notice that this machine has secondary lever so elbows are not aligned with primary fulcrum. This particular machine also features weight pack that can be positioned closer or further away from fulcrum thereby making resistance easier or harder. Long head (lateral head) of Biceps Brachii is activated significantly more than short head (medial head) of Biceps Brachii since short head enters into active insufficiency as it continues to contract. Long head of Triceps Brachii is only significantly activated as antagonist stabilizer when it approaches passive insufficiency as elbow nears full flexion.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER,PREACHER}	f	f
Barbell Bent-over Row	Bend knees slightly and bend over bar with back straight. Grasp bar with wide overhand grip.	Pull bar to upper waist. Return until arms are extended and shoulders are stretched downward. Repeat.	Torso may be kept horizontal for strict execution. Knees are bent in effort to keep low back straight (See Hamstring Inflexibility). If low back becomes rounded due to tight hamstrings, either try bending knees more or don't position torso as low. Either fix may compromise involvement of Latissimus Dorsi since it forces more shoulder transverse extension and less shoulder extension range of motion. If low back is rounded due to poor form, deadlift weight to standing position and lower torso into horizontal position with knees bent and back straight. A shoulder width or underhand grip can increase lat involvement by emphasizing shoulder extension over transverse extension. A wide overhand grip involves overall back musculature while slightly emphasizing Rear Delt, Infraspinatus and Teres Minor involvement. Also known as Pendlay Row.	{BASIC}	{COMPOUND}	{PULL}	{BARBELL}	f	f
Barbell Close Grip Bent-over Row	Bend knees slightly and bend over bar with back straight. Grasp bar with shoulder width overhand grip.	Pull bar to waist. Return until arms are extended and shoulders are stretched forward. Repeat.	Torso may be kept horizontal for strict execution. Knees are bent in effort to keep low back straight (See Hamstring Inflexibility). If low back becomes rounded due to tight hamstrings, either try bending knees more or don't position torso as low. Either fix may compromise involvement of Latissimus Dorsi since it forces more shoulder transverse extension and less shoulder extension range of motion. If low back is rounded due to poor form, deadlift weight to standing position and lower torso into horizontal position with knees bent and back straight. A shoulder width or underhand grip can increase lat involvement by emphasizing shoulder extension over transverse extension.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{BARBELL}	f	f
Barbell Underhand Bent-over Row	Bend knees slightly and bend over bar with back straight. Grasp bar with underhand grip.	Pull bar to waist. Return until arms are extended and shoulders are stretched downward. Repeat.	Torso may be kept horizontal for strict execution. Knees are bent in effort to keep low back straight (See Hamstring Inflexibility). If low back becomes rounded due to tight hamstrings, either try bending knees more or don't position torso as low. Either fix may compromise involvement of Latissimus Dorsi since it forces more shoulder transverse extension and less shoulder extension range of motion. If low back is rounded due to poor form, deadlift weight to standing position and lower torso into horizontal position with knees bent and back straight. A shoulder width or underhand grip can increase lat involvement by emphasizing shoulder extension over transverse extension.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{BARBELL}	f	f
Cable Incline Row	Sit on incline and place feet on lower bar, or foot platform. Slide hips down by bending knees. Bend over and grasp cable attachment. Slide hips back, positioning knees with slight bend.	Pull cable attachment to waist while straightening back upright. Pull shoulders back and push chest forward while arching back. Return until arms are extended, shoulders are stretched forward, and lower back is flexed forward. Repeat.	Begin with light weight and add additional weight gradually to allow lower back adequate adaptation. Do not pause or bounce at bottom of lift. Do not lower weight beyond mild stretch. Full range of motion through lower back will vary from person to person. See Cable Seated Row Question. Also see Cable Straight Back Incline Row and Dangerous Exercise Essay.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{CABLE}	f	f
Cable Straight Back Incline Row	Sit on incline and place feet on lower bar, or foot platform. Slide hips down by bending knees. Bend over and grasp cable attachment. Slide hips back, positioning knees with slight bend. Straighten lower back so it is approximately perpendicular to incline.	Pull cable attachment to waist. Pull shoulders back and lift chest by arching back. Return until arms are extended, back is straight and perpendicular to incline, and shoulders are stretched forward. Repeat.	Also see Cable Incline Row.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{CABLE}	f	f
Cable Kneeling Row	Place right knee on lower pad (positioned to right side) with foot of other leg slightly back out to side and knee slightly bent. Place right forearm on right side of upper pad and grasp handle. Grasp cable stirrup below with left hand. Allow left shoulder to be pulled forward without spinal rotation.	Pull stirrup up to side until elbow travels beyond surface of back. Return until arm is extended and shoulder is stretched downward. Repeat and continue with opposite side.	Allow scapula to articulate, but do not rotate torso.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{CABLE}	f	f
Cable Lying Row	Straddle head of bench and grasp stirrups on two high pulley cables. Lie on bench with stirrups in each hand and arms extended upward.	Pull stirrups down to each side of chest until elbows are behind back and shoulders are pulled back. Return until arms are extended and shoulders are stretched upward. Repeat.	Pulleys should not be too far apart, as they are on standard cable crossover machines. Stirrups on pulleys should be high enough to allow shoulders to stretch forward when arms extend. Pull shoulder blades together when completing pull. Other rowing exercises should be considered if resistance required begins to exceed upper body weight since back will begin to raise up off of bench.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{CABLE,BENCH}	f	f
Cable One Arm Bent-over Row	Grasp cable stirrup. Step back away from pulley, with foot on same side as exercising arm, positioned out to side well behind forward foot. Bend over with hand on nearby bar or above knee for support. Keep back straight and knees slightly bent. Allow shoulder with stirrup to be pulled forward.	Pull cable attachment to side of torso, pulling shoulder back. Return until arm is extended and shoulder is stretched forward. Repeat. Continue with opposite arm.	Supporting hand can also be placed on nearby bar, available on some pulley machines. Hamstrings and Gluteus Maximus stabilize near top of movement on forward leg.	{AUXILIARY}	{COMPOUND}	{PULL}	{CABLE}	f	f
Cable One Arm Seated Row	Sit slightly forward on platform or secured bench in order to grasp cable stirrup with one hand. Position hips back with knees slightly bent . Allow shoulder with stirrup to be pulled forward.	Pull cable attachment to side of torso, slightly twisting through waist. Pull shoulder back and push chest forward during contraction. Return until arm is extended and shoulder is stretched forward. Repeat. Continue with opposite arm.	It is optional to bend lower back forward during stretch and pull it upright during contraction. If low back is kept still, Erector Spinae acts as synergist muscle. Also see Cable One Arm Twisting Seated Row.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{CABLE,BENCH}	f	f
Cable Twisting Seated Row	Sit slightly forward on platform or secured bench close to cable attachment. Bend forward and grasp cable stirrup with one hand. Slide hips back by positioning knees with slight bend. Allow shoulder with stirrup to be pulled forward with forward bend and twist through waist.	Pull cable attachment to side, extending and twisting through waist. Pull shoulders back and sit upright while pushing chest forward during contraction. Return until arm is extended and shoulder is stretched forward. Repeat and perform exercise with opposite arm.	Also see Cable One Arm Seated Row.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{CABLE,BENCH}	f	f
Cable One Arm Seated High Row	Sit slightly forward on platform or secured bench close to cable attachment. Bend forward and grasp cable stirrup with one hand. Slide hips back by positioning knees with slight bend. Allow arm, shoulder, and torso to be pulled forward under weight on cable.	Pull cable attachment to side of torso, straightening back and leaning back slightly. Pull shoulder back and push chest forward during contraction. Return until arm is extended and torso is pulled forward. Repeat. Continue with opposite arm.	It is optional to bend lower back forward during stretch and pull it upright during contraction. If torso does not bend forward, Erector Spinae acts as stabilizer muscle. See straight back form. Quadratus Lumborum and Obliques are involved in spinal rotation if waist is rotated more than demonstrated. Hamstrings and Gluteus Maximus are no longer stabilizers if seated on bench with upper leg support.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{CABLE,BENCH}	f	f
Cable One Arm Straight Back Seated High Row	Sit on seat or bench. Bend forward and grasp cable stirrup with one hand. Position torso upright allowing shoulder to be pulled forward under weight on cable.	Pull cable attachment to side of torso while pulling shoulder back, arching spine, and pushing chest forward. Return until arm is extended and shoulder is pulled forward. Repeat. Continue with opposite arm.	If two high pulleys are available, consider using opposite pulley as arm exercised. If pulley is far away enough, it is optional to bend lower back forward during stretch and pull it upright during contraction. See Cable One Arm Seated High Row. Quadratus Lumborum and Obliques are involved in spinal rotation if waist rotates. Hamstrings and Gluteus Maximus become stabilizers, if seated on bench with feet propped forward with no upper leg support.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{CABLE,BENCH}	f	f
Cable Twisting Seated High Row	Sit on seat or bench. Bend forward and grasp cable stirrup with one hand. Allow shoulder with stirrup to be pulled forward with twist through waist.	Pull cable attachment to side of torso while twisting though waist in opposite direction. Pull shoulder back and push chest forward. Return until arm is extended and shoulder is pulled forward. Repeat. Continue with opposite arm.	If two high pulleys are available use opposite pulley as exercised arm. If pulley is far enough away, it is optional to bend lower back forward during stretch and pull it upright during contraction. See Cable One Arm Seated High Row. Hamstrings and Gluteus Maximus become stabilizers if seated on bench with feet propped forward with no upper leg support.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{CABLE,BENCH}	f	f
Cable Seated High Row	Sit slightly forward on bench or platform in order to grasp cable attachment. Place feet on vertical platform. Slide hips back positioning knees with slight bend. Allow weight on cable to pull torso forward while stretching arms and shoulders upward.	Pull cable attachment to waist and lean back slightly. Pull shoulders back and push chest forward while arching back. Return until torso, arms, and shoulders pulled forward. Repeat.	It is optional to bend lower back forward during stretch and pull it upright during contraction. If low back is kept still, Erector Spinae acts as synergist muscle. Also see exercise on bench and adjustable height pulley.	{BASIC}	{COMPOUND}	{PULL}	{CABLE,BENCH}	f	f
Cable Alternating Seated High Row	Sit and grasp cable stirrups one with each hand. Lean back slightly allowing arms, shoulders, and torso to be pulled forward under weight on cables.	Pull one cable stirrup to side. Pull shoulder back, push chest forward, and rotate body slightly toward pulling arm. Return until arm is extended and torso faces forward. Pull with opposite arm alternating between each side. Repeat.	Rotation of torso as shown is optional. Quadratus Lumborum and Obliques act as stabilizers if waist is not rotated as demonstrated. Hamstrings and Gluteus Maximus act as stabilizers if seat is not available and legs are propped forward.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{CABLE}	f	f
Cable Seated Row	Sit slightly forward on seat or bench in order to grasp cable attachment. Place feet on vertical platform. Slide hips back positioning knees with slight bend.	Pull cable attachment to waist while straightening lower back. Pull shoulders back and push chest forward while arching back. Return until arms are extended, shoulders are stretched forward, and lower back is flexed forward. Repeat.	Begin with light weight and add additional weight gradually to allow lower back adequate adaptation. Do not pause or bounce at bottom of lift. Do not lower weight beyond mild stretch. Full range of motion through lower back will vary from person to person. See exercise performed with Dual Pulley and related exercise Cable Straight Back Seated Row. Also see Cable Seated Row Question and Dangerous Exercise Essay.	{BASIC}	{COMPOUND}	{PULL}	{CABLE,BENCH}	f	f
Cable Straight Back Seated Row	Sit slightly forward on bench with feet on foot bar or vertical platform. Grasp close grip cable attachment. Straighten torso upright and slide hips back so knees are slightly bent.	Pull cable attachment to waist. Pull shoulders back and lift chest by arching back. Return until arms are extended, back is straight, and shoulders are stretched forward. Repeat.	Also see exercise performed on Dual Pulley and related exercise Cable Seated Row.	{BASIC}	{COMPOUND}	{PULL}	{CABLE,BENCH}	f	f
Cable Wide Grip Seated Row	Sit slightly forward on platform in order to grasp cable attachment. With awider than shoulder width grip, slide hips back positioning knees with slight bend.	Pull cable attachment to waist while pulling torso upright. Pull shoulders back and push chest forward while arching back. Return until arms are extended, shoulders are stretched forward, and lower back is flexed forward. Repeat.	Begin with light weight and additional weight gradually to allow lower back adequate adaptation. Do not pause or bounce at bottom of lift. Do not lower weight beyond mild stretch. Full range of motion through lower back will vary from person to person. See Cable Seated Row Question. Also see Cable Wide Grip Straight Back Seated Row and Dangerous Exercise Essay.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{CABLE}	f	f
Cable Wide Grip Straight Back Seated Row	Sit slightly forward on bench or platform in order to grasp cable bar attachment. With wider than shoulder width overhand grip, straighten torso upright and slide hips back until knees are only slightly bent.	Pull cable attachment to waist. Pull shoulders back and lift chest by arching back. Return until arms are extended, back is straight, and shoulders are stretched forward. Repeat.	Also see Cable Wide Grip Seated Row.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{CABLE,BENCH}	f	f
Cable Standing Row	Stand to side of medium height, rotating pulley. Place hand shoulder height or slightly lower on support bar with arm straight. Place foot nearest supporting arm forward with knee slightly bent and opposite foot back. Grasp cable stirrup with one hand, allowing shoulder to be pulled forward under weight on cable.	Pull cable attachment to side of torso while pulling shoulder back, arching spine, and pushing chest forward. Return until arm is extended and shoulder is pulled forward. Repeat. Continue with opposite arm.	Stirrup handle should be behind supporting bar. Few pulley units have vertical support bar (for supporting hand) far enough back from pulley to allow full range of motion and adequate pulley rotation to allow it to be aligned with line of pull. If pulley unit does not allow for this configuration, consider placing sturdy prop (for supporting hand) in front of pulley, far back enough to allow full range of motion. Also see Cable Standing Low Row.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{CABLE}	f	f
Cable Standing Low Row	Stand to side of low pulley. Place hand on support bar with arm straight. Place foot nearest supporting arm forward with knee slightly bent and opposite foot back. Grasp cable stirrup with one hand, allowing shoulder to be pulled forward under weight on cable.	Pull cable attachment to side of torso while pulling shoulder back, arching spine, and pushing chest forward. Return until arm is extended and shoulder is pulled forward. Repeat. Continue with opposite arm.	Also see Cable Standing Row with medium height pulley.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{CABLE}	f	f
Cable Twisting Standing High Row	Stand facing high pulley positioned slightly above head level. Grasp stirrup with one hand and step back so arm is straight. With leg of opposite side as loaded arm, plant forefoot far back on floor. Slightly bend knee of forward leg, same direction as foot. Allow shoulder with stirrup to be pulled forward with twist through waist.	Pull cable attachment to side of torso and rotate body toward side of pulling arm. Pull shoulder back and push chest forward. Return until arm is extended and shoulder is pulled forward. Repeat. Continue with opposite arm.	In standing position, both spinal rotation and hip rotation contribute to body's rotation. Because rear leg is only supported by forefoot, hip of forward leg is utilized (hip internal rotation / transverse adduction) much greater than hip of rear leg since forward leg offers more secured base of support.	{AUXILIARY}	{COMPOUND}	{PULL}	{CABLE}	f	f
Dumbbell Incline Row	Lie chest down on slightly inclined bench. Grasp dumbbells below.	Pull dumbbells to sides until upper arm is just beyond height of back. Return until arms are extended and shoulders are stretched downward. Repeat.	Bench should be high enough to allow shoulders to stretch forward without dumbbells hitting floor. Lying on horizontal surface generally offers ideal angle of pull as long as bench is high enough to permit full range of motion at bottom most position.	{BASIC}	{COMPOUND}	{PULL}	{DUMBBELL,BENCH}	f	f
Smith Bent-over Row	Bend knees slightly and bend over bar with back straight. Grasp bar with wide overhand grip. Disengage bar by rotating bar back.	Pull bar to upper waist. Return until arms are extended and shoulders are stretched downward. Repeat.	Torso may be kept horizontal for strict execution. Platform (as shown) is only needed if smith machine does not allow bar to be lowered to lowest position. Knees are bent in effort to keep low back straight (See Hamstring Inflexibility ). If low back becomes rounded due to tight hamstrings, either knees should be bent more or torso may not be positioned as low. Either fix may compromise involvement of Latissimus Dorsi since it forces more shoulder transverse extension and less shoulder extension range of motion. If low back is rounded due to poor form, deadlift weight to standing position and lower torso into horizontal position with knees bent and back straight. A shoulder width or underhand grip can increase lat involvement by emphasizing shoulder extension over transverse extension.	{BASIC}	{COMPOUND}	{PULL}	{SMITH}	f	f
Lever Seated High Row	Sit on seat and position thighs under pad. Lean forward and grasp lever handles above.	Pull lever down while leaning back slightly. As elbows travel to sides, lift chest slightly and pull shoulders and elbows back. Return until arms are extended and body and shoulders are stretched forward. Repeat.	Seat should be adjusted to allow for full range of motion. Also see Lever Seated Hammer High Row.	{BASIC}	{COMPOUND}	{PULL}	{LEVER}	f	f
Lever Alternating Seated High Row	Sit on seat and position chest against pad. Grasp lever handles with overhand grip.	Pull one lever handle back until elbow is behind back and shoulder is pulled back. Return until arm is extended and shoulder is stretched forward. Repeat with opposite arm, alternating between sides.	Chest pad should be adjusted to allow shoulders to stretch forward. The seat or grip should be adjusted to allow wrists to follow elbows.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{LEVER}	f	f
Lever Seated Row	Sit on seat and position chest against pad. Push foot lever if available. Grasp narrower parallel grip handles.	Pull lever back until elbows are behind back and shoulders are pulled back. Return until arms are extended and shoulders are stretched forward. Repeat.	Chest pad should be adjusted to allow shoulders to stretch forward. The seat or grip should be adjusted to allow wrists to follow elbows. When completing pull, lift chest slightly and pull shoulder blades together while keeping lower chest on pad. Let shoulders roll forward when arms extend.	{BASIC}	{COMPOUND}	{PULL}	{LEVER}	f	f
Lever Wide Grip Seated Row	Sit on seat and position chest against pad. Grasp outer lever handles with overhand grip.	Pull lever back until elbows are behind back and shoulders are pulled back. Return until arms are extended and shoulders are stretched forward. Repeat.	Chest pad should be adjusted to allow shoulders to stretch forward. The seat or grip should be adjusted to allow wrists to follow elbows. When completing pull, lift chest slightly and pull shoulder blades together while keeping lower chest on pad. Let shoulders roll forward when arms extend.	{BASIC}	{COMPOUND}	{PULL}	{LEVER}	f	f
Lever Underhand Seated Row	Sit on seat and position chest against pad. Grasp lever handles with underhand grip.	Pull levers back until elbows are behind back and shoulders are pulled back. Return until arms are extended and shoulders are stretched forward. Repeat.	Seat or grip should be adjusted to allow wrists to follow elbows. When completing pull, lift chest slightly and pull shoulder blades together while keeping lower chest on pad. Let shoulders roll forward when arms extend.	{BASIC}	{COMPOUND}	{PULL}	{LEVER}	f	f
Inverted Row	Lay on back under fixed horizontal bar. Grasp bar with wide overhand grip.	Keeping body straight, pull body up to bar. Return until arms are extended and shoulders are stretched forward. Repeat.	Fixed bar should be just high enough to allow arm to fully extend. See Gravity Vectors for greater understanding of body angle influences resistance. Also known as Body Row or Supine Row.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{}	t	f
Suspended Inverted Row	Position suspension handles higher than arms' length above floor. Sit on floor and grasp handles. Position body supine hanging from handles with arms straight, shoulders under handles, body straight, and back of heels on floor.	Pull body up so sides of chest make contact with handles while keeping body straight. Return until arms are extended straight and shoulders are stretched forward. Repeat.	Fixed bar should be just high enough to allow arm to fully extend. See Gravity Vectors for greater understanding of body angle influences resistance.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{SUSPENSION}	t	f
Suspended Row	Grasp suspension handles and momentarily step back until arms are extended forward and straight. While keeping arms straight and shoulders back, step forward so body reclines back behind suspension handles. Position body and legs straight at desired angle, hanging from handles with arms straight.	Pull body up so sides of chest make contact with handles while keeping body and legs straight. Return until arms are extended straight and shoulders are stretched forward. Repeat.	At higher angles, feet can be placed flat on floor. When angled further back, only heels may contact floor with forefeet raising upward. Dismounting can be achieved by walking backward until body is upright.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{SUSPENSION}	t	f
Barbell Pullover	Lie upper back perpendicular on bench. Flex hips slightly. Grasp barbell from behind and position over chest with elbows bent slightly.	With elbows bent slightly, lower bar over and beyond head until shoulders are fully flexed or upper arms are approximately parallel to torso. Return and repeat.	Lower body extending off of bench acts as counter balance to resistance and keeps upper back fixed on bench. Avoid hips from raising up significantly. Actual range of motion is dependent upon individual shoulder flexibility. Keep elbows fixed at small bend throughout exercise. Either straight barbell or EZ barbell can be used. Also see Barbell Bent Arm Pullover.	{AUXILIARY}	{ISOLATED}	{PULL}	{BARBELL,BENCH}	f	f
Cable Close Grip Pulldown	Grasp parallel cable attachment. Sit with thighs under supports.	Pull down cable attachment to upper chest. Return until arms and shoulders are fully extended. Repeat.	Exercise can be performed with V-Bar or Multi-exercise Bar.	{BASIC}	{COMPOUND}	{PULL}	{CABLE}	f	f
Cable Alternating Close Grip Pulldown	Grasp stirrups in each hand. Sit with thighs under supports.	Pull down one cable attachment to side of chest. Return until arm and shoulder is fully extended. Repeat with opposite arm, alternating between sides.	Stirrups are attached to split pulley.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{CABLE}	f	f
Cable One Arm Pulldown	Grasp stirrup in one hand. Sit with thighs under supports.	Pull down cable attachment to side of chest. Return until arm and shoulder is fully extended, allowing shoulder to raise. Repeat and continue with other arm.	Muscles listed as Stabilizers become Synergists if spinal lateral flexion occurs during exercise.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{CABLE}	f	f
Cable One Arm Kneeling Pulldown	Grasp stirrup in one hand and kneel on floor.	Pull down cable attachment to side of chest. Return until arm and shoulder is fully extended, allowing shoulder to raise. Repeat and continue with other arm.	Muscles listed as Stabilizers become Synergists if spinal lateral flexion occurs during exercise.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{CABLE}	f	f
Cable Kneeling Bent-over Pulldown	Kneel on mat slightly away from high pulley. Grasp cable rope attachment with both hands. Sit with hips back and bend down by flexing hips so torso is bent over at approximately 30º angle. Allow resistance on cable pulley to pull arms upward with elbows bent.	Pull cable rope down until elbows are back and inside of rope attachment is behind neck. Return attachment over head until shoulder is completely flexed upward. Repeat.	Keep hips and torso in same position throughout movement.	{AUXILIARY}	{COMPOUND}	{PULL}	{CABLE}	f	f
Cable Pulldown	Grasp cable bar with wide grip. Sit with thighs under supports.	Pull down cable bar to upper chest. Return until arms and shoulders are fully extended. Repeat.	Range of motion will be compromised if grip is too wide.	{BASIC}	{COMPOUND}	{PULL}	{CABLE}	f	f
Cable Alternating Pulldown	Grasp stirrups in each hand. Sit with thighs under supports.	Pull down one cable attachment to front side shoulder. Return until arm and shoulder are fully extended. Repeat with opposite arm, alternating between sides.	Stirrups are attached to split pulley.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{CABLE}	f	f
Cable Parallel Grip Pulldown	Grasp parallel cable attachment. Sit with thighs under supports.	Pull down cable attachment to upper chest. Return until arms and shoulders are fully extended. Repeat.	Parallel Grip Cable Attachment is shorter than Pro Lat Bar, yet longer than Close Grip Cable Attachments.	{BASIC}	{COMPOUND}	{PULL}	{CABLE}	f	f
Cable Pullover	Lie upper back perpendicular on bench. Flex hips slightly, so hips are slightly lower than torso. Grasp revolving barbell cable attachment from behind. Pull to position cable attachment over chest. Fix elbows with small bend.	Lower cable attachment toward pulley with elbows bent only slightly. Lower until shoulders are fully flexed or upper arms are in-line with upper torso. Raise cable attachment over head and continue toward lower body until cable becomes very close to head. Repeat.	Lower body extending off of bench acts as counter balance to resistance and keeps upper back fixed on bench. Avoid hips from raising up significantly. Actual range of motion is dependent upon individual shoulder flexibility. Keep elbows fixed at small bend throughout exercise.	{AUXILIARY}	{ISOLATED}	{PULL}	{BARBELL,CABLE,BENCH}	f	f
Cable Bent-over Pullover	Face high pulley and grasp revolving cable attachment with arm slightly bent. Place one foot slightly back and bend over at hip until shoulder is fully flexed (upper arms at sides of head).	With elbows fixed approximately 30°, pull cable attachment down until upper arms are to sides. Return attachment overhead. Repeat.	Fix elbows approximately 30° throughout exercise. Also known as Straight Arm Pulldown.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable Chin-up	Place dip belt around waist. Kneel close to low pulley or lever and attach hook to dip belt chains. Step up and grasp bars with shoulder width underhand grip. Lift legs off of steps or floor.	Pull body up until elbow are to sides. Lower body until arms and shoulders are fully extended. Repeat.	If weight bottoms out at bottom, attach cable on chain links nearer ends of dip belt.	{BASIC}	{COMPOUND}	{PULL}	{CABLE,LEVER}	f	f
Cable Parallel Close Grip Pull-up	Place dip belt around waist. Kneel as close as possible to low pulley or lever and attach hook to dip belt in front between legs. Step up and grasp close grip p arallel bars with hands facing inward. Lift legs off of steps or floor.	Pull body up until elbow are to sides. Lower body until arms and shoulders are fully extended. Repeat.	If weight bottoms out at bottom of movement, attach cable on chain links nearer ends of dip belt.	{BASIC}	{COMPOUND}	{PULL}	{CABLE,LEVER,PARALLEL_BARS}	f	f
Cable Pull-up	Place dip belt around waist. Kneel close to low pulley or lever and attach hook to dip belt. Step up and grasp bars with overhand wide grip. Lift legs off of steps or floor.	Pull body up until chin is above bar. Lower body until arms and shoulders are fully extended. Repeat.	If weight bottoms out at bottom of movement, attach cable on chain links nearer ends of dip belt. Range of motion will be compromised if grip is too wide.	{BASIC}	{COMPOUND}	{PULL}	{CABLE,LEVER}	f	f
Cable Rear Pull-up	Place dip belt around waist. Kneel close to low pulley or lever and attach hook to dip belt. Step up and grasp bars with overhand wide grip. Lift legs off of steps or floor.	Pull body up until bar touches back of neck. Lower body until arms and shoulders are fully extended. Repeat.	If weight bottoms out at bottom of motion, attach cable on chain links nearer ends of dip belt. Range of motion will be compromised if grip is too wide.	{BASIC}	{COMPOUND}	{PULL}	{CABLE,LEVER}	f	f
Cable Rear Pulldown	Grasp cable bar with wide grip. Sit with thighs under supports.	Pull cable bar down behind neck. Return until arms and shoulders are fully extended. Repeat.	Range of motion will be compromised if grip is too wide.	{BASIC}	{COMPOUND}	{PULL}	{CABLE}	f	f
Cable Alternating Standing Pulldown	Grasp stirrups in each hand. Lean forward and step back with one foot so stance is staggered. Position hands with underhand or neutral grip.	Pull down one cable attachment to front of shoulder. Return until arm and shoulder are fully extended. Repeat movement with opposite arm, alternating between sides.	Video shows appartus with stirrups attached to dual pulley.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{CABLE}	f	f
Cable Twisting Standing Overhead Pull	Stand facing very high pulley. Grasp stirrup in one hand and step back so arm is straight. With leg of opposite side as loaded arm, plant forefoot far back on floor. Slightly bend knee of forward leg, same direction as foot.	Pull down cable attachment to side of chest and rotate body toward side of pulling arm. Return until arm and shoulder is fully extended, allowing shoulder to raise. Repeat. Continue with opposite arm.	In standing position, both spinal rotation and hip rotation contribute to body's rotation. Because rear leg is only supported by forefoot, hip of forward leg is utilized (hip internal rotation / transverse adduction) much greater than hip of rear leg since forward leg offers more secured base of support.	{AUXILIARY}	{COMPOUND}	{PULL}	{CABLE}	f	f
Cable Underhand Pulldown	Grasp cable bar with underhand grip. Sit with thighs under supports.	Pull down cable bar to upper chest until elbows are to sides. Return until arms and shoulders are fully extended. Repeat.	None	{BASIC}	{COMPOUND}	{PULL}	{CABLE}	f	f
Lever Iron Cross	Stand on platform and grasp handles to sides with palms down grip.	With arms straight, pull lever handles down below hips. Return lever handles upward just above shoulder high, or just before slight pressure in shoulder is felt. Repeat.	Platform should be adjusted so shoulder joint and girdle are approximate height as lever fulcrum. Also See Bent-over Fly on Iron Cross Machine.	{BASIC}	{COMPOUND}	{PULL}	{LEVER}	f	f
Lever Pullover	Adjust seat height so lever is near shoulder axis. Sit on machine and push foot lever. Place elbows on pads and grasp bar from behind. Release foot lever and place feet on platform or to sides.	Pull lever forward and down until elbows are to sides. Return until shoulders are fully flexed, or upper arms are parallel to torso. Repeat.	When finished, push foot lever before releasing arm from lever. Release foot lever after releasing arm from lever. Actual range of motion is dependent upon individual shoulder flexibility.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Lever Underhand Pulldown	Grasp lever handles with underhand grip. Sit with thighs under supports.	Pull down lever handles to upper chest until elbows are to sides. Return until arms and shoulders are fully extended. Repeat.	Also see exercise on alternative machine.	{BASIC}	{COMPOUND}	{PULL}	{LEVER}	f	f
Lever Alternating Underhand Pulldown	Grasp lever handles with underhand grip. Sit with thighs under supports.	Pull down one lever handle to side until elbow is down to side. Return until arm and shoulder are fully extended. Repeat with opposite arm. Continue to alternate pulldown between arms.	See pad kick down on Hammer Machine.	{BASIC}	{COMPOUND}	{PULL}	{LEVER}	f	f
Lever Close Grip Pulldown	Grasp parallel lever bars. Sit with thighs under supports.	Pull down handles to sides of chest while leaning back slightly. Return until arms and shoulders are fully extended. Repeat.	Erector Spinae can become slightly engaged when torso arches back.	{BASIC}	{COMPOUND}	{PULL}	{LEVER}	f	f
Lever Front Pulldown	Grasp lever handles. Sit with thighs under supports.	Pull down lever to upper chest. Return until arms and shoulders are fully extended. Repeat.	None	{BASIC}	{COMPOUND}	{PULL}	{LEVER}	f	f
Lever Pulldown (parallel grip)	Sit on seat. Reach up and grasp parallel handles.	Pull levers down to sides of shoulders. Return until arms and shoulders are fully extended. Repeat.	Also see Lever Pulldown.	{BASIC}	{COMPOUND}	{PULL}	{LEVER}	f	f
Neutral Grip Chin-up	Reach up and grasp bars angled inward with underhand shoulder width grip.	Pull body up until elbows are to sides. Lower body until arms and shoulders are fully extended. Repeat.	Easier	{BASIC}	{COMPOUND}	{PULL}	{}	t	f
Parallel Close Grip Pull-up	Step up and grasp parallel bars.	Pull body up until elbow are to sides. Lower body until arms and shoulders are fully extended. Repeat.	Easier	{BASIC}	{COMPOUND}	{PULL}	{PARALLEL_BARS}	t	f
Pull-up	Step up and grasp bar with overhand wide grip.	Pull body up until chin is above bar. Lower body until arms and shoulders are fully extended. Repeat.	Range of motion will be compromised if grip is too wide.	{BASIC}	{COMPOUND}	{PULL}	{}	t	f
Neutral Grip Pull-up	Step up and grasp bar with neutral grip.	Pull body up until neck reaches height of hands. Lower body until arms and shoulders are fully extended. Repeat.	Special angled pull-up bar assembly is shown.	{BASIC}	{COMPOUND}	{PULL}	{}	t	f
Suspended Pull-up	Grasp high suspension handles.	Pull body up until neck reaches height of hands. Lower body until arms and shoulders are fully extended. Repeat.	This exercise can be performed on adjustable length gymnastics rings or a dual anchored suspension trainer where the handles can be placed a short distance apart. Performing this exercise on a TRXⓇ style suspension trainer would require a narrower grip, with the hands closer together.	{BASIC}	{COMPOUND}	{PULL}	{SUSPENSION}	t	f
Stability Ball Rollout	Kneel on floor or mat facing stability ball within arm's reach. Straighten hips with subtle bend. Also straighten arms with slight bend, down in front of body. Place fists side by side on upper side of ball closest to hips.	Lean forward and roll ridged arms out over ball. Roll forward as far as possible. Raise body back up by pulling arms back until kneeling upright in original position. Repeat.	Try to keep elbows nearly straight throughout exercise. Also known as Stability Ball Kneeling Rollout.	{AUXILIARY}	{ISOLATED}	{PUSH}	{STABILITY_BALL}	t	f
Suspended Kneeling Rollout	Kneel on floor or mat and grasp suspension trainer handles. Position body upright with subtle bend through hip. Also, straighten arms in front of body with slight bend.	Lean body forward while maintaining small bend in hip. Allow arms to bend forward to sides of head. Bend over as far as possible. Raise body back up by pulling arms back until kneeling upright in original position. Repeat.	Try to keep elbows nearly straight throughout exercise. Target muscle, Rectus Abdominis practically contracts isometrically since only a small degree of waist flexion occurs under resistance and, with the assistance of the External Oblique, act to stabilize spine. See target muscle of rollout question. Also see Spot Reduction Myth and Lower Ab Myth.	{AUXILIARY}	{ISOLATED}	{PUSH}	{SUSPENSION}	t	f
Barbell Shrug	Stand holding barbell with overhand or mixed grip; shoulder width or slightly wider.	Elevate shoulders as high as possible. Lower and repeat.	Since this movement becomes more difficult as full shoulder elevation is achieved, height criteria for shoulder elevation may be needed. For example, raising shoulders until slope of shoulders becomes horizontal may be considered adequate depending upon individual body structure and range of motion with lighter weight. Also see ROM Criteria and Shoulder Shrug Errors.	{BASIC}	{ISOLATED}	{PULL}	{BARBELL}	f	f
Trap Bar Shrug	Step into trap barbell and stand holding handles of trap bar to sides.	Elevate shoulders as high as possible. Lower and repeat.	Since this movement becomes more difficult as full shoulder elevation is achieved, height criteria for shoulder elevation may be needed. For example, raising shoulders until slope of shoulders becomes horizontal may be considered adequate depending upon individual body structure and range of motion with lighter weight. Also see ROM Criteria and Shoulder Shrug Errors.	{BASIC}	{ISOLATED}	{PULL}	{BARBELL,TRAP_BAR}	f	f
Cable Shrug	Stand facing low pulley and grasp cable bar with shoulder width or slightly wider overhand grip. Stand close to pulley.	With arms straight, elevate shoulders as high as possible. Lower and repeat.	Since this movement becomes more difficult as full shoulder elevation is achieved, height criteria for shoulder elevation may be needed. For example, raising shoulders until slope of shoulders becomes horizontal may be considered adequate depending upon individual body structure and range of motion with lighter weight. Also see ROM Criteria and Shoulder Shrug Errors.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable Bar Shrug	Position adjustable pulleys at low position. Stand close to cable bar and grasp with shoulder width or slightly wider overhand grip.	Elevate shoulders as high as possible. Lower and repeat.	Since this movement becomes more difficult as full shoulder elevation is achieved, height criteria for shoulder elevation may be needed. For example, raising shoulders until slope of shoulders becomes horizontal may be considered adequate, depending upon individual body structure and range of motion with lighter weight. Also see ROM Criteria and Shoulder Shrug Errors.	{BASIC}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable One Arm Shrug	Grasp stirrup with one hand and stand close to low pulley to side.	With arms straight, elevate shoulder as high as possible. Lower and repeat.	Since this movement becomes more difficult as full shoulder elevation is achieved, height criteria for shoulder elevation may be needed. For example, raising shoulders until slope of shoulders becomes horizontal may be considered adequate depending upon individual body structure and range of motion with lighter weight. Also see ROM Criteria and Shoulder Shrug Errors.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Lever Seated Gripless Shrug	Sit on seat and place forearms in padded bars.	Elevate shoulders as high as possible. Lower and repeat.	Since this movement becomes more difficult as full shoulder elevation is achieved, height criteria for shoulder elevation may be needed. For example, raising shoulders until slope of shoulders becomes horizontal may be considered adequate depending upon individual body structure and range of motion with lighter weight. Also see ROM Criteria.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Chest Dip	Mount wide dip bar with oblique grip (bar diagonal under palm), arms straight with shoulders above hands. Bend knees and hips slightly.	Lower body by bending arms, allowing elbows to flare out to sides. When slight stretch is felt in chest or shoulders, push body up until arms are straight. Repeat.	Also see Triceps Dip.	{BASIC}	{COMPOUND}	{PUSH}	{PARALLEL_BARS}	t	f
Lever Shrug	Stand holding lever bar with shoulder width overhand or mixed grip.	Elevate shoulders as high as possible. Lower and repeat.	Since this movement becomes more difficult as full shoulder elevation is achieved, height criteria for shoulder elevation may be needed. For example, raising shoulders until slope of shoulders becomes horizontal may be considered adequate depending upon individual body structure and range of motion with lighter weight. Also see ROM Criteria and Shoulder Shrug Errors.	{BASIC}	{ISOLATED}	{PULL}	{LEVER}	f	f
Sled Gripless Shrug	Stand with shoulders under padded bar.	Elevate shoulders as high as possible. Lower and repeat.	If possible, position lever height high enough so weight will not need to be squat up that high, but not so high that weight stack bottoms out during exercise. Since this movement becomes more difficult as full shoulder elevation is achieved, height criteria for shoulder elevation may be needed. For example, raising shoulders until slope of shoulders becomes horizontal may be considered adequate depending upon individual body structure and range of motion with lighter weight. Also see ROM Criteria.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER,SLED}	f	f
Smith Shrug	Stand grasping smith bar with shoulder width or slightly wider overhand grip. Disengage bar by rotating bar back.	Elevate shoulders as high as possible. Lower and repeat.	Since this movement becomes more difficult as full shoulder elevation is achieved, height criteria for shoulder elevation may be needed. For example, raising shoulders until slope of shoulders becomes horizontal may be considered adequate depending upon individual body structure and range of motion with lighter weight. Also see ROM Criteria and Shoulder Shrug Errors.	{BASIC}	{ISOLATED}	{PULL}	{SMITH}	f	f
Cable Seated Shoulder External Rotation	Sit with side to low pulley. Grasp dumbbell cable attachment with far arm. Position elbow against side and forearm across belly.	Pull cable attachment away from body by externally rotating shoulder. Return and repeat. Turn around and continue with opposite arm.	Maintain elbow against side and fixed elbow position (90° angle) throughout exercise. Exercise may be performed standing with medium high pulley.	{AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL,CABLE}	f	f
Barbell Standing Reverse Preacher Curl	Place back of arms on pad with one foot forward. Grasp curl bar with shoulder width underhand grip.	Raise bar until forearms are vertical. Lower barbell until arm is fully extended. Repeat.	Body should be positioned to allow arm pit to rest near top of pad. Back of upper arm should remain on pad.	{AUXILIARY}	{ISOLATED}	{PULL}	{BARBELL,PREACHER}	f	f
Cable Standing Shoulder External Rotation	Stand with side to elbow height cable pulley. Grasp stirrup attachment with far arm. Position elbow against side and forearm across belly.	Pull cable attachment away from body as far as possible by externally rotating shoulder. Return and repeat. Turn around and continue with opposite arm.	Maintain elbow against side and fixed elbow position (90° angle) throughout exercise. Exercise may be performed seated on chair with pulley lowered to elbow height or seated on floor with low pulley.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable Upright Shoulder External Rotation	Stand facing low to medium height cable pulley. Grasp stirrup attachment and position bent elbow shoulder height out to side with forearm in line with cable.	Pull stirrup up and back as far as possible. Return by lowering stirrup to original position. Repeat. Continue with opposite arm.	Wrist may be kept straighter throughout movement than what is shown. Also, keep elbow at shoulder height and bent at right angle. Height of cable pulley is dependent upon:	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Lever Shoulder External Rotation	Place elbow on forearm pad and grasp handle with upper arm to side of body and forearm against body.	Pull lever away from body. Return and repeat. Adjust lever to opposite side and repeat with other arm.	Adjust lever and body orientation to achieve full range of motion.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Lever Upright Shoulder External Rotation	Lever should be forward with lever handle down. Push elbow pad forward with forearm, grasp handle with overhand grip. Sit on seat with arm pads and lever to side and position in elbow pad at shoulder height. With opposite hand, grasp seat handle if available, for added stability.	Pull lever handle upward and back as far as possible by rotating upper arm. Lower lever to original position. Repeat. Continue with opposite arm.	Exercise can also be performed with seat facing inward at 45° but this may limit internal rotation ROM of shoulder and supraspinatus will not assist.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Dumbbell Incline Shoulder External Rotation	Lie high up on low incline bench or reverse on decline bench on side with arm pit over leg pad (as demonstrated). Position legs lower on bench for support. Grasp dumbbell and position elbow against side and forearm across belly.	Lift dumbbell upright above elbow by rotating shoulder. Return and repeat. Flip body over and continue with opposite arm.	Maintain elbow against side and fixed elbow position (90° angle) throughout exercise. Position incline as low as possible so dumbbell can still be aligned against gravity.	{AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL,BENCH}	f	f
Dumbbell Prone External Rotation	Lie supine on bench with legs either on bench or down to each side. Grasp dumbbell with one hand and position forearm vertically with upper arm perpendicular to body.	Lift dumbbell forward and upward by externally rotating shoulder. Return and repeat. Grasp with opposite hand, position bent arm out to side of body, and perform with other arm.	Maintain fixed 90° angle elbow position directly lateral to shoulder throughout exercise. Also see Dumbbell Shoulder External Rotation Errors.	{AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL,BENCH}	f	f
Dumbbell Prone Incline External Rotation	Lie supine on incline bench with legs extended down to each side. Grasp dumbbell with one hand and position forearm vertically with upper arm perpendicular to body.	Lift dumbbell forward and upward by externally rotating shoulder. Return and repeat. Grasp with opposite hand, position bent arm out to side of body, and perform with other arm.	Maintain fixed 90° angle elbow position directly lateral to shoulder throughout exercise. Lower Trapezius acts as stabilizer at lower bench angles whereas Upper Trapezius may act as stabilizer and higher bench angles. Also see Dumbbell Shoulder External Rotation Errors.	{AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL,BENCH}	f	f
Dumbbell Seated Shoulder External Rotation	Sit on bench. Place foot on other side of bench and other foot on floor with knees bent. Place upper elbow on knee with dumbbell positioned above knee.	Lower dumbbell downward toward lower leg by rotating shoulder until slight stretch is felt. Return and repeat. Continue with opposite arm.	Throughout movement, keep bent elbow (approximately 90°) in front of body, chest or shoulder height.	{AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL,BENCH}	f	f
Dumbbell Upright Shoulder External Rotation	Stand or sit with dumbbell positioned out to side of head; bend elbow, shoulder height with dumbbell above elbow.	Lower dumbbell forward by rotating shoulder. Return and repeat. Continue with opposite arm.	Throughout movement, keep bent elbow (approximately 90°) out to side, shoulder height.	{AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL}	f	f
Suspended Shoulder External Rotation	Grasp suspension handles and position bent elbows to each sides of waist.	Pull handles apart from each side, while keeping fixed elbow position and body and legs straight throughout movement. Raise forward so handles are to each side of body. Return back until handles come back together in front of body. Repeat.	A very upright position (ie: very light resistance) with one foot positioned back slightly (see 'Easier') is typically required for proper execution. Take care to maintain tension on suspension trainer near top of movement. Dismounting can be achieved by walking backward until body is upright or stepping out at top of movement. This exercise can be performed on TRXⓇ style suspension trainer or adjustable length gymnastics rings.	{AUXILIARY}	{ISOLATED}	{PULL}	{SUSPENSION}	t	f
Cable Seated Shoulder Internal Rotation	Sit with side to low pulley. Grasp cable stirrup with near arm. Position elbow against side with elbow bent approximately 90°.	Pull cable stirrup toward body by internally rotating shoulder until forearm is across belly. Return and repeat. Continue with opposite arm.	Maintain elbow against side and fixed elbow position throughout exercise. Exercise may be performed standing with medium high / adjustable pulley	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable Standing Shoulder Internal Rotation	Stand with side to elbow height cable pulley. Grasp cable stirrup with near arm. Position elbow against side with elbow bent approximately 90°.	Pull cable stirrup toward body by internally rotating shoulder until forearm is across belly. Return and repeat. Continue with opposite arm.	Maintain elbow against side and fixed elbow position throughout exercise. Exercise may be performed seated if medium high / adjustable pulley is not availble.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Lever Shoulder Internal Rotation	Place elbow on forearm pad and grasp handle with upper arm to side of body and forearm away from body.	Pull lever toward from body. Return and repeat. Adjust lever to opposite side and repeat with other arm.	Adjust lever and body orientation to achieve full range of motion.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Lever Upright Shoulder Internal Rotation	Primary lever should be positioned back with lever handle resting forward on elbow pad. Lift lever handle and sit on seat with arm pads and lever to side. Place elbow in elbow pads at shoulder height and grip handle with over hand grip so forearm is orientated upward and back. With opposite hand, grasp seat handle if available, for added stability.	Pull lever handle forward and downward as far as possible by rotating upper arm. Allow lever to return to original position. Repeat. Continue with opposite arm.	Turn seat facing inward at 45° if external rotation ROM of shoulder is limited. Consequently placing the upper arm in this plane limits internal rotation ROM of shoulder and Supraspinatus will assist slightly in interal rotation.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Cable Chest Dip	Step between wide dip bars with dip belt around waist. Kneel as close as possible to low pulley and attach cable to dip belt. Stand up and mount dip bar with oblique grip (bar diagonal under palm), arms straight with shoulders above hands. Keep hips and knees bent.	Lower body by bending arms, allowing elbows to flare out to sides. When slight stretch is felt in chest or shoulders, push body up until arms are straight and repeat.	The animation depicts dip bar placed in front of low pull cable. If cable dip machine is available, attach hip harness and step up to dip bar. Also see Cable Triceps Dip.	{BASIC}	{COMPOUND}	{PUSH}	{CABLE}	f	f
Barbell Bench Press	Lie supine on bench. Dismount barbell from rack over upper chest using wide oblique overhand grip.	Lower weight to chest. Press bar upward until arms are extended. Repeat.	Range of motion will be compromised if grip is too wide.	{BASIC}	{COMPOUND}	{PUSH}	{BARBELL,BENCH}	f	f
Push-up Plus	Lie prone on floor with hands slightly wider than shoulder width. Raise body up off floor by extending arms with body straight.	Keeping body straight, lower body to floor by bending arms. Push body up until arms are extended. Continue lifting body further up by pushing shoulders infront of chest. Repeat.	Both upper and lower body must be kept straight throughout movement. See similar Push-up exercises targeting Pectoralis Major.	{AUXILIARY}	{COMPOUND}	{PUSH}	{}	t	f
Barbell Decline Bench Press	Lie supine on decline bench with feet under leg brace. Dismount barbell from rack over chest using wide oblique overhand grip.	Lower weight to chest. Press bar until arms are extended. Repeat.	Range of motion will be compromised if grip is too wide. Latissimus Dorsi involvement is l ow on Decline Bench Press (Barnett 1995). Also see Bench Press Analysis.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{BARBELL,BENCH}	f	f
Cable Decline Fly	Grasp two opposing high pulley dumbbell attachments. Lie supine on decline bench, in middle and perpendicular to both pulleys. Slightly bend elbows and internally rotate shoulders so elbows are back.	Bring cable stirrups together above upper abdomen in hugging motion; elbows in fixed position and shoulders internally rotated so elbows are to sides. Return to starting position until chest is slightly stretched. Repeat.	Since incline of bench does not actually affect angle of pull as with dumbbells, similar effect can be achieved on flat bench if cable stirrups are brought together above upper abdomen instead of chest. Keep shoulders internally rotated so elbows point downward at bottom position and outward at top position. Keep elbows at fixed angle, only slightly bent. Anterior Deltoid will no longer act as synergist in steep decline bench position.	{AUXILIARY}	{ISOLATED}	{PUSH}	{DUMBBELL,CABLE,BENCH}	f	f
Cable Lying Fly	Grasp two opposing low pulley stirrup attachments. Lie supine on bench, in middle and perpendicular to both pulleys. Slightly bend elbows and internally rotate shoulders so elbows are back.	Bring cable attachments together in hugging motion with elbows in fixed position and shoulders internally rotated so elbows are to sides. Return to starting position until slight stretch. Repeat.	Keep shoulders internally rotated so elbows point downward at bottom position and outward at top position. Keep elbows at fixed angle, only slightly bent.	{AUXILIARY}	{ISOLATED}	{PUSH}	{CABLE,BENCH}	f	f
Cable Seated Fly	Sit on seat and grasp stirrups to each side. Slightly bend elbows and internally rotate shoulders so elbows are back.	Keeping elbows pointed high, bring cable attachments together in hugging motion with elbows in fixed position. Return to starting position until slight stretch. Repeat.	Shoulders are kept internally rotated so elbows are pointing back and out to sides.	{AUXILIARY}	{ISOLATED}	{PUSH}	{CABLE}	f	f
Cable Standing Fly	Grasp two opposing high pulley dumbbell attachments. Stand with pulleys to each side. Bend over slightly by flexing hips and knees. Bend elbows slightly and internally rotate shoulders so elbows are back initially.	Bring cable attachments together in hugging motion with elbows in fixed position. Keep shoulders internally rotated so elbows are pointed upward at top and out to sides at bottom. Return to starting position until chest muscles are stretched. Repeat.	Under greater resistance, positioning torso at lower angle downward (by bending over at hips), will allow upper body weight to counterbalance upward pull of cables, as opposed to stepping forward and struggling with backward pull of cables.	{AUXILIARY}	{ISOLATED}	{PUSH}	{DUMBBELL,CABLE}	f	f
Cable Bench Press	Lie on bench and grasp stirrups attached to low cable pulley on each side. Position stirrups out to each side of chest with bent arm under each wrist.	Push stirrups up over each shoulder until arms are straight and parallel to one another. Return stirrups to original position, until slight stretch is felt in shoulders or chest. Repeat.	Stirrup should follow slight arch pattern, above upper arm between elbow and chest at bottom, traveling inward over each shoulder at t op. Also see Bench Press Analysis.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE,BENCH}	f	f
Cable Bar Bench Press	Position adjustable pulley higher than intended height but within arms reach from bench. Position bench under cable bar. Lie supine on bench. While lying on bench, reach over and lower each pulley into intended position so that cables are taut in lowest position with bar on chest. Grasp bar with both hands using wide oblique overhand grip.	Press bar upward until arms are extended. Lower bar to chest or until slight stretch is felt in shoulders. Repeat.	Range of motion will be compromised if grip is too wide. Also see Bench Press Analysis and Cable Bar Standing Bench Press.	{BASIC}	{COMPOUND}	{PUSH}	{CABLE,BENCH}	f	f
Cable Chest Press	Sit on seat and grasp stirrups to each side. Position elbows out to sides, slightly lower than shoulder height. Position hands slightly narrower than elbow width in front of upper arms.	Push stirrups out straight until arms are straight and parallel to one another. Return stirrups to original position, until slight stretch is felt in shoulders or chest. Repeat.	Stirrup should follow slight arch pattern, in front of upper arm between elbow and chest in stretched position, traveling inward in front of each shoulder at extended position.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE}	f	f
Cable One Arm Chest Press	Sit on seat and grasp stirrup to one side. Position elbows out to side, slightly lower than shoulder height. Position hand slightly narrower than elbow width in front of upper arm.	Push stirrups out straight in front of shoulder until arm is straight. Return stirrups to original position until slight stretch is felt through shoulder or chest. Repeat.	Also see exercise performed with twisting movement. Pectoralis Minor and Serratus Anterior act as stabilizers if torso is not against back support as shown.	{AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE}	f	f
Cable Standing Chest Press	Stand between two shoulder height pulleys, facing away from cable columns. Grasp cable stirrups from each side. Position stirrups to sides of chest with elbows out to sides. Position forearms horizontally and parallel with hands elbow width. Step forward in lunging posture (one foot in front and other foot behind). Lean and step forward with one foot in front, bending forward leg.	Push stirrups forward until arms are straight and parallel to one another. Return stirrups to original position until slight stretch is felt in chest or shoulders. Repeat.	Stirrup should follow slight arch pattern as hands travel closer together toward extension. Cable pulleys should be relatively close together, narrower than width of arms extended out to sides (but not too close), closer than what is typically found on standard cable cross over setup.	{AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE}	f	f
Cable Bar Standing Chest Press	Stand facing behind cable bar, mounted on each side to shoulder height narrow double pulley cables. Grasp cable bar with wide overhand grip. Position bar chest height with elbows angled behind. Lean and step forward with one foot in front, bending forward leg.	Push cable bar forward until arms are straight. Return cable bar to original position until slight stretch is felt in chest or shoulders. Repeat.	Cable pulleys should be relatively close together, narrower than width of arms extended out to sides (but not too close), closer than what is typically found on standard cable cross over setup. Range of motion will be compromised if grip is too wide.	{AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE}	f	f
Cable Twisting Chest Press	Sit on seat and grasp stirrup to one side. Position elbow out to side, slightly lower than shoulder height. Position hand slightly narrower than elbow width, in front of upper arm. Lean forward in seat.	Push stirrup out in front of upper chest while turning torso away from pulley. Return stirrup and torso back to original position allowing torso to rotate back until slight stretch is felt through chest, shoulder or waist. Repeat.	The effective range of motion of Pectoralis Major is only about half of what it is in non-twisting movement.	{AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE}	f	f
Cable Decline Chest Press	Sit on seat and grasp stirrups to each side. Position elbows out to sides, slightly lower than shoulder height. Position hands slightly narrower than elbow width in front of upper arms.	Push stirrups forward and slightly downward until arms are straight and parallel to one another. Return stirrups to original position, until slight stretch is felt in shoulders or chest. Repeat.	Stirrup should follow slight arch pattern, in front of upper arm between elbow and chest in stretched position, traveling inward and slightly downward just below each shoulder at ex tended position. Latissimus Dorsi involvement is low on Decline Bench Press (Barnett 1995).	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE,BENCH}	f	f
Cable Bar Standing Decline Chest Press	Stand facing behind cable bar mounted on each side to shoulder height narrow double pulley cables. Grasp cable bar with wide overhand grip. Position bar chest height with elbows angled behind and above. Lean and step forward with one foot in front, bending forward knee.	Push cable bar forward and downward until bar is about hip height and arms are straight. Return cable bar to original position until slight stretch is felt in chest or shoulders. Repeat.	Cable pulleys should be relatively close together, narrower than width of arms extended out to sides (but not too close), closer than what is typically found on standard cable cross over setup.	{AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE}	f	f
Cable Standing Decline Chest Press	Stand between two high pulleys, facing away from cable columns. Grasp cable stirrups from each side. Position stirrups down to sides of lower chest with elbows high out to sides. Angle forearms downward with hands elbow width or slightly narrower. Lean and step forward with forward leg bent or stand feet side by side with both legs slightly bent (as shown).	Push stirrups at forward/downward angle until arms are straight and parallel to one another. Return stirrups to original position until slight stretch is felt in chest or shoulders. Repeat.	Stirrup should follow slight arch pattern as hands travel closer together toward extension. Cable pulleys should be relatively close together, narrower than width of arms extended out to sides (but not too close), closer than what is typically found on standard cable cross over setup.	{AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE}	f	f
Cable Twisting Standing Chest Press	Grasp cable stirrup from chest height pulley. Turn body away from pulley. Position elbow of loaded arm out to side, lower chest height. Position loaded hand back approximately shoulder height and elbow width. Step far forward with foot of opposite side of loaded arm. Bend knees and position heel off rear foot off floor.	Push stirrups away from body, horizontally until arm is straight and inline with cable. Return stirrups to original position until slight stretch is felt in chest or shoulder. Repeat. Continue with opposite arm.	Stirrup should follow slight arch pattern, in front of upper arm between elbow and chest in stretched position, traveling inward in front shoulder at contracted position.	{AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE}	f	f
Dumbbell Decline Bench Press	Sit down on decline bench with feet under leg brace and dumbbells resting on thigh. Lie back with dumbbells. Position dumbbells to sides of chest with bent arm under each dumbbell.	Press dumbbells up with elbows to sides until arms are extended. Lower weight to sides of chest until slight stretch is felt in chest or shoulder. Repeat.	Stirrup should follow slight arch pattern, above upper arm between elbow and chest at bottom, traveling inward over each shoulder at top. No need to drop weights - see suggested mount and dismount technique. Latissimus Dorsi involv ement is low on Decline Bench Press (Barnett 1995). Also see mount & dismount from special machine rack and Bench Press Analysis.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{DUMBBELL,BENCH}	f	f
Barbell Reverse Curl	Grasp bar with shoulder width overhand grip.	With elbows to side, raise bar until forearms are vertical. Lower until arms are fully extended. Repeat.	When elbows are fully flexed, they can travel forward slightly, allowing forearms to be no more than vertical. This additional movement allows for relative release of tension in muscles between repetitions.	{AUXILIARY}	{ISOLATED}	{PULL}	{BARBELL}	f	f
Dumbbell Decline Fly	Grasp two dumbbells. Lie supine on decline bench. Support dumbbells above upper abdomen with arms fixed in slightly bent position. Internally rotate shoulders so elbows are to sides.	Lower dumbbells to sides until chest muscles are stretched with elbows fixed. Bring dumbbells together in wide hugging motion until dumbbells are nearly together. Repeat.	Keep elbows at fixed angle, only slightly bent, and pointing outward, opposite direction of upward motion. Anterior Deltoid will no longer act as synergist in steep decline bench position.	{AUXILIARY}	{ISOLATED}	{PUSH}	{DUMBBELL,BENCH}	f	f
Dumbbell Fly	Grasp two dumbbells. Lie supine on bench. Support dumbbells above chest with arms fixed in slightly bent position. Internally rotate shoulders so elbows point out to sides.	Lower dumbbells to sides until chest muscles are stretched with elbows fixed in slightly bent position. Bring dumbbells together in wide hugging motion until dumbbells are nearly together. Repeat.	Keep shoulders internally rotated so elbows point downward at bottom position and outward at top position. Keep elbows at fixed angle, only slightly bent.	{AUXILIARY}	{ISOLATED}	{PUSH}	{DUMBBELL,BENCH}	f	f
Dumbbell Pullover	Lie on upper back perpendicular to bench. Flex hips slightly. Grasp one dumbbell from behind or from side with both hands under inner plate of dumbbell. Position dumbbell over chest with elbows slightly bent.	Keeping elbows slightly bent throughout movement, lower dumbbell over and beyond head until upper arms are in-line with torso. Pull dumbbell up and over chest. Repeat.	Lower body extending off of bench acts as counter balance to resistance and keeps upper back fixed on bench. Avoid hips from raising up significantly. Actual range of motion is dependent upon individual shoulder flexibility. Keep elbows fixed at small bend throughout exercise. See suggested mount & dismount.	{AUXILIARY}	{ISOLATED}	{PUSH}	{DUMBBELL,BENCH}	f	f
Lever Chest Dip	If possible, place handles in wide position. Sit on seat and grasp handles with oblique grip. Lean forward slightly and allow elbows to flare out.	Push lever down by straightening arms. Return lever up with elbows flaring out until chest is slightly stretched. Repeat.	See Lever Chest Dip on machine facing fulcrum. Also see Lever Triceps Dip.	{BASIC}	{COMPOUND}	{PUSH}	{LEVER}	f	f
Lever Pec Deck Fly	Sit on machine with back on pad. If available, push foot lever until padded lever moves forward. Place forearms on padded lever. Position upper arms approximately parallel. Release foot lever.	Push levers together. Return until chest muscles are stretched. Repeat.	None	{AUXILIARY}	{ISOLATED}	{PUSH}	{LEVER}	f	f
Lever Lying Fly	Lie supine on bench. Position both arms under padded levers. Slightly bend elbows and internally rotate shoulders so elbows are back.	Bring padded levers upward and together in hugging motion. Return to starting position until chest muscles are stretched. Repeat.	Shoulders should be internally rotated so elbows are pointing downward at bottom of motion and outward at top of motion.	{AUXILIARY}	{ISOLATED}	{PUSH}	{LEVER,BENCH}	f	f
Lever Decline Pec Deck Fly	Sit on machine with back on pad. If available, push foot lever until padded lever moves forward. Place forearms on padded lever. Position upper arms approximately parallel. Release foot lever.	Push levers together. Return until chest muscles are stretched. Repeat.	None.	{AUXILIARY}	{ISOLATED}	{PUSH}	{LEVER}	f	f
Lever Bench Press	Lie supine on bench with chest under lever bar. Grasp lever bar with wide oblique overhand grip.	Press bar until arms are extended. Lower weight to upp er chest. Repeat.	Range of motion will be compromised if grip is too wide. Also see Bench Press Analysis.	{BASIC}	{COMPOUND}	{PUSH}	{LEVER,BENCH}	f	f
Lever Seated Fly	Sit on machine with back on pad. Grasp handles to both sides, shoulder height. Slightly bend elbows and internally rotate shoulders so elbows are back.	Keeping elbows pointed high, push lever handles forward and together. Return to back toward original position until mild stretch is felt in chest or shoulder. Repeat.	Shoulders are kept internally rotated so elbows are pointing out to sides. Adjust lever arms on machine so slight stretch is felt when weight is lowered. Also see exercises on alternative machine.	{AUXILIARY}	{ISOLATED}	{PUSH}	{LEVER}	f	f
Lever Alternating Chest Press	Sit on seat with lever grips lower chest height. Grasp grips with wide overhand grip; elbows out to sides just below shoulders.	Press one lever until arm is extended. Return lever back until chest muscle is slightly stretched. Repeat with opposite arm, alternating between sides.	Range of motion will be compromised if grip is too wide.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{LEVER}	f	f
Lever Decline Chest Press	Sit on seat with lever grips lower chest height. Grasp grips with wide overhand grip; elbows out to sides just below shoulders.	Press lever until arms are extended. Return weight until chest muscles are slightly stretched. Repeat.	Range of motion will be compromised if grip is too wide. Latissimus Dorsi involvement is low on Decline Bench Press (Barnett 1995). Also see Bench Press Analysis.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{LEVER,BENCH}	f	f
Lever Alternating Decline Chest Press	Sit on seat with lever grips lower chest height. Grasp grips with wide overhand grip; elbows out to sides just below shoulders.	Press one lever until arm is extended. Return lever back until chest muscle is slightly stretched. Repeat with opposite arm, alternating between sides.	Range of motion will be compromised if grip is too wide.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{LEVER}	f	f
Lever Decline Bench Press	Lie supine on decline bench with feet under leg brace and chest under lever bar. Grasp lever bar with wide oblique overhand grip.	Press bar until arms are extended. Lower weight to chest. Repeat.	Range of motion will be compromised if grip is too wide. Latissimus Dorsi involvement is low on Decline Bench Press (Barnett 1995). Also see Bench Press Analysis.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{LEVER,BENCH}	f	f
Lever Seated Iron Cross Fly	Straddle seat with both levers positioned slightly above horizontal. Grasp both lever ends with elbows slightly above levers. Sit down near end of seat with torso leaning forward slightly and slightly bent elbows pointing back.	Push levers downward and together in hugging motion. Keep shoulders internally rotated so elbows are pointed slightly upward at top and out to sides at bottom. Return to starting position until chest muscles are stretched. Repeat.	Under greater resistance, positioning torso at lower angle downward (by bending over at hips), will allow upper body weight to counterbalance upward pull of cables, as opposed to stepping forward and struggling with the backward pull of cables. Also see Bent-over Fly on Standing Iron Cross Machine.	{AUXILIARY}	{ISOLATED}	{PUSH}	{CABLE,LEVER}	f	f
Lever Chest Press	Sit on seat with chest approximately height of horizontal handles. If available, push foot lever until lever is within grasping range. Grasp handles with wide overhand grip; elbows out to sides just below shoulders. Release foot lever.	Press lever until arms are extended. Return weight until chest muscles are slightly stretched. Repeat.	Some machines have foot levers to position handles in a more comfortable starting and ending position. If foot lever is available, engage it before grasping handles, release it before performing exercise, and engage it again just before releasing grips.	{BASIC}	{COMPOUND}	{PUSH}	{LEVER}	f	f
Lever Parallel Grip Chest Press	Sit on seat with sides of ribs approximately height of parallel handles. If available, push foot lever until handles are within grasping range. Grasp parallel handles. Release foot lever.	Press lever until arms are extended. Return weight until shoulders or chest feels slightly stretched. Repeat.	Some machines have foot levers to position handles in a more comfortable starting and ending position. If foot lever is available, engage it before grasping handles, release it before performing exercise, and engage it again just before releasing grips.	{BASIC}	{COMPOUND}	{PUSH}	{LEVER}	f	f
Sled Standing Chest Dip	Stand between handles facing machine. Bend forward slightly and grasp parallel handles with oblique grip. Position elbows upward and outward. Bend knees just enough to raise selected weight up from remaining weight stack.	Push lever down by straightening arms. Return lever up with elbows flaring out until chest is slightly stretched. Repeat.	This particular machine design is rare. See typical dip machines:	{BASIC}	{COMPOUND}	{PUSH}	{LEVER,SLED}	f	f
Sled Horizontal Grip Standing Chest Dip	Stand between handles facing machine. Bend forward slightly and grasp transverse handles with overhand grip. Position elbows upward and outward. Bend knees just enough to raise selected weight up from remaining weight stack.	Push lever down by straightening arms. Return lever up with elbows flaring out until chest is slightly stretched. Repeat.	Both the machine design and handle orientation are rare. See typical dip machines:	{BASIC}	{COMPOUND}	{PUSH}	{LEVER,SLED}	f	f
Smith Bench Press	Lie supine on bench with chest under bar. Grasp bar with wide oblique overhand grip. Disengage bar by rotating bar back.	Lower weight to chest. Press bar until arms are extended. Repeat.	Range of motion will be compromised if grip is too wide. Also see Bench Press Analysis.	{BASIC}	{COMPOUND}	{PUSH}	{SMITH,BENCH}	f	f
Smith Decline Bench Press	Lie supine on decline bench with feet under leg brace and chest under bar. Grasp bar with wide oblique overhand grip. Disengage bar by rotating bar back.	Lower weight to chest. Press bar until arms are extended. Repeat.	Range of motion will be compromised if grip is too wide. Latissimus Dorsi involvement is low on Decline Bench Press (Barnett 1995). Also see Bench Press Analysis.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{SMITH,BENCH}	f	f
Push-up	Lie prone on floor with hands slightly wider than shoulder width. Raise body up off floor by extending arms with body straight.	Keeping body straight, lower body to floor by bending arms. Push body up until arms are extended. Repeat.	Both upper and lower body must be kept straight throughout movement. See close grip push-up. Also see push-up test calculator.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{}	t	f
Incline Push-up	Stand facing bench or sturdy elevated platform. Place hands on edge of bench or platform, slightly wider than shoulder width. Position forefoot back from bench or platform with arms and body straight. Arms should be perpendicular to body.	Keeping body straight, lower chest to edge of box or platform by bending arms. Push body up until arms are extended. Repeat.	Both upper and lower body must be kept straight throughout movement. Height of bench or platform affects difficulty of movement.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{BENCH}	t	f
Push-up (on knees)	Lie prone on floor with hands slightly wider than shoulder width. Bend knees and raise body up off floor by extending arms with body straight.	Keeping body straight and knees bent, lower body to floor by bending arms. Push body up until arms are extended. Repeat.	Both upper and lower body must be kept straight throughout movement. Forefeet can remain on floor as long as body is pivoting on knees. See close grip push-up. Also see push-up test calculator.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{}	t	f
Suspended Chest Dip	Stand between two suspension handles and grasp handles on each side of torso. Hold position firmly and lift feet from floor.	Push body up until arms are straight. Lower body until slight stretch is felt in shoulders. Repeat.	To emphasize chest, position body bent over by bending hips. Also see Triceps Dips.	{BASIC}	{COMPOUND}	{PUSH}	{SUSPENSION}	t	f
Suspended Chest Press	Grasp handles and step forward between suspension trainers. Position arms downward and slightly forward, nearly parallel with suspension straps. Lean forward, placing upper body weight onto handles with arms straight, while stepping back onto forefeet so body is leaning forward at desired angle. Straighten body so torso is in-line with legs.	Lower body by bending arms while keeping body straight. Allow handles to come apart slightly to keep in-line with elbows flaring out. Stop descent once mild stretch is felt through shoulders or chest. Push body up to original position, allowing handles to travel inward to keep in line with elbows converging until arms are fully extended. Repeat.	See Suspended Chest Press Mount/Dismount. Arms and suspension straps should be perpendicular to body. Both upper and lower body must be kept straight throughout movement. Elbows largely remain behind hands' line of force.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{SUSPENSION}	t	f
Cable Standing Incline Fly	Stand between two pulleys position hip height and arms width or slightly wider apart. Grasp stirrups, one in each hand. Extend arms out with elbows slightly bent, pointed back and downward slightly. Step forward until cables are taut or when weights are lifted up slightly. Stand with feet staggered.	Keeping elbows fixed in slightly bent position, bring stirrups together in upwardly arching, hugging motion, at 30º to 45º angle until they meet at top of motion. Lower stirrups to original position in reverse pattern. As soon as stretch is felt in chest or shoulders, repeat motion.	None	{AUXILIARY}	{ISOLATED}	{PUSH}	{CABLE}	f	f
Suspended Fly	Grasp handles and step forward between suspension trainer. Position arms downward and slightly forward, nearly parallel with suspension straps. Lean forward, placing upper body weight onto handles with arms straight, while stepping back onto forefeet, so body is leaning forward at desired angle. Straighten body so torso is in-line with legs. Bend elbows slightly and internally rotate shoulders, so elbows are pointed outward to each side.	Lower body by allowing suspension handles to separate outward until mild stretch is felt in chest. Reverse motion by bringing handles back together in hugging motion. Repeat.	See Suspended Prone Mount/Dismount. Throughout movement, keep elbows in fixed, slightly bent position and shoulders internally rotated, so elbows are kept pointed outward and high. Arms and suspension straps plane of motion should be perpendicular to body. Both upper and lower body must be kept straight throughout movement. Angle of body affects difficulty of movement. See Gravity Vectors for greater understanding of how body angle influences resistance.	{AUXILIARY}	{ISOLATED}	{PUSH}	{SUSPENSION}	t	f
Barbell Incline Bench Press	Lie supine on incline bench. Dismount barbell from rack over upper chest using wide oblique overhand grip.	Lower weight to upper chest. Press bar until arms are extended. Repeat.	Range of motion will be compromised if grip is too wide. Also see Bench Press Analysis.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{BARBELL,BENCH}	f	f
Cable Incline Bench Press	Sit on seat and grasp stirrups to each side (attached to low cable pulleys). Lie back on incline back support. Position stirrups out to each side of chest with bent arm under each wrist.	Push stirrups up over each shoulder until arms are straight and parallel to one another. Return stirrups to original position, until slight stretch is felt in chest or shoulders. Repeat.	Stirrup should follow slight arch pattern, above upper arm between elbow and chest at bottom, traveling inward over each shoulder at top.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE,BENCH}	f	f
Cable Bar Incline Bench Press	Position adjustable pulley higher than intended height, but within arms reach from incline bench. Position incline bench under cable bar. Lie supine on incline bench. While lying on bench, reach over and lower each pulley into intended position so that cables are taut in lowest position with bar on chest. Grasp bar with both hands using wide oblique overhand grip.	Press bar upward until arms are extended. Lower bar to upper chest or until slight stretch is felt in shoulders. Repeat.	Range of motion will be compromised if grip is too wide. Also see Bench Press Analysis.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE,BENCH}	f	f
Cable Incline Chest Press	Sit on seat and grasp stirrups to each side (attached to medium height pulleys). Position elbows out to sides, slightly lower than shoulder height. Position hands back approximately shoulder height and elbow width.	Push stirrups away from body, slightly upward at 30º to 45º until arms are straight and parallel to one another. Return stirrups to original position until slight stretch is felt in chest or shoulders. Repeat.	Stirrup should follow slight arch pattern, in front/above of upper arm between elbow and chest in stretched position, travelling inward in front/above each shoulder at contracted position.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE}	f	f
Cable Standing Incline Chest Press	Stand between two hip height pulleys, facing away from cable columns. Grasp cable stirrups from each side. Position elbows out to sides, lower chest height. Position hands back approximately shoulder height and elbow width. Lean and step forward with one foot in front bending forward knee.	Push stirrups forward and upward at 30º to 45º angle until arms are straight and parallel to one another. Return stirrups to original position until slight stretch is felt in chest or shoulders. Repeat.	Stirrup should follow slight arch pattern, in front/above of upper arm between elbow and chest in stretched position, travelling inward in front/above each shoulder at contracted position. Cable pulleys should be closer together than what is typically found on standard cable cross over setup.	{AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE}	f	f
Cable Bar Standing Incline Chest Press	Stand facing behind cable bar, mounted on each side to lower chest height narrow double pulley cables. Grasp cable bar with wide overhand grip. Position bar upper mid-chest height with elbows angled behind and downward. Lean and step forward with one foot in front, bending forward knee.	Push cable bar forward and upward at 30º to 45º until arms are straight. Return cable bar to original position until slight stretch is felt in chest or shoulders. Repeat.	Cable pulleys should be closer together than what is typically found on standard cable cross over setup. Range of motion will be compromised if grip is too wide.	{AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE}	f	f
Cable One Arm Standing Incline Chest Press	Grasp cable stirrup from hip height pulley. Turn body away from pulley. Position elbow of loaded arm out to side, lower chest height. Position loaded hand back approximately shoulder height and elbow width. Step far forward with foot of opposite side of loaded arm. Bend knees and position heel of rear foot off floor.	Push stirrups forward and upward at 30º to 45º until arm is straight and in-line with cable. Return stirrup to original position until slight stretch is felt in chest or shoulder. Repeat. Continue with opposite arm.	Stirrup should follow slight arch pattern, in front/above of upper arm between elbow and chest in stretched position, travelling inward in front/above shoulder at contracted position.	{AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE}	f	f
Cable Incline Fly	Sit on seat with stirrups in each hand (attached to low cable pulleys). Lie back on incline back support. Position stirrups out to each side of chest with bent arm under each wrist. Press stirrups over each shoulder until arms vertical. Bend elbows slightly and internally rotate shoulders so elbows point out to sides.	Lower stirrups outward to sides of shoulders. Keep elbows fixed in slightly bent position. When a stretch is felt in chest or shoulders, bring stirrups back together in hugging motion above upper chest until stirrups are nearly together Repeat.	Keep shoulders internally rotated so elbows point downward at bottom position and outward at top position. Shoulder will likely have less range of motion in lower position as compared to Fly on flat bench.	{AUXILIARY}	{ISOLATED}	{PUSH}	{CABLE,BENCH}	f	f
Smith Incline Shoulder Raise	Lie supine on incline bench with shoulders under bar. Grasp bar with shoulder width overhand grip. Extend elbows. Disengage bar by rotating bar back.	Raise shoulders toward bar as high as possible. Lower shoulders to bench and repeat.	Keep arms straight throughout execution. For convenience, exercise can be performed immediately after warm up on Smith Incline Chest Press.	{AUXILIARY}	{ISOLATED}	{PUSH}	{SMITH,BENCH}	f	f
Lever Incline Bench Press	Lie supine on incline bench with upper chest under lever bar. Grasp lever bar with wide oblique overhand grip.	Press bar until arms are extended. Lower weight to upper chest. Repeat.	Range of motion will be compromised if grip is too wide. See Lever Incline Bench Press improvised on older equipment and exercise performed with parallel grip. Also see Bench Press Analysis.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{LEVER,BENCH}	f	f
Lever Parallel Grip Incline Bench Press	Lie supine on incline bench with parallel lever bars out to sides of rib cage. Grasp parallel handles.	Press lever bars up until arms are extended. Lower weight toward upper chest. Repeat.	Seat should be adjusted so handles are to sides of lower chest. Parallel grip tends to place shoulders in a more stable position, with arms closer to sides, which may be more ideal for those with certain shoulder issues. Also see exercise performed with standard grip providing greater emphasis on chest development. Also see Bench Press Analysis.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{LEVER,BENCH}	f	f
Lever Alternating Incline Chest Press	Sit on seat with upper chest just above grips on lever. Grasp grips with wide overhand grip and position elbows out to sides.	Press one lever until arm is extended. Return lever back down until chest muscle is slightly stretched. Repeat with opposite arm, alternating between sides.	Range of motion will be compromised if grip is too wide.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{LEVER}	f	f
Dumbbell Incline Fly	Grasp two dumbbells. Lie supine on bench. Support dumbbells above upper chest with arms fixed in slightly bent position. Bend elbows slightly and internally rotate shoulders so elbows point out to sides.	Lower dumbbells outward to sides of shoulders. Keep elbows fixed in slightly bent position. When a stretch is felt in chest or shoulders, bring dumbbells back together in hugging motion above upper chest until dumbbells are nearly together. Repeat.	Keep shoulders internally rotated so elbows point downward at bottom position and outward at top position. Shoulder will likely have less range of motion in lower position as compared to Fly on flat bench.	{AUXILIARY}	{ISOLATED}	{PUSH}	{DUMBBELL,BENCH}	f	f
Lever Incline Fly	Lie supine on bench. Position inside of forearms under roller pads with arms out to each side. Slightly bend elbows and internally rotate shoulders so elbows are back.	Raise lever upward and together in hugging motion. Lower weight until slight stretch is felt in chest or shoulder. Repeat.	Elbows should be pointing downward at bottom of motion and outward on top of motion.	{AUXILIARY}	{COMPOUND}	{PUSH}	{LEVER,BENCH}	f	f
Smith Incline Bench Press	Lie supine on incline bench with upper chest under bar. Grasp bar with wide oblique overhand grip. Disengage bar by rotating bar back.	Lower weight to upper chest. Press bar until arms are extended. Repeat.	Range of motion will be compromised if grip is too wide. Also see Bench Press Analysis.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{SMITH,BENCH}	f	f
Decline Push-up	Kneel on floor with bench or elevation behind body. Position hands on floor slightly wider than shoulder width. Place feet on bench or elevation. Raise body in plank position with body straight and arms extended.	Keeping body straight, lower upper body to floor by bending arms. To allow for full descent, pull head back slightly without arching back. Push body up until arms are extended. Repeat.	Both upper and lower body must be kept straight throughout movement. Range of motion will be compromised if grip is too wide or neck is protracted. Very high elevations may not involve sternal head of pectoralis major.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{BENCH}	t	f
Lever Incline Chest Press	Sit on seat with upper chest just above grips on lever. If available, push foot lever until handles are within grasping range. Grasp handles with wide oblique overhand grip and position elbows out to sides. Release foot lever.	Press lever until arms are extended. Return weight until shoulders or chest feels slightly stretched. Repeat.	Some machines have foot levers to position handles in a more comfortable starting and ending position. If foot lever is available, engage it before releasing grips.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{LEVER}	f	f
Pike Push-up	Kneel on two benches positioned side by side slightly apart at end nearest head. Place hands on ends of benches. With forefeet on opposite ends of bench, raise rear end high up with arms, back, and knees straight.	Lower head between ends of benches by bending arms. Push body back up to original position by extending arms. Repeat.	Pike Push-up (for upper chest) differs from Pike Press (for front delts) in that, feet are further away from hands so body is less inverted in lowest position.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{BENCH}	t	f
Cable Incline Shoulder Raise	Sit on seat and grasp stirrups to each side. Push stirrups out at 30º to 45º until arms are straight and parallel to one another.	Raise shoulders toward stirrups as high as possible. Lower shoulders down and back and repeat.	Keep arms straight throughout execution. For convenience, exercise can be performed immediately after warm up on Cable Incline Chest Press.	{AUXILIARY}	{ISOLATED}	{PUSH}	{CABLE}	f	f
Lever Parallel Grip Incline Chest Press	Sit on seat with lower chest at height of parallel handles. If available, push foot lever until handles are within grasping range. Grasp parallel handles.	Press lever bars up until arms are extended. Return weight until shoulders or chest feels slightly stretched. Repeat.	Some machines have foot levers to position handles in a more comfortable starting position. If available, push lever with foot, grasp bar, and release foot lever.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{LEVER}	f	f
Cable One Arm Incline Push	Sit on seat and grasp stirrup with one hand. Position elbow out to side, slightly lower than shoulder height. Position hand down, slightly higher than shoulder height, slightly narrower than elbow width.	Push stirrup forward and up at 30º to 45º while rotating torso away allowing shoulder to be extended forward. Return stirrups to original position, until slight stretch, and repeat. Continue with opposite side.	None	{AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE}	f	f
Lever Incline Shoulder Raise	Sit on lever chest press machine with shoulders aligned with lever grips. Grasp lever grips with shoulder width overhand grip. Push weight up so arms are straight.	Raise shoulders toward lever grips as far as possible. Lower shoulders to bench and repeat.	Keep arms straight throughout execution. For convenience, exercise can be performed immediately after warm up on Lever Incline Chest Press.	{AUXILIARY}	{ISOLATED}	{PUSH}	{LEVER,BENCH}	f	f
Barbell Reverse Preacher Curl	Sit on preacher bench placing back of arms on pad. Grasp curl bar with shoulder width overhand grip.	Raise bar until forearms are vertical. Lower barbell until arm is fully extended. Repeat.	Seat should be adjusted to allow arm pit to rest near top of pad. Back of upper arm should remain on pad.	{AUXILIARY}	{ISOLATED}	{PULL}	{BARBELL,BENCH,PREACHER}	f	f
Cable Hammer Curl	Grasp cable rope with palms facing inward. Stand upright with arms straight down to sides.	With elbows to side, raise rope forward and upward with both arms until forearms are vertical. Lower until arms are fully extended. Repeat.	When elbows are fully flexed, they can travel forward slightly, allowing forearms to be no more than vertical. This additional movement allows for relative release of tension in muscles between repetitions.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable Reverse Curl	Grasp cable bar with shoulder width overhand grip.	With elbows to side, raise bar until forearms are vertical. Lower until arms are fully extended. Repeat.	When elbows are fully flexed, they can travel forward, slightly allowing forearms to be no more than vertical. This additional movement allows for relative release of tension in muscles between repetitions.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable Bar Reverse Curl	Grasp cable bar with shoulder width overhand grip. Stand close to cable bar.	With elbows to side, raise bar until forearms are vertical. Lower until arms are fully extended. Repeat.	When elbows are fully flexed, they can travel slightly forward, allowing forearms to be no more than vertical. This additional movement allows for relative release of tension in muscles between repetitions. Platform can be placed in front of feet to rest cable bar in between sets. See exercise performed with platform.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable Reverse Preacher Curl	Sit on preacher bench placing back of arms on pad. Grasp cable bar with shoulder width overhand grip.	Raise cable bar toward shoulders. Lower cable bar until arm is fully extended. Repeat.	Seat should be adjusted to allow arm pit to rest near top of pad. Back of upper arm should remain on pad. At bottom position, weight stack in use should not make contact with remaining weight stack.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE,BENCH,PREACHER}	f	f
Cable Standing Reverse Preacher Curl	Stand behind preacher bench. Grasp cable bar with shoulder width overhand grip. Position back of arms on pad.	Raise cable bar toward shoulders. Lower cable bar until arm is fully extended. Repeat.	Feet can be staggered and bent slightly (if needed) to allow arm pit to rest near top of pad. Back of upper arm should remain on pad. At bottom position, weight stack in use should not make contact with remaining weight stack.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE,BENCH,PREACHER}	f	f
Barbell Wrist Curl	Sit and grasp bar with narrow to shoulder width underhand grip. Rest forearms on thighs with wrists just beyond knees.	Allow barbell to roll out of palms down to fingers. Raise barbell back up by gripping and pointing knuckles up as high as possible. Lower and repeat.	Keep elbows approximately wrist height to maintain resistance through full range of motion.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{BARBELL}	f	f
Lever Hammer Preacher Curl	Sit on curl machine placing back of arms on pad. Grasp lever handles and position grips with thumb side up. Align elbows at near same pivot point as fulcrum of lever.	Raise lever handles toward shoulders, maintaining palms in grip. Lower handles until arm is fully extended. Repeat.	Seat should be adjusted to allow arm pit to rest near top of pad. Back of upper arm should remain on pad. If machine has secondary lever, elbows can be positioned further away from primary fulcrum.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER,PREACHER}	f	f
Lever Reverse Curl	Sit on seat and grasp handles with overhand grip. Position elbows to sides so they are in line with lever's fulcrum.	Raise lever handles until elbows are fully flexed with back of upper arm remaining on pad. Lower handles until arm is fully extended. Repeat.	The biceps may be exercised alternating or simultaneous. If machine does not provide support for back of arm, keep elbows from traveling back, particularly during initial flexion.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Lever Reverse Preacher Curl	Sit on curl machine placing back of arms on pad. Grasp lever handles with overhand grip. Align elbows at near same pivot point as fulcrum of lever.	Raise lever handles toward shoulders. Lower handles until arm is fully extended. Repeat.	Seat should be adjusted to allow arm pit to rest near top of pad. Back of upper arm should remain on pad. If machine has secondary lever, elbows can be positioned further away from primary fulcrum.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER,PREACHER}	f	f
Cable Wrist Curl	Sit and grasp cable bar with narrow to shoulder width underhand grip. Rest forearms on thighs with wrists just beyond knees.	Allow cable bar to roll out of palms down to fingers. Raise cable bar back up by gripping and pointing knuckles up as high as possible. Lower and repeat.	None.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable One Arm Wrist Curl	Sit and grasp cable stirrup. Rest forearm on thigh with palm up and wrist just beyond knees.	Allow cable bar to roll out of palms down to fingers. Raise cable bar back up by gripping and pointing knuckles up as high as possible. Lower and repeat.	Hand may be placed under wrist (as demonstrated) to offer stability and to maintain horizontal orientation of forearm.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Dumbbell Radial Deviation	Grasp half loaded dumbbell with plate on thumb side. Position arm down to side.	Bend wrist so weighted side is pulled upward. Lower until weighted side is pointing downward. Repeat.	If half loaded dumbbell is not available, one of two substitutes can be used.	{AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL}	f	f
Lever Wrist Curl	Grasp bar with underhand grip to each side. Place forearms on arm pads.	Raise handles up until wrist is fully flexed. Lower handles until wrists are full hyperextended. Repeat.	Keep forearms horizontal, flat on arm pads throughout exercise. See wrist curl up close.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Barbell Reverse Wrist Curl	Sit and grasp bar with narrow to shoulder width overhand grip. Rest forearms on thighs with wrists just beyond knees.	Raise barbell by pointing knuckles upward as high as possible. Return until knuckles are pointing downward as far as possible. Repeat.	Keep elbows approximately wrist height to maintain resistance through full range of motion.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{BARBELL}	f	f
Cable Reverse Wrist Curl	Sit and grasp cable bar with narrow to shoulder width overhand grip. Rest forearms on thighs with wrists just beyond knees.	Raise stirrup by pointing knuckles upward as high as possible. Return until knuckles are pointing downward as far as possible. Repeat.	Do not allow elbows to rise.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable One Arm Reverse Wrist Curl	Sit and grasp cable stirrup. Rest forearm on thigh with palm facing down and with wrist just beyond knee.	Raise stirrup by pointing knuckles upward as high as possible. Return until knuckles are pointing downward as far as possible. Repeat.	Do not allow elbow to rise. Hand may be placed under wrist (as demonstrated) to offer stability and to maintain horizontal orientation of forearm.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Dumbbell Wrist Curl	Sit and grasp dumbbell with underhand grip. Rest forearm on thigh with wrist just beyond knee.	Allow dumbbell to roll out of palm down to fingers. Raise dumbbell back up by gripping and pointing knuckles up as high as possible. Lower and repeat.	Keep elbow approximately wrist height to maintain resistance through full range of motion. Hand may be placed under wrist to offer stability and to maintain horizontal orientation of forearm.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL}	f	f
Lever Seated Forearm Pronation	Sit on seat. Grasp rotating handles with underhand grip on each side and place forearms on pads.	Rotate shafts by turning palm downward. Return and repeat.	Depending on participant's range of motion and machine's design, handles may need to be prerotated so resistance is present throughout movement, particularly initial phase of rotation. See forearm pronation up close.	{AUXILIARY}	{ISOLATED}	{PUSH}	{LEVER}	f	f
Lever Reverse Wrist Curl	Grasp handles with overhand grip to each side. Place forearms on arm pads.	Raise handles until wrist is fully hyperextended. Lower handles until wrists are fully flexed. Repeat.	Keep forearms horizontal, flat on arm pads throughout exercise. See reverse wrist curl up close.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Dumbbell Seated Pronation	Sit next to elevated surface, approximately arm pit height. With hand of upper arm, grasp unilaterally loaded dumbbell; pinkie positioned near weighted side. Bend elbow approximately 90-degrees and place upperarm on elevated surface. Position thumb upward (supinated).	Rotate dumbbell so thumb turns downward (pronation). Return and repeat.	If unilaterally loaded dumbbell, or "half dumbbell" is not available, grasp conventional dumbbell to one side of handle with thumb against inside surface.	{AUXILIARY}	{ISOLATED}	{PUSH}	{DUMBBELL}	f	f
Dumbbell Lying Supination	Lie on bench or mat. With hand of upper arm, grasp unilaterally loaded dumbbell; thumb next to side with weight. Bend elbow approximately 90-degrees and place forearm on hip, or side of waist. Position thumb downward (pronated).	Rotate dumbbell so thumb turns upward (supination). Return and repeat.	Pad or firm pillow may be placed between hip and arm. Elevation of elbow allows resistance during final range of motion. If unilaterally loaded dumbbell, or "half dumbbell" is not available, grasp conventional dumbbell to one side of handle with pinkie against inside surface. Also see Dumbbell Lying Supination with arm down. This exercise can also be performed seated by corner of table higher than shoulder height (See Seated Supination).	{AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL,BENCH}	f	f
Lever Standing Forearm Pronation	Grasp open handle at end of shaft with underhand grip.	Rotate shaft by turning palm downward. Return and repeat.	Depending on participant's range of motion and machine's design, handle may need to be prerotated so resistance is present throughout movement, particularly initial phase of rotation.	{AUXILIARY}	{ISOLATED}	{PUSH}	{LEVER}	f	f
Barbell Seated Good-morning	Position barbell on back of shoulders and grasp bar to sides. Sit on end of bench or corner of box secured to floor. Position feet apart on floor with knees slightly bent.	Keeping back straight, bend torso forward as low as possible by bending hips. Raise torso until torso is upright. Repeat.	Begin with very light weight and add additional weight gradually to allow adequate adaptation. Throughout lift, keep back straight. Hamstrings will be emphasized if knees are straight.	{AUXILIARY}	{ISOLATED}	{PULL}	{BARBELL,BENCH}	f	f
Barbell Deadlift	With feet flat beneath bar, squat down and grasp bar with shoulder width or slightly wider overhand or mixed grip.	Lift bar by extending hips and knees to full extension. Pull shoulders back at top of lift if rounded. Return and repeat.	Target muscle is exercised isometrically. Throughout lift, keep hips low, shoulders high, arms and back straight. Knees should point same direction as feet throughout movement. Keep bar close to body to improve mechanical lev erage. Grip strength and strength endurance often limit ability to perform multiple reps at heavy resistances. Gym chalk, wrist straps, grip work, and mixed grip can be used to enhance grip. Mixed grip indicates one hand holding with overhand grip and other hand holding with underhand grip. Lever barbell jack can be used to lift barbell from floor for easier loading and unload of weight plates.	{BASIC}	{COMPOUND}	{PULL}	{BARBELL}	f	f
Lever Seated Forearm Supination	Sit on seat. Grasp rotating handles with overhand grip on each side and place forearms on pads.	Rotate shafts by turning palm upward. Return and repeat.	Depending on participant's range of motion and machine's design, handles may need to be prerotated so resistance is present throughout movement, particularly initial phase of rotation. See forearm supination up close.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Lever Standing Forearm Supination	Grasp open handle at end of shaft with overhand grip.	Rotate shaft by turning palm upward. Return and repeat.	Depending on participant's range of motion and machine's design, handle may need to be prerotated so resistance is present throughout movement, particularly initial phase of rotation.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Barbell Sumo Deadlift	Position feet under bar with very wide stance. Squat down and grasp bar between legs with shoulder width mixed grip. Face forward while positioning shoulders upward with arms straight, chest high, hips low, and back straight.	Pull bar up by driving feet outward while pulling chest up. Extend knees when bar passes knees. At top of lift, when torso is upright, drive shoulders back and chest up. Return weight to floor by bending hips back and knees pointed outward, while keeping chest high and back straight. Repeat.	Target muscle is exercised isometrically. Heavy barbell deadlifts significantly engages Latissmus Dorsi.	{BASIC}	{COMPOUND}	{PULL}	{BARBELL}	f	f
Barbell Hip Thrust	Sit on floor with long side of bench behind back. Roll barbell back and center over hips. Position upper back on corner of bench. Place feet on floor approximately shoulder width with knees bent. Grasp bar to each side.	Raise bar upward by extending hips until straight. Lower and repeat.	Use bench of lower height 16" to 18" (40 to 46 cm) allowing torso to be angled approximately 45º. Bench may need to be secured so it does not slide on floor.	{AUXILIARY}	{ISOLATED}	{PUSH}	{BARBELL,BENCH}	f	f
Barbell Lunge	Clean bar from floor or dismount bar from rack. From rack with barbell upper chest height, position bar on back of shoulders and grasp barbell to sides.	Lunge forward with first leg. Land on heel, then forefoot. Lower body by flexing knee and hip of front leg until knee of rear leg is almost in contact with floor. Return to original standing position by forcibly extending hip and knee of forward leg. Repeat by alternating lunge with opposite leg.	Keep torso upright during lunge; flexible hip flexors are important. Lead knee should point same direction as foot throughout lunge. A long lunge emphasizes Gluteus Maximus; short lunge emphasizes Quadriceps.	{AUXILIARY}	{COMPOUND}	{PUSH}	{BARBELL}	f	f
Barbell Alternating Lunge To Rear Lunge	Stand facing rack with barbell at upper chest height and short platform behind. Position bar on back of shoulders and grasp barbell to sides. Dismount bar from rack and step back. Stand with feet slightly narrower than shoulder width apart.	Lunge forward with right leg. Land on heel, then forefoot. Lower body by flexing knee and hip of right front leg until knee of rear left leg is almost in contact with floor. Forcibly extending hip and knee of forward right leg to return to upright position. Instead of returning right foot to side of left foot, instead continue to step back with right leg while bending supporting left leg. Plant right forefoot far back on floor. Lower body by flexing knee and hip of supporting left leg until knee of rear right leg is almost in contact with floor. Return to standing position by extending hip and knee of supporting left leg and return rear right leg next to supporting leg. Repeat movement with opposite legs alternating between sides.	Keep torso upright throughout exercise. Flexible hip flexors are important. Lead knee should point same direction as foot throughout lunge. A long lunge emphasizes Gluteus Maximus; short lunge emphasizes Quadriceps. Movement combines Lunge and Rear Lunge.	{AUXILIARY}	{COMPOUND}	{PUSH}	{BARBELL}	f	f
Barbell Rear Lunge	From rack with barbell upper chest height, position bar on back of shoulders and grasp barbell to sides. Dismount bar from rack.	Step back with one leg while bending supporting leg. Plant forefoot far back on floor. Lower body by flexing knee and hip of supporting leg until knee of rear leg is almost in contact with floor. Return to original standing position by extending hip and knee of forward supporting leg and return rear leg next to supporting leg. Repeat movement with opposite legs alternating between sides.	Keep torso upright during lunge; flexible hip flexors are important. Forward knee should point same direction as foot throughout lunge. A long lunge emphasizes Gluteus Maximus; short lunge emphasizes Quadriceps.	{AUXILIARY}	{COMPOUND}	{PUSH}	{BARBELL}	f	f
Barbell Side Lunge	Clean bar from floor or dismount bar from rack. From rack with barbell upper chest height, position bar on back of shoulders and grasp barbell to sides.	Lunge to one side with first leg. Land on heel, then forefoot. Lower body by flexing knee and hip of lead leg, keeping knee pointed same direction of foot. Return to original standing position by forcibly extending hip and knee of lead leg. Repeat by alternating lunge with opposite leg.	Keep torso upright during lunge. Lead knee should point same direction as foot throughout lunge. Flexible hip adductors will allow fuller range of motion. A long lunge emphasizes Gluteus Maximus; short lunge emphasizes Quadriceps.	{AUXILIARY}	{COMPOUND}	{PUSH}	{BARBELL}	f	f
Barbell Walking Lunge	Position barbell on back of shoulders and grasp bar to sides.	Step forward with first leg. Land on heel, then forefoot. Lower body by flexing knee and hip of front leg until knee of rear leg is almost in contact with floor. Stand on forward leg with assistance of rear leg. Lunge forward with opposite leg. Repeat by alternating lunge with opposite legs.	Keep torso upright during lunge; flexible hip flexors are important. Lead knee should point same direction as foot throughout lunge. A long lunge emphasizes Gluteus Maximus; short lunge emphasizes Quadriceps. Tibilalis Anterior is exercised eccentrically during landing on heel.	{AUXILIARY}	{COMPOUND}	{PUSH}	{BARBELL}	f	f
Barbell Single Leg Split Squat	Stand facing away from bench. Position bar on back of shoulders and grasp barbell to sides. Extend leg back and place top of foot on bench.	Squat down by flexing knee and hip of front leg until knee of rear leg is almost in contact with floor. Return to original standing position by extending hip and knee of forward leg. Repeat. Continue with opposite leg.	Keep torso upright during squat; flexible hip flexors are important. Forward knee should point same direction as foot throughout movement. Also see Bulgarian Squat.	{AUXILIARY}	{COMPOUND}	{PUSH}	{BARBELL,BENCH}	f	f
Barbell Side Split Squat	Place barbell on back of shoulders and grasp bar on each side. Stand with feet wide apart; foot of lead leg angled out to side.	Lower body toward side of angled foot by bending knee and hip of lead leg while keeping opposite leg only slightly bent. Return to original standing position by extending hip and knee of lead leg. Repeat.	Keep torso upright and knee of lead leg pointed same direction of foot. Flexible hip adductors and stronger legs will allow fuller range of motion. A wider stance emphasizes Gluteus Maximus; slightly narrower straddled stance emphasizes Quadriceps. Do not position feet too close nor too wide.	{AUXILIARY}	{COMPOUND}	{PUSH}	{BARBELL}	f	f
Barbell Single Leg Squat	Stand with arms extended out in front holding barbell. Balance on one leg with opposite leg extended forward off of ground.	Squat down as far as possible while keeping leg elevated off of floor. Keep supporting knee pointed same direction as foot supporting. Raise body back up to original position until knee and hip of supporting leg is straight. Return and repeat. Continue with opposite leg.	Supporting knee should point same direction as foot throughout movement. Range of motion will be improved with greater leg strength and glute flexibility. Significant spinal flexion occurs at bottom of deep single leg squat to maintain center of gravity over foot. Erector Spinae becomes a stabilizer if spine is kept straight.	{AUXILIARY}	{COMPOUND}	{PUSH}	{BARBELL}	f	f
Barbell Split Squat	Position barbell on back of shoulders and grasp barbell to sides. Stand with feet far apart; one foot forward and other foot behind.	Squat down by flexing knee and hip of front leg. Allow heel of rear foot to rise up while knee of rear leg bends slightly until it almost makes contact with floor. Return to original standing position by extending hip and knee of forward leg. Repeat. Continue with opposite leg.	Knees should point same direction as feet throughout movement. Heel of rear foot can be kept elevated off floor throughout movement. Keep torso upright during squat; flexible hip flexors are important. With feet further apart: Gluteus Maximus is emphasized, Quadriceps are less emphasized.	{AUXILIARY}	{COMPOUND}	{PUSH}	{BARBELL}	f	f
Barbell Front Squat	From rack with barbell upper chest height, position bar in front of shoulders. Cross arms and place hands on top of barbell with upper arms parallel to floor. Dismount bar from rack.	Squat down by bending hips back while allowing knees to bend forward, keeping back straight and knees pointed same direction as feet. Descend until thighs are just past parallel. Extend knees and hips until legs are straight. Return and repeat.	Keep head facing forward, back straight and feet flat on floor; equal distribution of weight through forefoot and heel. Knees should point same direction as feet throughout movement. See Squat Analysis. Also see weightlifting style Front Squat.	{AUXILIARY}	{COMPOUND}	{PUSH}	{BARBELL}	f	f
Barbell Full Squat	From rack with barbell upper chest height, position barbell on back of shoulders and grasp bar to sides. Dismount bar from rack.	Squat down by bending hips back while allowing knees to bend forward, keeping back straight and knees pointed same direction as feet. Descend until knees and hips are fully bent. Extend knees and hips until legs are straight. Return and repeat.	Keep head facing forward, back straight and feet flat on floor; equal distribution of weight through forefoot and heel. Knees should point same direction as feet throughout movement. Hip and ankle flexibility is important for both execution and safety in this movement. Certain knee and low back problems may be aggravated by this exercise. See Squat Mount and Dismount. See Squat Analysis. See spotting technique and spotting assistance.	{BASIC}	{COMPOUND}	{PUSH}	{BARBELL}	f	f
Trap Bar Squat	Stand on platform under loaded trap bar. Squat down until thighs are just past parallel to floor with knees pointed same direction as feet and feet flat on platform. Grasp handles to sides. Posture chest up with back arched tightly.	Lift weight upward by extending knees and hips until straight. Pull shoulders back at top of lift if rounded. Return weights to floor by bending hips back while allowing knees to bend forward. Repeat.	An inverted, squared open-ended trap bar is used in this demonstration. Keep head facing forward, back straight and feet flat on floor; equal distribution of weight through forefoot and heel. Knees should point same direction as feet throughout movement. See Squat Analysis.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{TRAP_BAR}	f	f
Trap Bar Deadlift	Stand with feet shoulder width or narrower in trap bar, weight to each side. Squat down with feet flat, low back taut. Grasp handles to sides.	Lift bar by extending hips and knees to full extension. Pull shoulders back at top of lift if rounded. Return and repeat.	Target muscle is exercised isometrically . Throughout lift, keep hips low, shoulders high, arms and back straight.	{BASIC}	{COMPOUND}	{PULL}	{TRAP_BAR}	f	f
Cable Glute Kickback	Attach ankle cuff to low pulley. With cuff on one ankle, grasp ballet bar with both hands and step far back with other foot. Arms remain extended to support body leaning forward. Leg with ankle cuff attached is flexed at hip and knee.	Pull cable attachment back by extending hip and knee. Return leg to original position and repeat. Continue with opposite leg.	Spinal stabilization through the sagittal plane is not significant as it is in Cable Standing Hip Extension with body upright, since torque through spine is negligible due to direction force vector (as indicated by orientation of cable) being nearly parallel to spine even at terminal extension. Although Rectus Abdominis roll as Antagonist Stabilizer is involved to significantly lesser degree since it does not need to counter Erector Spinae sagittal spinal stabilization, Erector Spinae is still involved as stabilizer of spine through transverse plane along with Obliques and Quadratus lumborum to support unilateral loading.	{AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE}	f	f
Cable Rear Lunge	Stand between two very low pulleys with shoulder width or narrower stance. Squat down and grasp stirrup attachments to each side. Stand upright with arms straight down to sides.	Step back with one leg while bending supporting leg. Plant forefoot far back on floor. Lower body by flexing knee and hip of supporting leg until knee of rear leg is almost in contact with floor. Return to original standing position by extending hip and knee of forward supporting leg and return rear leg next to supporting leg. Repeat movement with opposite legs alternating between sides.	Keep torso upright during lunge; flexible hip flexors are important. Forward knee should point same direction as foot throughout movement. A long lunge emphasizes Gluteus Maximus; short lunge emphasizes Quadriceps. See Cable Rear Step-down Lunge for similar exercise.	{AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE}	f	f
Cable Rear Step-down Lunge	Stand on upper platform with stirrups grasped to sides.	Extend one leg back on forefoot. Lower body on other leg by flexing knee and hip of front leg until knee of rear leg is almost in contact with lower platform. Return to original standing position by extending hip and knee of forward leg. Repeat by alternating rear lunge with opposite leg.	Keep torso upright during lunge; flexible hip flexors are important. Forward knee should point same direction as foot throughout movement. A long lunge emphasizes Gluteus Maximus; short lunge emphasizes Quadriceps. See Cable Rear Lunge for similar exercise.	{AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE}	f	f
Cable Single Leg Split Squat	Facing away from bench, stand between two very low pulleys with shoulder width or narrower stance. Squat down and grasp stirrup attachments to each side. Stand upright with arms straight down to sides. Extend leg back and place top of foot on bench.	Squat down by flexing knee and hip of front leg until knee of rear leg is almost in contact with floor. Return to original standing position by extending hip and knee of forward leg. Repeat. Continue with opposite leg.	Keep torso upright during squat; flexible hip flexors are important. Forward knee should point same direction as foot throughout movement. May also be referred to as Cable Bulgarian Squat.	{AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE,BENCH}	f	f
Cable One Arm Single Leg Split Squat	Stand between bench and low pulley cable. Grasp cable stirrup with one hand. Facing low pulley, extend leg back and place top of foot or forefoot on bench. Place other hand on hip or support to side.	Squat down by flexing knee and hip of front leg until knee of rear leg is almost in contact with floor. Return to original standing position by extending hip and knee of forward leg. Repeat. Continue with opposite leg.	Keep torso upright during squat; flexible hip flexors are important. Forward knee should point same direction as foot throughout movement. May also be referred to as Cable One Arm Bulgarian Squat.	{AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE,BENCH}	f	f
Cable Split Squat	Stand between two very low cable pulleys. Grasp stirrup attachments with each hand. Place one leg forward and opposite leg back to rear.	Squat down by flexing knee and hip of front leg. Allow heel of rear foot to rise up while knee of rear leg bends slightly until it almost makes contact with floor. Return to original straddle position by extending hip and knee of forward leg. Repeat. Continue with legs in opposite position.	Knees should point same direction as feet throughout movement. Heel of rear foot can be kept elevated off floor throughout movement as shown. Keep torso upright during squat; flexible hip flexors are important. With feet further apart: Gluteus Maximus is emphasized, Quadriceps are less emphasized. Also known as Cable Lunge.	{AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE}	f	f
Cable One Arm Split Squat	Face low pulley and grasp stirrup attachment with one hand. Stand away from pulley with one leg forward and opposite leg to rear. Place other hand on hip or on support to side.	Squat down by flexing knee and hip of front leg. Allow heel of rear foot to rise up while knee of rear leg bends slightly until it almost makes contact with floor. Return to original straddle position by extending hip and knee of forward leg. Repeat. Continue with legs in opposite position.	Knees should point same direction as feet throughout movement. Heel of rear foot can be kept elevated off floor throughout movement as shown. Keep torso upright during squat; flexible hip flexors are important. With feet further apart: Gluteus Maximus is emphasized, Quadriceps are less emphasized. Also known as Cable One Arm Lunge.	{AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE}	f	f
Cable Squat	Stand with feet shoulder width or slightly wider on platform between very low and close pulley cables. Squat down with knees slightly beyond foot, hips bent back behind, back straight, knees pointed same direction as feet, and shoulder above feet. Grasp stirrups to each side with arms straight.	Keeping chest high and back straight, raise stirrups by extending knees and hips until legs are straight. Squat down by bending hips back while allowing knees to bend forward, keeping back straight and knees pointed same direction as feet. Squat down until thighs are just past parallel to floor. Return and repeat.	Keep head facing forward, back straight, chest high, arms straight to sides, and feet flat on platform; equal distribution of weight through forefoot and heel. Knees should point same direction as feet throughout movement. See Cable Squat on model with higher platform. Also see Squat Analysis.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE}	f	f
Cable Bar Squat	Adjust cable pulleys to medium low positions. Kneel under attached cable bar while supporting it with both hands. Position body in lower squat position with cable bar on top of shoulders, both feet flat on floor with mid feet in line with both pulleys, knees positioned same direction as feet, back straight and angled forward, and hands grasping bar to each side.	Stand up by extending hips and knees until legs are straight. Squat back down to original squat position by bending hips back and knees forward while keeping back straight and knees pointed same direction as feet. Descend until thighs are just past parallel to floor. Return and repeat.	Position height of cable bar so moving weight plates makes contact with unused weight stack at bottom of squat when hips are slightly lower or same height as knees. Keep head facing forward, back straight and feet flat on floor; equal distribution of weight through forefoot and heel. Knees should point same direction as feet throughout movement. See Squat Analysis. Also see Cable Squat.	{BASIC}	{COMPOUND}	{PUSH}	{CABLE}	f	f
Cable Belt Squat	Place pin on lightest weight. Place belt around waist. Pull cable from pulley and attach to front of belt. Step onto platform and grasp pole. Squat or sit on platform and select desired weight. Stand with feet shoulder width or wider to each side of cable. Place both hands on pole at waist height.	Squat down by bending hips back while allowing knees to bend forward, keeping back straight and knees pointed same direction as feet. Descend until thighs are just past parallel to floor. Squat up by extending knees and hips until legs are straight. Return and repeat.	Keep head facing forward, back straight, chest high, and feet flat on surface; equal distribution of weight through forefoot and heel. Knees should point same direction as feet throughout movement. When finished, squat or sit and place pin into lightest weight setting. Step off of platform and unclip cable from belt. Also known as Pole Squat. Instead of holding onto pole for balance (as shown), arms can be extended forward without contact with pole. It may be difficult to achieve full range of motion when attempting this movement over a standard low pulley. Also see similar exercise: Weighted Belt Squat. See Squat Analysis.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE}	f	f
Cable Standing Hip Extension	Attach ankle cuff to low pulley. With cuff on one ankle, grasp ballet bar with both hands and step back with other foot. Elbows remain straight. Attached leg is straight and foot is slightly off floor.	Pull cable attachment back by extending hip. Return leg to original position. Repeat. Continue with opposite leg.	Also see Cable Bent-over Hip Extension for more bent over posture.	{AUXILIARY}	{ISOLATED}	{PUSH}	{CABLE}	f	f
Cable Bent-over Hip Extension	Attach ankle cuff to low pulley. With cuff on one ankle, grasp ballet bar with both hands and step far back with other foot. Arms remain extended to support body leaning forward. Leg with ankle cuff attached in slightly bent with foot off floor.	Pull cable attachment back by extending hip. Return leg to original position and repeat. Continue with opposite leg.	Spinal stabilization through the sagittal plane is not significant as it is in Cable Standing Hip Extension with body upright, since torque through spine is negligible due to direction force vector (as indicated by orientation of cable) being nearly parallel to spine even at terminal extension. Although Rectus Abdominis roll as Antagonist Stabilizer is involved to significantly lesser degree since it does not need to counter Erector Spinae sagittal spinal stabilization, Erector Spinae is still involved as stabilizer of spine through transverse plane along with Obliques and Quadratus lumborum to support unilateral loading.	{AUXILIARY}	{ISOLATED}	{PUSH}	{CABLE}	f	f
Cable Step-up	Stand behind elevated platform and low and close pulley cables to sides. Grasp stirrups at each side of platform. Stand upright with arms straight down at sides.	Place foot of first leg on elevated platform. Stand on elevated platform by extending hip and knee of first leg and place foot of second leg on bench. Step down with second leg by flexing hip and knee of first leg. Return to original standing position by placing foot of first leg to lower position. Repeat first step with opposite leg, alternating first steps between legs.	Keep torso upright during exercise. Lead knee should point same direction as foot throughout movement. Stepping distance from bench emphasizes Gluteus Maximus; stepping close to bench emphasizes Quadriceps.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE,BENCH}	f	f
Dumbbell Walking Lunge	Stand with dumbbells grasped to sides.	Step forward with first leg. Land on heel, then forefoot. Lower body by flexing knee and hip of front leg until knee of rear leg is almost in contact with floor. Stand on forward leg with assistance of rear leg. Lunge forward with opposite leg. Repeat by alternating lunge with opposite legs.	Keep torso upright during lunge; flexible hip flexors are important. Lead knee should point same direction as foot throughout lunge. A long lunge emphasizes Gluteus Maximus; short lunge emphasizes Quadriceps. Tibialis Anterior is exercised eccentrically during landing on heel.	{AUXILIARY}	{COMPOUND}	{PUSH}	{DUMBBELL}	f	f
Dumbbell Single Leg Split Squat	Stand with dumbbells grasped to sides facing away from bench. Extend leg back and place top of foot on bench.	Squat down by flexing knee and hip of front leg until knee of rear leg is almost in contact with floor. Return to original standing position by extending hip and knee of forward leg and repeat. Continue with opposite leg.	Keep torso upright during squat; flexible hip flexors are important. Forward knee should point same direction as foot throughout movement. May also be referred to as Dumbbell Bulgarian Squat.	{AUXILIARY}	{COMPOUND}	{PUSH}	{DUMBBELL,BENCH}	f	f
Dumbbell Single Leg Squat	Stand with dumbbells grasped to sides. Balance on one leg with opposite leg extended forward off of ground.	Squat down as far as possible while keeping leg elevated off of floor. Keep supporting knee pointed same direction as foot supporting. Raise body back up to original position until knee and hip of supporting leg is straight. Return and repeat. Continue with opposite leg.	Supporting knee should point same direction as foot throughout movement. Range of motion will be improved with greater leg strength and glute flexibility. Significant spinal flexion occurs at bottom of deep single leg squat to maintain center of gravity over foot. Erector Spinae becomes a stabilizer if spine is kept straight.	{AUXILIARY}	{COMPOUND}	{PUSH}	{DUMBBELL}	f	f
Dumbbell Squat	Stand with dumbbells grasped to sides.	Squat down by bending hips back while allowing knees to bend forward, keeping back straight and knees pointed same direction as feet. Descend until thighs are just past parallel to floor. Extend knees and hips until legs are straight. Return and repeat.	Keep head facing forward, back straight, chest high, arms straight to sides, and feet flat on floor; equal distribution of weight through forefoot and heel. Knees should point same direction as feet throughout movement. See Squat Analysis.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{DUMBBELL}	f	f
Dumbbell Front Squat	Stand with dumbbells grasped to sides. Clean dumbbells up to shoulders so side of each dumbbell rests on top of each shoulder. Balance dumbbells on shoulder by holding on to dumbbells with elbows flaring outward. Position feet shoulder width or slightly narrower apart.	Squat down by bending hips back while allowing knees to bend forward, keeping back straight and knees pointed same direction as feet. Descend until thighs are just past parallel to floor. Extend knees and hips until legs are straight. Return and repeat.	Keep head facing forward, back straight, chest high, and feet flat on floor; equal distribution of weight through forefoot and heel. Knees should point same direction as feet throughout movement. See Squat Analysis. Also see Kettlebell Front Squat.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{DUMBBELL,KETTLEBELL}	f	f
Lever Hip Thrust	Lie on apperatuse with knees bent and feet on foot platform shoulder width or slightly narrower apart. Position hips just below padded bar or adjustable belt. Lock padded bar or tighten adjustable belt snuggly above hips.	Raise weight upward by extending hips until straight. Lower and repeat.	Use resistance which allows full hip extension.	{AUXILIARY}	{ISOLATED}	{PUSH}	{LEVER}	f	f
Lever Single Leg 45° Leg Press	Sit on machine with back on padded support. Place one foot mid height to low on platform. Place outside of resting foot on lower surface with knee positioned out for greater clearance. Push platform up by extending hip and knee. Release dock lever and grasp handles to sides.	Lower platform by bending leg until knee is just short of complete flexion. Return by extending knee and hip. Repeat. Continue with opposite leg.	Lower platform enough to achieve full range of motion without forcing pelvis to bend at waist. On exercised leg, keep pointed same direction as foot . Also, do not allow heel to raise off of platform, pushing with both heel and forefoot. For alternative view, see Lever Single Leg 45° Leg Press performed with opposite leg.	{AUXILIARY}	{COMPOUND}	{PUSH}	{LEVER}	f	f
Lever Lying Hip Extension	With leg lever positioned in the lower position, lie supine on machine with legs over padded bar. Align hip joints with lever fulcrum. Strap hips down with belt if available. Release leg lever and adjust until leg lever is in upper position. Grasp handles to sides of head.	Push padded leg bar down until hips are extended. Return and repeat.	Also Lever Lying Hip Extension on plate loaded machine and Lever Alternating Lying Hip Extension on another selectorized machine.	{AUXILIARY}	{ISOLATED}	{PUSH}	{LEVER}	f	f
Lever Front Squat	Step onto platform facing padded levers. Squat down to place shoulders under padded lever. Place feet shoulder width apart on platform. Extend knees and hips until legs are straight. Release support lever if it does not disengage by itself.	Lower lever by bending hips back while allowing knees to bend forward slightly, keeping back straight and knees pointed same direction as feet. Descend until thighs are just past parallel to floor. Lift lever up by extending knees and hips until legs are straight. Repeat.	If available, re-engage support lever in extended position before dismounting. Model shown uses foot pedal near base of platform to reengage support lever. Keep head facing forward, back straight and feet flat on platform; equal distribution of weight through forefoot and heel. Knees should point same direction as feet throughout movement. See Squat Analysis.	{BASIC}	{COMPOUND}	{PUSH}	{LEVER}	f	f
Lever Alternating Lying Hip Extension	Lie on bench with knees legs over pads. Align hip joints with lever fulcrum. Strap hips down with belt. Extend both hips with feet toward floor.	Raise one knee by flexing hip. Return to original position by extending hip. Repeat with opposite leg, alternating between sides.	Hamstring remains in active insufficiency through movement since knee is significantly flexed and hip does not flex beyond 90 degrees. Also see Lever Lying Hip Extension on plate loaded machine.	{AUXILIARY}	{ISOLATED}	{PUSH}	{LEVER,BENCH}	f	f
Lever Standing Hip Extension	Stand on platform facing to one side and grasp bar for support. Place leg nearest machine on padded roller while standing on other leg.	Lower lever by extending hip. Return until knee is higher than hip. Repeat. Continue with opposite leg.	[]	{AUXILIARY}	{ISOLATED}	{PUSH}	{LEVER}	f	f
Lever Kneeling Hip Extension	Kneel on lowest (shin) pad with roller pad behind lower thighs. Position midsection on middle pad. Place forearms on padded arm rest and grip handles.	Keeping one leg on shin pad, extend hip of other leg and push roller pad back. Raise roller pad up until hip is completely extended. Return leg to original position and repeat. Continue with opposite leg.	Exercise can be performed alternating between sides.	{AUXILIARY}	{ISOLATED}	{PUSH}	{LEVER}	f	f
Lever Alternating Kneeling Hip Extension	Kneel on lowest (shin) pad with roller pad behind lower thighs. Position midsection on middle pad. Place forearms on padded arm rest and grip handles.	Keeping one leg on shin pad, extending hip of other leg and push roller pad back. Raise roller pad up until hip is completely extended. Return leg to original position. Repeat with opposite leg. Continue alternating between each side.	Exercise can be performed with one leg, then other leg. See Lever Kneeling Hip Extension (roller pad).	{AUXILIARY}	{ISOLATED}	{PUSH}	{LEVER}	f	f
Lever Bent-over Glute Kickback	Lean over padded surface and grasp handles. Bend knee and position foot against lever platform or pedal.	Push platform or pedal back by extending leg. Return leg to original position. Repeat. Continue with opposite leg.	[]	{AUXILIARY}	{COMPOUND}	{PUSH}	{LEVER}	f	f
Lever Standing Glute Kickback	Step on left platform with left foot. Grasp handle bars to each side. Place right foot on highest lever platform.	Push platform down by extending leg until straight. Return leg to original position. Repeat. Continue with opposite leg positions.	With greater resistances, more effort is required to pull on handle bars to keep body from rising upward.	{AUXILIARY}	{COMPOUND}	{PUSH}	{LEVER}	f	f
Lever Squat	Squat down to place shoulders under padded lever. Place feet shoulder width apart directly under shoulders.	Lift lever up by extending knees and hips until legs are straight. Lower lever by bending hips back while allowing knees to bend forward, keeping back straight and knees pointed same direction as feet. Descend until thighs are just past parallel to floor. Return and repeat.	Lever height should be adjusted to accommodate full range, allowing hips to descend same height or slightly lower than knees. Keep head facing forward, back straight and feet flat on floor; equal distribution of weight through forefoot and heel. Knees should point same direction as feet throughout movement. See Squat Analysis.	{BASIC}	{COMPOUND}	{PUSH}	{LEVER}	f	f
Sled Hack Press	Sit on sled with back of hips against back pad. Place feet on platform shoulder width or slightly wider. Extend hips and knees. Release dock lever(s).	Lower sled by flexing hips and knees until either is near complete flexion. Raise sled by extending knees and hips. Repeat.	Re-engage support lever in extended position before dismounting. If insufficient hip flexibility forces pelvis to pull away from back pad at lower portions of movement, only lower sled just short of spinal articulation. Keep knees pointed same directions as feet. Do not allow heels to raise off of platform, pushing with both heel and forefoot. Placing feet slightly high on platform emphasizes Gluteus Maximus. Placing feet slightly lower on platform emphasizes Quadriceps.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{LEVER,SLED}	f	f
Lever V-Squat	Position shoulders under shoulder pads with back against back pad. Place feet on platform, shoulder or hip width apart. Squeeze hand lever. Keeping hand lever squeezed, squat down by bending hips and knees until knees or hips are just short of complete flexion. Release hand lever and raise up on sled just slightly until weight stack is engaged (click is heard).	Raise sled by extending knees and hips until legs are straight. Squat down with knees pointed same direction as feet. Descend until knees or hips are near complete flexion. Repeat.	Squeeze hand lever at bottom of movement to disengage weight stack. Keep hand lever squeezed until sled is raised and legs are straight. If insufficient, hip flexibility forces pelvis to pull away from back pad at lower portions of movement, only lower sled just short of spinal articulation. Keep knees pointed same directions as feet. Do not allow heels to raise off of platform, pushing with both heel and forefoot. Placing feet slightly forward on platform emphasizes Gluteus Maximus. Placing feet slightly back on platform emphasizes Quadriceps.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{LEVER,SLED}	f	f
Lever Alternating Lying Leg Press	Lie on machine with shoulder under pads. Place feet on individual lever platforms. Grasp handles to sides. Push both lever platforms away by extending knees and hips so knees are straight.	Lower one lever platform toward body by bending knee and hip until weight taps or nearly taps unused portion of weight stack. Push lever platform away by extending knee and hip. Repeat with opposite leg. Continue by alternating between sides.	Adjust bench to accommodate near full range of motion without forcing hips to bend at waist. Keep knees pointed same directions as feet. Do not allow heels to raise off of platform, pushing with both heel and forefoot. This exercise may be performed by alternating (as described), simultaneous, or in simultaneous-alternating fashion.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{LEVER,BENCH}	f	f
Lever Seated Leg Press	Sit on machine with back on padded support. Place feet on platform. Grasp handles to sides.	Push platform away by extending knees and hips. Return and repeat.	Adjust seat and back support to accommodate near full range of motion without forcing hips to bend at waist. Keep knees pointed same directions as feet. Do not allow heels to raise off of platform, pushing with both heel and forefoot. Placing feet slightly high on platform emphasizes Gluteus Maximus. Placing feet slightly lower on platform emphasizes Quadriceps.	{BASIC}	{COMPOUND}	{PUSH}	{LEVER}	f	f
Lever Single Leg Seated Leg Press	Sit on machine with back on padded support. Place one foot slightly low on platform and other foot on floor below platform.	Push platform away by extending hip and knee. Return by bending leg until knee or hip is just short of complete flexion. Repeat. Continue with opposite leg.	Adjust back support back to accommodate near full range of motion without forcing pelvis to bend at waist. Keep knee pointed same direction as foot. Push with both heel and forefoot and do not allow heel to raise off of platform.	{AUXILIARY}	{COMPOUND}	{PUSH}	{LEVER}	f	f
Lever Kneeling Glute Kickback	Kneel on machine by placing one knee on lower pad. Rest torso on middle pad, place forearms on padded arm rest, and grip handles. Position other foot of other leg up to lever platform.	Push platform back by extending leg back. Return leg to original position and repeat. Continue with opposite leg.	[]	{AUXILIARY}	{COMPOUND}	{PUSH}	{LEVER}	f	f
Lever Split V-Squat	Position shoulders under shoulder pads with back against back pad. Place feet on platform, shoulder or hip width apart, slightly back. Squeeze hand lever. Keeping hand lever squeezed, squat down by bending hips and knees until knees or hips are just short of complete flexion. Release hand lever and raise up on sled just slightly until weight stack is engaged (click is heard). Raise sled by extending knees and hips until legs are straight. Place one leg back behind platform with toes pointed downward over floor.	Squat down with knee pointed same direction as foot. Allow leg to bend behind with forefoot on floor. Descend until forward hip is near complete flexion. Raise sled by extending knee and hip until leg is straight. Repeat. Continue with opposite leg.	Squeeze hand lever at bottom of movement to disengage weight stack. Keep hand lever squeezed until sled is raised and leg is straight. If insufficient hip flexibility forces pelvis to pull away from back pad at lower portions of movement, only lower sled just short of spinal articulation. Keep knee pointed same directions as foot. Do not allow heel to raise off of platform, pushing with both heel and forefoot. Placing feet slightly forward on platform emphasizes Gluteus Maximus. Placing feet slightly back on platform emphasizes Quadriceps. See manufacturer's suggested foot placement for Lever Split V-Squat.	{AUXILIARY}	{COMPOUND}	{PUSH}	{LEVER,SLED}	f	f
Lever Single Leg Split V-Squat	Position shoulders under shoulder pads with back against back pad. Place one foot slightly forward on platform. Place other foot against rear vertical platform. Squeeze hand lever. Keeping hand lever squeezed, squat down by bending hips and knees until hip or knee is short of complete flexion. Release hand lever and raise up on sled, just slightly until weight stack is engaged (click is heard).	Raise lever by extending knees and hips. Lower lever by flexing hips and knees until knee of rear leg is almost in contact with floor. Repeat. Continue with opposite leg positions.	Squeeze hand lever at bottom of movement to disengage weight stack. Keep hand lever squeezed until sled is raised and legs are straight. Keep knees pointed same directions as feet. Do not allow forward heel to raise off of platform, pushing with both heel and forefoot.	{AUXILIARY}	{COMPOUND}	{PUSH}	{LEVER,SLED}	f	f
Lever Alternating Single Leg Split V-Squat	Position shoulders under shoulder pads with back against back pad. Place feet slightly forward on platform. Squeeze hand lever. Keeping hand lever squeezed, squat down by bending hips and knees until hip or knee is short of complete flexion. Release hand lever and raise up on sled just slightly until weight stack is engaged (click is heard). Raise lever by extending knees and hips.	Transfer right foot back to inside of rear vertical platform. Lower lever by flexing hips and knees until knee of rear leg is almost in contact with floor. Raise lever by extending knees and hips until knee is straight. Return right foot to original position by other foot. Repeat with opposite leg movement and continue alternating between sides.	When finished, keep both feet forward and descend lever downward. Squeeze hand lever at bottom of movement to disengage weight stack. Keep hand lever squeezed until sled is raised and legs are straight. Keep knees pointed same directions as feet. Push with both heel and forefoot. Do not allow forward heel to raise off of platform.	{AUXILIARY}	{COMPOUND}	{PUSH}	{LEVER,SLED}	f	f
Sled Alternating 45° Leg Press	Sit on machine with back on padded support. Place feet on individual platforms. Grasp handles to sides. Push both platforms away by extending knees and hips so knees are straight. Release dock lever and grasp handles to sides.	Lower one platform toward body by bending knee and hip until knees are just short of complete flexion or until hips are completely flexed. Push platform away by extending knee and hip. Repeat with opposite leg. Continue by alternating between sides.	Adjust safety brace and back support to accommodate near full range of motion without forcing hips to bend at waist. Wide stance may allow for deeper range of motion. Keep knees pointed same directions as feet. Do not allow heels to raise off of platform, pushing with both heel and forefoot. Placing feet slightly high on platform emphasizes Gluteus Maximus. Placing feet slightly lower on platform emphasizes Quadriceps. See exercises performed Bilaterally.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{LEVER,SLED}	f	f
Sled Single Leg 45° Leg Press	Sit on machine with back on padded support. Place one foot on platform and other foot on floor below platform. Extend hip and knee. Release dock levers and grasp handles to sides.	Lower sled by bending leg until knee is just short of complete flexion. Return by extending knees and hips. Repeat. Continue with opposite leg.	Re-engage dock levers in extended position before dismounting. Adjust safety brace and back support (back) to accommodate near full range of motion without forcing pelvis to bend at waist. Keep knee pointed same direction as foot. Do not allow heel to raise off of platform, pushing with both heel and forefoot.	{AUXILIARY}	{COMPOUND}	{PUSH}	{LEVER,SLED}	f	f
Sled Lying Leg Press	Lie supine on sled with shoulders against pad. Place feet on platform.	Extend hips and knees. Flex hips and knees to descend until knees are just short of complete flexion. Repeat.	Adjust machine to accommodate near full range of motion without forcing hips to rise at waist. Keep knees pointed same directions as feet. Do not allow heels to raise off of platform, pushing with both heel and forefoot. Placing feet slightly high on platform emphasizes Gluteus Maximus. Placing feet slightly lower on platform emphasizes Quadriceps.	{BASIC}	{COMPOUND}	{PUSH}	{SLED}	f	f
Sled Seated Leg Press	Sit on machine with back on padded support. Place feet on platform. Grasp handles to sides.	Push platform away by extending knees and hips. Return until hips are completely flexed. Repeat.	Adjust seat and back support to accommodate near full range of motion without forcing hips to bend at waist. Keep knees pointed same directions as feet. Do not allow heels to raise off of platform, pushing with both heel and forefoot. Placing feet slightly high on platform emphasizes Gluteus Maximus. Placing feet slightly lower on platform emphasizes Quadriceps.	{BASIC}	{COMPOUND}	{PUSH}	{SLED}	f	f
Sled Kneeling Glute Kickback	Kneel on machine by placing knees on lower pad and feet against bars to rear, if available. Place forearms on padded armrest, and grip handles. Position one foot up so middle of sole is positioned under foot bar.	Push foot bar up by extending leg back as far as possible. Return leg to original position and repeat. Continue with opposite leg.	[]	{AUXILIARY}	{COMPOUND}	{PUSH}	{SLED}	f	f
Sled Single Leg Lying Leg Press	Lie supine on platform with shoulders against pad. Place foot slightly low on platform. Position other leg with lower leg parallel to platform.	Push platform by extending knee and hip until knee is straight. Return by bending hip and knee of supporting leg until knee is just short of complete flexion or until hip is completely flexed. Repeat. Continue with opposite leg.	Allow for full range of motion without forcing hips to bend at waist. Keep knee pointed same directions as foot. Do not allow heel to raise off of platform, pushing with both heel and forefoot. Placing foot slightly high on platform emphasizes Gluteus Maximus. Placing foot slightly lower on platform emphasizes Quadriceps.	{AUXILIARY}	{COMPOUND}	{PUSH}	{SLED}	f	f
Sled Vertical Leg Press	Lie on declined back pad with hips under weighted sled. Place feet on platform. Raise weight by extending hips and knees. Release dock levers and grasp handles to sides.	Lower sled by flexing hips and knees until knees are just short of complete flexion or just before hips raise up from pad. Return by extending knees and hips. Repeat.	If available, re-engage support lever in extended position before dismounting. Flexible hip flexion is required for fuller range of motion through knee. Lower weight just short of hips, leaving back support. Keep knees pointed same directions as feet. Do not allow heels to raise off of platform, pushing with both heel and forefoot, or center of feet if platform is shorter than length of feet.	{BASIC}	{COMPOUND}	{PUSH}	{LEVER,SLED}	f	f
Sled Single Leg Vertical Leg Press	Lie on declined back pad with hips under weighted sled. Place both feet on platform. Raise weight by extending hips and knees. Place foot down off of foot platform. Release dock levers and grasp handles to sides.	Lower sled by flexing leg until knees are just short of complete flexion or just before hips raise up from pad. Push weight up by extending knee and hip. Repeat and continue with opposite leg.	Re-engage support lever in extended position before dismounting. Flexible hip flexion is required for fuller range of motion through knee. Lower weight just short of hips, leaving back support. Keep knee pointed same directions as foot. Do not allow heel to raise off of platform, pushing with both heel and forefoot, or center of foot if platform is shorter than length of feet.	{AUXILIARY}	{COMPOUND}	{PUSH}	{LEVER,SLED}	f	f
Sled Standing Glute Kickback	Straddle sled and place foot on pedal. Place chest on pad and grasp handles.	Push platform back by extending leg back until straight. Return leg to original position. Repeat. Continue with opposite leg.	[]	{AUXILIARY}	{COMPOUND}	{PUSH}	{SLED}	f	f
Sled Rear Lunge	Position shoulders under padded bars handles. Place feet under bar. Straighten legs so weight is lifted. Disengage safety if available.	Step back with one leg while bending supporting leg. Plant forefoot far back on floor. Lower body by flexing knee and hip of supporting leg until knee of rear leg is almost in contact with floor. Return to original standing position by extending hip and knee of forward supporting leg and return rear leg next to supporting leg. Repeat movement with opposite legs, alternating between sides.	Re-engage support lever in extended position before dismounting. Keep torso upright during lunge; flexible hip flexors are important. Forward knee should point same direction as foot throughout lunge. A long lunge with feet slightly forward emphasizes Gluteus Maximus; short lunge with feet under the bar emphasizes Quadriceps.	{AUXILIARY}	{COMPOUND}	{PUSH}	{LEVER,SLED}	f	f
Sled Hack Squat	Lie supine on back pad with shoulders under shoulder pad. Place feet on platform slightly higher than base of sled. Extend hips and knees. Release dock levers.	To lower sled, bend hips and knees until knees are just short of complete flexion. Raise sled by extending knees and hips. Repeat.	Re-engage support lever in extended position before dismounting. If insufficient hip flexibility forces pelvis to pull away from back pad at lower portions of movement, only lower sled just short of spinal articulation. Keep knees pointed same directions as feet. Do not allow heels to raise off of platform, pushing with both heel and forefoot. Placing feet slightly high on platform emphasizes Gluteus Maximus. Placing feet slightly lower on platform emphasizes Quadriceps.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{LEVER,SLED}	f	f
Smith Bent Knee Good-morning	Position bar on back of shoulders. Grasp bar to sides. Disengage bar by rotating bar back.	Bend hips to lower torso forward until parallel to floor. Bend knees slightly during descent. Raise torso until hips are extended. Repeat.	Target muscle is exercised isometrically . Begin with light weight and add additional weight gradually to allow adequate adaptation. Throughout lift, keep back straight. Knees will have to bend more with those with less hamstring flexibility. Knees can be kept bent throughout movement. Also see straight leg Goodmorning emphasizing Hamstrings.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{SMITH}	f	f
Smith Rear Lunge	With bar upper chest height, position bar on back of shoulders and grasp bar to sides. Place feet under bar. Straighten legs so weight is lifted. Disengage bar by rotating bar back.	Step back with one leg while bending supporting leg. Plant forefoot far back on floor. Lower body by flexing knee and hip of supporting leg until knee of rear leg is almost in contact with floor. Return to original standing position by extending hip and knee of forward supporting leg and return rear leg next to supporting leg. Repeat movement with opposite legs alternating between sides.	Keep torso upright during lunge; flexible hip flexors are important. Forward knee should point same direction as foot throughout lunge. A long lunge with feet slightly forward emphasizes Gluteus Maximus; short lunge with feet under the bar emphasizes Quadriceps.	{AUXILIARY}	{COMPOUND}	{PUSH}	{SMITH}	f	f
Smith Single Leg Split Squat	Place bench behind smith bar. With bar upper chest height, position bar on back of shoulders and grasp bar to sides. Place foot slightly forward under bar. Extend other leg back and place top of foot on bench. Disengage bar by rotating bar back.	Lower body on leg by flexing knee and hip of front leg until knee of rear leg is almost in contact with floor. Return to original standing position by extending hip and knee of forward leg. Repeat. Continue with opposite leg.	Keep torso upright during squat; flexible hip flexors are important. Position foot very slightly forward to keep equal distribution of force on hip and knee extensors. Keep foot flat on floor. Forward knee should point same direction as foot throughout movement. May also be referred to as Smith Bulgarian Squat.	{AUXILIARY}	{COMPOUND}	{PUSH}	{SMITH,BENCH}	f	f
Smith Split Squat	With bar upper chest height, position bar on back of shoulders and grasp bar to sides. Place one foot forward slightly and forefoot of other leg further back. Disengage bar by rotating bar back.	Lower body on other leg by flexing knees and hips of both legs until knee of rear leg is almost in contact with floor. Return to original straddled position by extending hips and knees of both legs. Repeat. Continue with opposite leg.	Keep torso upright during movement; flexible hip flexors are important. Knees should point same direction as feet throughout movement. The forward foot further forward will emphasize Gluteus Maximus; forward foot more closer under bar will emphasize Quadriceps.	{AUXILIARY}	{COMPOUND}	{PUSH}	{SMITH}	f	f
Smith Deadlift	Stand with shoulder width or narrower stance with feet flat beneath bar. Grasp bar with shoulder width or slightly wider mixed grip or slightly wider. Disengage bar by rotating bar back.	Squat down to lower bar by bending hips and knees. Lift bar by extending hips and knees to full extension. Pull shoulders back at top of lift if rounded. Return and repeat.	Throughout lift, keep hips low, shoulders high, arms and back straight. Keep bar close to body to improve mechanical leverage. See Smith Deadlift under Gluteus Maximus. Also see Deadlift Analysis.	{BASIC}	{COMPOUND}	{PULL}	{SMITH}	f	f
Sled Single Leg Hack Squat	Lie supine on platform with shoulders against pad. Place feet on platform. Extend hips and knees. Cross lower leg above knee of supporting leg. Release dock levers.	Lower sled by flexing hips and knee of supporting leg until knees are just short of complete flexion. Raise sled by extending knee and hips. Repeat. Continue with opposite leg.	Re-engage dock levers in extended position before dismounting. Adjust machine to accommodate near full range of motion without forcing pelvis to rise at waist. Keep knee pointed same direction as foot. Do not allow heel to raise off of platform, pushing with both heel and forefoot.	{AUXILIARY}	{COMPOUND}	{PUSH}	{LEVER,SLED}	f	f
Smith Squat	With bar upper chest height, position bar on back of shoulders and grasp bar to sides. Place feet under bar. Disengage bar by rotating bar back.	Squat down by bending hips back while allowing knees to bend forward, keeping back straight and knees pointed same direction as feet. Descend until thighs are just past parallel to floor. Extend knees and hips until legs are straight. Return and repeat.	Keep head facing forward, back straight and feet flat on floor; equal distribution of weight through forefoot and heel. Knees should point same direction as feet throughout movement. See Smith Squat Analysis.	{BASIC}	{COMPOUND}	{PUSH}	{SMITH}	f	f
Smith Single Leg Squat	With bar upper chest height, position bar on back of shoulders and grasp bar to sides. Place feet slightly forward and cross lower leg above knee of supporting leg. Disengage bar by rotating bar back.	Bend knees forward slightly while allowing hips to bend, keeping back straight and knees pointed same direction as feet. Descend until thigh of supporting leg is just past parallel to floor. Extend knee and hip until leg is straight. Return and repeat. Continue with opposite leg.	Keep head facing forward, back straight and foot flat on floor; equal distribution of weight through forefoot and heel. Supporting knee should point same direction as foot throughout movement.	{AUXILIARY}	{COMPOUND}	{PUSH}	{SMITH}	f	f
Smith Front Squat	With bar upper chest height, grasp bar with overhand shoulder width grip. Position bar on front of shoulders with elbows forward and wrists hyperextended. Place feet under bar. Disengage bar by rotating bar back.	Squat down by bending hips back while allowing knees to bend forward, keeping back straight and knees pointed same direction as feet. Descend until thighs are just past parallel to floor. Extend knees and hips until legs are straight. Return and repeat.	Keep head facing forward, back straight and feet flat on floor; equal distribution of weight through forefeet and heel. Knees should point same direction as feet throughout movement. Also see bodybuilding style Smith Front Squat and Smith Squat Analysis.	{AUXILIARY}	{COMPOUND}	{PUSH}	{SMITH}	f	f
Smith Hack Squat	Stand with back of thighs or glutes against bar. Grasp bar from behind with overhand grip. Disengage bar by rotating bar back.	Squat down by bending knees forward slightly while allowing hips to bend back behind, keeping back straight and knees pointed same direction as feet. Descend until thighs are too close to parallel to floor and bar is behind lower leg. Lift bar by extending hips and knees to full extension. Repeat.	Throughout lift, keep hips low, shoulders high, arms and back straight. Knees should point same direction as feet throughout movement. See Smith Squat Analysis.	{AUXILIARY}	{COMPOUND}	{PUSH}	{SMITH}	f	f
Smith Wide Squat	With bar upper chest height, position bar on back of shoulders and grasp bar to sides. Place feet wide pointing outward 45° to 30°. Disengage bar by rotating bar back.	Squat down by bending hips back while allowing knees to bend forward, keeping back straight and knees pointed same direction as feet. Descend until thighs are just past parallel to floor. Extend knees and hips until legs are straight. Return and repeat.	Keep head facing forward, back straight and feet flat on floor; equal distribution of weight through forefoot and heel. Knees should point same direction as feet throughout movement. See Smith Squat Analysis.	{BASIC}	{COMPOUND}	{PUSH}	{SMITH}	f	f
Kettlebell Front Squat	Hold two kettlebells in front of shoulders, one with each arm positioned close to body. Stand with feet shoulder width or slightly wider.	Bend knees slightly forward while allowing hips to bend back behind, keeping back taut and knees pointed same direction as feet. Descend until thighs are just past parallel to floor. Extend knees and hips until legs are straight. Return and repeat.	Wrist supporting kettlebell should be held straight. Keep head facing forward, back straight, chest high, arms straight to sides, and feet fl at on floor; equal distribution of weight through forefoot and heel. Knees should point same direction as feet throughout movement. See Squat Analysis and Dumbbell Front Squat.	{AUXILIARY}	{COMPOUND}	{PUSH}	{DUMBBELL,KETTLEBELL}	f	f
Kettlebell Overhead Split Squat	Clean and Jerk kettlebell over head. Stand with feet far apart; leg on side of kettlebell should be placed behind and opposite foot should be positioned forward. Arm should be fully extended upward supporting kettlebell.	Squat down by flexing knee and hip of front leg. Allow heel of rear foot to rise up while knee of rear leg bends slightly, until it almost makes contact with floor. Return to original standing position by extending hip and knee of forward leg. Repeat. Clean and Jerk weight with opposite arm and squat with other leg forward.	Knees should point same direction as feet throughout movement. Heel of rear foot can be kept elevated off floor throughout movement as shown. Keep torso upright during squat; flexible hip flexors are important. With feet further apart: Gluteus Maximus is emphasized, Quadriceps are less emphasized. Wrist supporting kettlebell should be held straight.	{AUXILIARY}	{COMPOUND}	{PUSH}	{KETTLEBELL}	f	f
Kettlebell Overhead Rear Lunge	Clean and Jerk kettlebell over head. Stand with arm fully extended upward supporting kettlebell.	Step back with leg on opposite side of kettlebell while bending supporting leg. Plant forefoot far back on floor. Lower body by flexing knee and hip of supporting leg until knee of rear leg is almost in contact with floor. Return to original standing position by extending hip and knee of forward supporting leg and return rear leg next to supporting leg. Repeat. Clean and Jerk weight with opposite arm and lunge on other leg.	Keep torso upright during lunge; flexible hip flexors are important. Forward knee should point same direction as foot throughout lunge. A long lunge emphasizes Gluteus Maximus; short lunge emphasizes Quadriceps. Wrist supporting kettlebell should be held straight.	{AUXILIARY}	{COMPOUND}	{PUSH}	{KETTLEBELL}	f	f
Lunge	Stand with hands on hips or in front of body.	Lunge forward with first leg. Land on heel, then forefoot. Lower body by flexing knee and hip of front leg until knee of rear leg is almost in contact with floor. Return to original standing position by forcibly extending hip and knee of forward leg. Repeat by alternating lunge with opposite leg.	Keep torso upright during lunge; flexible hip flexors are important. Lead knee should point same direction as foot throughout lunge. A long lunge emphasizes Gluteus Maximus; short lunge emphasizes Quadriceps.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{}	t	f
Rear Lunge	Stand with hands on hips or in front of body.	Step back with one leg while bending supporting leg. Plant forefoot far back on floor. Lower body by flexing knee and hip of supporting leg until knee of rear leg is almost in contact with floor. Return to original standing position by extending hip and knee of forward supporting leg and return rear leg next to supporting leg. Repeat movement with opposite legs alternating between sides.	Keep torso upright during lunge; flexible hip flexors are important. Forward knee should point same direction as foot throughout lunge. A long lunge emphasizes Gluteus Maximus; short lunge emphasizes Quadriceps.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{}	t	f
Reverse Hyper-extension (on stability ball)	Lay prone with waist on stability ball. Grasp secure anchor or bar near floor. Feet should be above floor with legs straight.	Holding firmly on anchor, extend legs upward by lifting and straightening leg as high as possible. Lower legs to original position with thighs close to stability ball. Repeat.	Since knee is initially bent significantly, hamstrings are not significantly involved. Also see Reverse Hyper-extension performed with exercise ball on bench.	{AUXILIARY}	{ISOLATED}	{PUSH}	{BENCH,STABILITY_BALL}	t	f
Single Leg Hip Bridge	Lie on floor or mat. Place one leg straight and bend the other leg with foot flat on floor or mat. Place arms down on mat to each side of hips.	Raise body by extending hip of bent leg, keeping extended leg and hip straight. Return to original position by lowering body with extended leg and hip straight. Repeat and continue with opposite sides.	Hamstring remains in active insufficiency throughout movement since knee is significantly flexed and hip does not flex beyond 90 degrees. Adductor Magnus does not assist since hip extension does not occur in fully flexed position.	{AUXILIARY}	{ISOLATED}	{PUSH}	{}	t	f
Single Leg Squat (pistol)	Stand with arms extended out in front. Balance on one leg with opposite leg extended forward off of ground.	Squat down as far as possible while keeping leg elevated off of floor. Keep back as straight as possible and supporting knee pointed same direction as foot supporting. Raise body back up to original position until knee and hip of supporting leg is straight. Repeat and continue with opposite leg.	Supporting knee should point same direction as foot throughout movement. Range of motion will be improved with greater leg strength and glute flexibility. Also known as Pistol Squat.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{}	t	f
Side Bridge Hip Abduction	Lie on side with legs straight, one leg on top of the other. Place forearm under shoulder perpendicular to body.	Keeping side of bottom foot on ground, raise hips up off ground while raising upper leg upward away from lower leg. Return to original position and repeat. Continue with opposite leg.	Keep feet pointed forward. Exercise can be performed on mat or towel or cushioning can be placed under forearm. See ROM Criteria and Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PUSH}	{}	t	f
Single Leg Half Squat	Stand with arms in front of body either extended or close to torso. Balance on one leg and bend raised leg back at knee.	Squat down to challenging depth while keeping raised leg from contacting floor. Keep back straight and supporting knee pointed same direction as foot supporting. Stand back up to original position until knee and hip of supporting leg are straight. Return and repeat. Continue with opposite leg.	Allow torso to lean forward slightly while hips travel to back and knee travels forward. Supporting knee should point same direction as foot throughout movement. Range of motion will be improved with greater leg strength.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{}	t	f
Split Squat	Stand with hands on hips. Position feet far apart; one foot forward and other foot behind.	Squat down by flexing knee and hip of front leg. Allow heel of rear foot to rise up while knee of rear leg bends slightly until it almost makes contact with floor. Return to original standing position by extending hip and knee of forward leg. Repeat. Continue with opposite leg.	Knees should point same direction as feet throughout movement. Heel of rear foot can be kept elevated off floor throughout movement as shown. Keep torso upright during squat; flexible hip flexors are important. With feet further apart: Gluteus Maximus is emphasized, Quadriceps are less emphasized.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{}	t	f
Single Leg Split Squat	Stand facing away from bench. Extend leg back and place top of foot on bench.	Squat down by flexing knee and hip of front leg until knee of rear leg is almost in contact with floor. Return to original standing position by extending hip and knee of forward leg and repeat. Continue with opposite leg.	Keep torso upright during squat; flexible hip flexors are important. Forward knee should point same direction as foot throughout movement. May also be referred to as Bodyweight Bulgarian Squat.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{BENCH}	t	f
Squat	Stand with arms extended forward.	Squat down by bending hips back while allowing knees to bend forward, keeping back straight and knees pointed same direction as feet. Descend until thighs are just past parallel to floor. Squat up by extending knees and hips until legs are straight. Return and repeat.	Keep head facing forward, back straight, chest high, and feet flat on surface; equal distribution of weight through forefoot and heel. Knees should point same direction as feet throughout movement. Arms positioned forward allow torso to be positioned more upright. See Squat Analysis.	{BASIC}	{COMPOUND}	{PUSH}	{}	t	f
Half Squat	Stand with arms extended forward.	Squat down by bending hips back while allowing knees to bend forward, keeping back straight and knees pointed same direction as feet. Descend to height which allows prescribed number of reps at suggested intensity, short of thighs descending just past parallel to floor. Stand up by extending knees and hips until legs are straight. Return to standing position and repeat.	Keep head facing forward, back straight, chest high, and feet flat on surface. Apply equal distribution of weight through forefoot and heel. Knees should point same direction as feet throughout movement. Arms positioned forward allow torso to be positioned more upright. See Squat Analysis.	{BASIC}	{COMPOUND}	{PUSH}	{}	t	f
Step-up	Stand facing side of bench, step or platform.	Place foot of first leg on bench. Stand on bench by extending hip and knee of first leg and place foot of second leg on bench. Step down with second leg by flexing hip and knee of first leg. Return to original standing position by placing foot of first leg to floor. Repeat first step with opposite leg, alternating first steps between legs.	Keep torso upright during exercise. Lead knee should point same direction as foot throughout movement. Stepping distance from bench emphasizes Gluteus Maximus; stepping close to bench emphasizes Quadriceps.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{BENCH}	t	f
Lateral Step-up	Stand between two benches, one to each side.	Lift leg and place foot on bench to side slightly forward of straight knee. Stand on bench by straightening leg and pushing body upward. Step down returning feet to original position. Repeat with opposite leg alternating between legs.	Keep torso upright during exercise. Stepping knee should point same direction as foot. A modest degree of knee rotation occurs during this movement. See Controversial Exercises and Rotary Force in Squat Analysis.	{AUXILIARY}	{COMPOUND}	{PUSH}	{BENCH}	t	f
Step-down	Stand with one foot on bench or elevated surface. Position foot on elevated surface to side, slightly forward of straight knee.	Stand on elevated surface by straightening leg and pushing body upward. Step down returning foot off of elevated surface to floor and repeat. Continue with opposite position.	Keep torso upright during exercise. Knee of exercised leg should point same direction as foot. See front view.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{BENCH}	t	f
Alternating Step-down	Stand on bench or narrow platform, with feet side by side.	Step down with first foot to side of elevated surface onto floor. Stand back up on elevated surface by straightening upper leg and pushing body upward. Place foot to original position next to opposite foot. Step down and back up with opposite leg in same manner. Repeat by alternating between sides.	Keep torso upright during exercise. Stepping knee should point same direction as foot. A modest degree of knee rotation occurs during this movement. See Controversial Exercises and Rotary Force in Squat Analysis.	{AUXILIARY}	{COMPOUND}	{PUSH}	{BENCH}	t	f
Glute-Ham Raise (hands behind hips)		From upright position, lower body by straightening knees until body is horizontal. Continue to lower torso by bending hips until body is upside down. Raise torso by extending hips until fully extended. Continue to raise body by flexing knees until body is upright. Repeat.	Easier	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{}	t	f
Suspended Hip Bridge	Sit on floor facing suspension trainer loops in low position. Grasp bottom of loops, then lay supine. Raise legs and place heels in loops with soles contacting handles. Lie down supine on mat so knees and hips are bent with suspension straps hanging vertical. Place arms off to sides.	Raise hips up by extending hips until fully extended. Lower hips until hips and back make contact with mat. Repeat.	This exercise can be performed on TRXⓇ style suspension trainer. See Suspended Supine Feet Mount/Dismount. Hamstring enters active insufficiency as hip is raised since knee is flexed and hip does not flex beyond 90 degrees. However, it is used more to stabilize knees in fixed flexed position.	{AUXILIARY}	{ISOLATED}	{PUSH}	{SUSPENSION}	t	f
Suspended Reclining Squat	Stand in front of suspension trainer handles positioned at height of upper abdomen to lower chest. Grasp suspension trainer handles and step back with arms extended forward until suspension straps are taut. While leaning back, step forward with both feet. Recline back with feet apart with arms and body straight.	While reclined back and holding onto suspension trainer handles, squat down by bending hips back while allowing knees to bend forward while keeping back straight and knees pointed same direction as feet. Descend until thighs are perpendicular to body's angle of movement. Stand up by extending knees and hips until legs are straight. Return to reclined standing position with body straight. Repeat.	Apply equal distribution of weight through forefoot and heel. Knees should point same direction as feet throughout movement. See Squat Analysis.	{BASIC}	{COMPOUND}	{PUSH}	{SUSPENSION}	t	f
Suspended Single Leg Squat	Grasp suspension handles and momentarily step back until arms are extended forward and straight. While keeping arms straight and shoulders back, step forward so body reclines back behind suspension handles. Position body and legs straight at desired angle hanging from handles with arms straight. Balance on one leg with opposite leg extended forward off of ground.	Squat down as far as possible while keeping leg elevated off of floor. Keep supporting knee pointed same direction as foot supporting. Raise body back, up to original position until knee and hip of supporting leg is straight. Repeat and continue with opposite leg.	Supporting knee should point same direction as foot throughout movement. Dismounting can be achieved by placing elevated leg down and walking backward until body is upright.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{SUSPENSION}	t	f
Suspended Single Leg Split Squat	Grasp one or both suspension trainer handle(s) in lower position. Step and face away from suspension trainers. Balance on one leg while raising foot from behind and slipping single foot in loop(s). Release handle with hand and position leg back so it is supported behind body by suspension trainer. Place hands on hips and maintain balance throughout exercise.	Squat down by flexing knee and hip of front leg until knee of rear leg is almost in contact with floor. Return to original standing position by extending hip and knee of forward leg and repeat. Continue with opposite leg.	Keep torso upright during squat; flexible hip flexors are important. Forward knee should point same direction as foot throughout movement. Exercise can be dismounted by lifting suspended rear foot from loop, allowing it to fall back while placing foot on floor. A training partner can assist with positioning loop around rear foot.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{SUSPENSION}	t	f
Cable Hip Abduction	Stand in front of low pulley facing to one side. Attach cable cuff to far ankle. Step out away from stack and grasp ballet bar. Stand on near foot and allow far leg to cross in front.	Move leg to opposite side of low pulley by abduction hip. Return and repeat. Turn around and continue with opposite leg.	See ROM Criteria and Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PUSH}	{CABLE}	f	f
Angled Side Bridge Hip Abduction	Grasp vertical bar with one hand and turn to side. Position feet out away from vertical bar with arm supporting body extended out to side. Legs should be straight and positioned side by side. Supporting arm should be approximately vertical to body and other arm can be placed on hips. Lower hips downward to floor until slight stretch is felt.	Keeping foot closest to bar on ground, raise hips upward and away from bar while raising leg furthest from bar upward away from lower leg. Return to original position with hips sagging downward and repeat. Continue with opposite leg.	Keep feet pointed forward. See ROM Criteria and Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PUSH}	{}	t	f
Cable Lying Hip Internal Rotation	Attach cable ankle cuff to ankle, furthest low pulley. Step near foot over cable and lie prone perpendicular to cable. Bend knee 90° so attached ankle crosses over resting straight leg nearest pulley. Adjust positioning of legs slightly away from cable pulley so slight stretch is felt in hip.	Keeping knee of attached leg bent approximately 90°, pull cable attachment away from pulley by rotating hip as far as possible. Return leg to original position toward pulley and repeat. Place ankle cuff on opposite leg and continue lying opposite direction.	Exercise name is somewhat counter-intuitive since direction of rotation is relative to movement of hip, or thigh, not bent leg. For example, in this exercises, internal rotation of hip causes front of thigh to turn inward despite bent leg moving outward. Incidentally, if knee were straight during internal rotation of thigh, foot would move inward.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable Seated Hip Internal Rotation	Sit on bench or chair with low pulley to side. Attach cable ankle cuff to ankle furthest pulley. Place foot of stationary leg just forward of foot attached to cable. Grasp bench and handle bar on cable column if available. Position thighs of both legs side by side, perpendicular to cable. Raise foot attached to cable slightly off of floor.	Keeping knee of attached leg bent approximately 90°, pull cable attachment away from pulley by rotating hip as far as possible. Return foot behind stationary foot and toward pulley. Repeat. Place ankle cuff on opposite leg and continue facing opposite direction.	Height of knee on exercising leg may require subtle adjustment during movement to permit clearance of traveling foot above floor. Gluteus Maximus will be activated as stabilizer on heavier loads when participant pushes stationary foot onto floor, thereby anchoring lower body as hip abductors keep thighs in place.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE,BENCH}	f	f
Lever Lying Hip Abduction	Sit in machine with heels on bars or legs inside of side pads. Lie back on back pad. Pull in on lever to position legs together. Release lever into position and grasp bars to sides.	Move legs away from one another by abduction hip. Return and repeat.	See ROM Criteria and Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PUSH}	{LEVER}	f	f
Cable Twist	Grasp stirrup from shoulder height cable pulley with both hands. Step and turn lower body away from pulley until near arm is horizontal and straight. Position feet wide apart facing away from pulley, furthest foot further away from pulley. Raise heel of nearest foot off floor. Bend knees of both legs slightly. Place far hand over other hand or interlace fingers.	Keeping arms straight, rotate torso to opposite side until cable makes contact with shoulder. Return to original position and repeat. Continue with opposite side.	Both arms should be horizontal and straight. This movement arguably involves more hip internal rotation and transverse adduction than spinal rotation. Although it is considered oblique movement, remarkably little rotation actually occurs through spine, although rotators of spine act largely as stabilizers except at very beginning and end of motion where resistance from cable is minimal.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Bent Knee Side Bridge Hip Abduction	Lie on side with legs bent back 90 degrees, one leg on top of the other. Place forearm under shoulder perpendicular to body.	Keeping shank of lower leg on mat or floor, raise hips up off ground while raising upper leg upward away from lower leg. Return to original position and repeat. Continue with opposite leg.	Keep knees bent throughout exercise. Exercise can be performed on mat or towel or cushioning can be placed under forearm. See ROM Criteria and Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PUSH}	{}	t	f
Lever Seated Hip Abduction	Sit on machine with legs inside of side pads. If available, place heels on foot bars. Release and pull lever brace to position legs together. Engage lever into locked position. Lie back and grasp bars to sides.	Move legs apart as far as possible. Return and repeat.	Mount machine with leg levers apart. Use lever to position legs together. See ROM Criteria and Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PUSH}	{LEVER}	f	f
Lever Standing Hip Abduction	Adjust platform so lever fulcrum is same height as hip articulation. Adjust roller in low position. Face machine and grasp bars to sides. Place outside of thigh against roller pad and shift body weight to opposite leg.	Raise leg against roller pad to side by abduction hip. Return and repeat. Reposition roller pad lever and continue with opposite leg.	See ROM Criteria and Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PUSH}	{LEVER}	f	f
Cable Push Pull	Stand between high and low pulleys, facing low pulley. Place one foot back and grasp high pulley stirrup from behind with hand on same side as rear foot. Position stirrup to side of chest and grasp low pulley stirrup with opposite hand (same side as forward foot) with arm extended straight. Face low pulley with hips turned out approximately 45 degrees.	Pull low pulley stirrup back to side of ribcage while pushing high pulley stirrup forward until arm is extended, allowing torso to rotate to opposite side.	Reposition to opposite posture and continue. Also see Cable Push Pull on other machine.	{}	{COMPOUND}	{PUSH,PULL}	{CABLE}	f	f
Suspended Hip Abduction	Sit on floor facing suspension trainer loops in low position. Grasp bottom of loops, then lay supine. Raise legs and place heels in loops with soles contacting handles. Extend legs out and place arms on floor off to sides. Straighten low back, knees, and hips, raising back and hips off of floor.	Pull legs apart as far as possible. Return by placing legs together and repeat.	See Suspended Supine Feet Mount/Dismount. Keep low back straight, maintaining approximate height from floor throughout movement. This exercise can be performed on TRXⓇ style suspension trainer. See ROM Criteria and Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PUSH}	{SUSPENSION}	t	f
Angled Side Bridge	Place forearm on padded elevated surface, positioned perpendicular to body. Position feet out away from elevated surface, one foot in front of other with hips and knees straight. Place free hand on upper hip and allow lower hip and waist to bend downward.	Raise hips upward by lateral flexion of spine. Lower to original position and repeat. Repeat with opposite side.	One of very few body weight exercises that directly exercises side deltoid in relatively full range of motion. In addition to lateral flexion of spine, lower hip abducts and upper hip adducts. See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PUSH}	{}	t	f
Bent Knee Side Bridge	Lie on side on mat. Place forearm on mat under shoulder perpendicular to body. Bend knees at a right angle. Place upper leg directly on top of lower leg and straighten hips.	Raise hips upward by lateral flexion of spine. Lower to original position and repeat. Repeat with opposite side.	In addition to lateral flexion of spine, lower hip abducts and upper hip adducts. Exercise can also be performed isometrically, see Bent Knee Side Plank. Gracilis of upper leg enters into active insufficiency with hip extended and knee flexed. Also see Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PUSH}	{}	t	f
Side Bridge	Lie on side on mat. Place forearm on mat under shoulder perpendicular to body. Place upper leg directly on top of lower leg and straighten knees and hips.	Raise hips upward by lateral flexion of spine. Lower to original position and repeat. Repeat with opposite side.	In addition to lateral flexion of spine, lower hip abducts and upper hip adducts. Exercise can also be performed isometrically, see Side Plank. Also see Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PUSH}	{}	t	f
Suspended Side Bend	Grasp handles, step away, and face body to one side of suspension trainer anchor. Hold handles above head with arms bent. Stand far enough away to make suspension trainer straps taut. Step in just enough to achieve desired lean of body, while keeping tension on suspension trainer straps.	Lower hips away from direction of suspension trainer anchor by laterally flexing spine. Return to original upright position and repeat. Reposition body facing opposite direction. Continue with other side.	Suspension handle(s) can also be gripped with both hands together with either one hand over other hand or with interlaced fingers. In addition to lateral flexion of spine, lower hip abducts and upper hip adducts. Also see Spot Reduction Myth. This exercise can be performed on TRXⓇ style suspension trainer or adjustable length gymnastics rings.	{AUXILIARY}	{ISOLATED}	{PULL}	{SUSPENSION}	t	f
Suspended Side Bridge	Sit on floor or mat, facing suspension trainer loops in low position. Grasp bottom of loops, then lay supine. Raise legs and place heels in loops with soles contacting handles. Extend legs out with one leg crossed over other. Turn on side of lower leg so legs are parallel. Place forearm on mat or floor under shoulder perpendicular to body.	Raise hips upward by lateral flexion of spine. Lower to original position and repeat. Reposition to opposite side and continue.	In addition to lateral flexion of spine, lower hip abducts and upper hip adducts. This exercise can be performed on TRXⓇ style suspension trainer. More popular suspension trainers allow limited slippage, so loop around lower leg can be positioned below loop of upper leg once on side (as shown). Other models can be adjusted, so strap on lower leg is slightly longer than strap on upper leg. Alternatively, see alternative positioning with one foot can be positioned behind other with only feet being placed in stirrups. Also see Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PUSH}	{SUSPENSION}	t	f
Suspended Twist	Grasp suspension handle(s) with both hands, together with either one hand over other hand or with interlaced fingers. Momentarily step back until arms are extended forward and straight. While keeping arms straight and shoulders back, step forward so body reclines back behind suspension handle(s). Position body and legs straight at desired angle, hanging from handles with arms straight. Feet can be either shoulder width or as wide as desired.	While keeping arms straight and shoulders fixed, rotate torso up to one side. Twist until upright or slight stretch is felt in waist, whichever comes soonest. Rotate back to starting position and repeat. Continue on opposite side.	The exercise can also be mounted from top position in fully rotated position facing perpendicular to suspension straps while positioning feet parallel to straps. Exercise can also be executed by alternating sides, rotating from one side to the other. Dismounting can be achieved either at top of movement when body is fully rotated or hanging at bottom position by walking backward until body is upright. This exercise can be performed on TRXⓇ style suspension trainer or adjustable length gymnastics rings.	{AUXILIARY}	{ISOLATED}	{PULL}	{SUSPENSION}	t	f
Cable Lying Leg Raise	Attach cable ankle straps to both ankles, then attach ankle straps to cable. Lie supine on floor or mat, back far enough so cable is taut. Grasp support behind head.	Raise legs by flexing hips and knees until thighs are just past perpendicular to torso or before hips raise off of bench. Return until hips and knees are extended. Repeat.	Exercise can be performed on bench. Rectus Abdominis and Obliques only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion. It may be necessary to completely flex hips before waist flexion is possible (see Cable Lying Leg-Hip Raise). Knees may be kept extended throughout leg raise to increase intensity (see Cable Lying Straight Leg Raise). Also known as Cable Lying Knee Raise. Also see Spot Reduction Myth and Lower Ab Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE,BENCH}	f	f
Lever Hip Flexion	Stand on platform facing to one side and grasp bar for support. Position front of leg nearest to machine against padded roller while standing on other leg.	Raise lever by flexing hip until knee is higher than hip. Return until hip is extended. Repeat. Continue with opposite leg.	Machine must be adjusted to align hip with lever fulcrum. Rectus Abdominis and Obliques only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion. Conversely, it may be necessary to completely flex hips before waist flexion is possible, which is not practical with the opposite leg supporting body. See Spot Reduction Myth and Lower Ab Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Cable Lying Straight Leg Raise	Attach cable ankle straps to both ankles, then attach ankle straps to cable. Lie supine on floor, mat, or bench back far enough so cable is taut. Grasp support behind head.	With knees straight, raise legs by flexing hips until thighs are just past perpendicular to torso or before hips raise off of mat. Return until hips are extended. Repeat.	Rectus Abdominis and Obliques only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion. It may be necessary to completely flex hips before waist flexion is possible; see Cable Lying Leg-Hip Raise. Knees can flex along with hips to decrease intensity; see Cable Lying Leg Raise. Also see Spot Reduction Myth and Lower Ab Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE,BENCH}	f	f
Cable Standing Leg Raise	Attach cable ankle cuff to one ankle. Stand facing away from low pulley. Step forward with opposite leg so leg with cuff is pulled back. Grasp lateral bars or other prop for support.	Raise knee by flexing hip while allowing lower leg to bend back under resistance. When thigh is just beyond horizontal, lower leg until hip and knee is extended. Repeat. Continue with opposite leg.	Also known as Cable Standing Knee Raise. See Spot Reduction Myth and Lower Ab Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable Standing Straight Leg Raise	Stand facing away from low pulley. Place foot in cable boot or foot harness. Grasp lateral bars or other prop for support. Stand forward on free leg, allowing leg attached to cable to be pulled back.	Raise leg upward by flexing hip while keeping knee straight. Raise leg as high as possible. Lower leg to original starting position. Repeat. Continue with opposite leg.	Since knee of moving leg is straight and waist flexion is impeded by standing leg, range of motion will be limit to hamstring flexibility. See Spot Reduction Myth and Lower Ab Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Lever Lying Leg Raise	Sit on end of bench with both legs over padded lever and hips aligned with fulcrum. Strap legs onto padded lever. Lie supine on bench. Grasp handles near head.	Raise legs by flexing hips until they are completely flexed. Lower legs until hips are extended. Repeat.	Rectus Abdominis and Obliques only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion. Also known as Lever Lying Hip Flexion. Also see Spot Reduction Myth and Lower Ab Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER,BENCH}	f	f
Lever Vertical Leg Raise	Grasp handles slightly to front and stand on foot bar with knees slightly bent and hips against pad.	With back straight, raise legs as high as possible by flexing hips. Return and repeat.	Exercise is typically performed without added resistance. Rectus Abdominis and Obliques only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion. It is necessary to raise legs higher than what is shown before waist flexion occurs; see Lever Vertical Leg-Hip Raise. Also see Spot Reduction Myth and Lower Ab Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Hanging Leg Raise	Grasp and hang from high bar with slightly wider than shoulder width overhand grip.	Raise legs by flexing hips and knees until hips are completely flexed or knees are well above hips. Return until hips and knees are extended downward. Repeat.	Exercise can be performed with ab straps. Rectus Abdominis and Obliques only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion. It may be necessary to completely flex hips before waist flexion is possible, as in leg-hip raise. Also known as Hanging Knee Raise. Also see Spot Reduction Myth and Lower Ab Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{PULL_UP_BAR}	t	f
Hanging Straight Leg Raise	Grasp and hang from high bar with slightly wider than shoulder width overhand grip.	With knees straight, raise legs by flexing hips until hips are completely flexed or knees are well above hips. Return until hips are extended downward. Repeat.	Rectus Abdominis and Obliques only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion. It may be necessary to completely flex hips before waist flexion is possible as in hip leg raise. Also see Spot Reduction Myth and Lower Ab Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{PULL_UP_BAR}	t	f
Incline Leg Raise	Lie supine on incline board with torso elevated. Grasp feet hooks or sides of board for support.	Raise legs by flexing hips and knees until hips are completely flexed. Return until hips and knees are extended. Repeat.	Rectus Abdominis and Obliques only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion. It may be necessary to completely flex hips before waist flexion is possible, as in leg-hip raise. Also known as Incline Knee Raise. Also see Spot Reduction Myth and Lower Ab Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{}	t	f
Incline Straight Leg Raise	Sit on incline board. Lie supine on incline board with torso elevated. Grasp feet rollers or sides of board for support.	With knees straight, raise legs by flexing hips until hips are completely flexed. Return until hips and knees are extended. Repeat.	Rectus Abdominis and Obliques only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion. It may be necessary to completely flex hips before waist flexion is possible, as in leg-hip raise. Attempting to perform Incline Straight Leg-Hip Raise at a low incline would not load waist and hip flexors after they travel beyond vertical so that sort of movement would need to be performed on steep incline or vertical position, requiring much greater strength. Also see Spot Reduction Myth and Lower Ab Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{}	t	f
Lying Simultaneous Alternating Leg Raise	Lie supine on bench or mat. Place hands under lower buttock on each side to support pelvis. Raise bent leg up so lower leg is approximately horizonal above hip. If lying on floor, raise other leg slightly off of floor.	Simultaneously change positions of legs, lowering and straightening raised leg down just above floor while raising and bending lower leg to opposite position. Continue alternating leg positions.	Rectus Abdominis and Obliques only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion. Conversely, it may be necessary to completely flex hips before waist flexion is possible, which is not practical with alternating leg movements. Also known as Lying Simultaneous Alternating Knee Raise. Also see Spot Reduction Myth and Lower Ab Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{BENCH}	t	f
Lying Straight Leg Raise	Lie supine on bench or mat. Place hands under lower buttock on each side to support pelvis.	Keeping knees straight, raise legs by flexing hips until hips are completely flexed. Return until hips and knees are extended. Repeat.	Rectus Abdominis and Obliques only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion. It may be necessary to completely flex hips before waist flexion is possible, as in leg-hip raise. Attempting to perform Lying Straight Leg Hip Raise would not load waist and hip flexors after they travel beyond vertical so that sort of movement would need to be performed on steep incline or vertical position, requiring much greater strength. Also see Spot Reduction Myth and Lower Ab Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{BENCH}	t	f
Lying Simultaneous Alternating Straight Leg Raise	Lie supine on bench or mat. Place hands under lower buttock on each side to support pelvis. Raise one leg up vertically with knee nearly straight. If lying on floor, raise other leg slightly off of floor.	Keeping knees nearly straight, simultaneously change positions of legs so vertical leg is lowered while lower leg is raised vertically. Continue alternating leg positions.	Rectus Abdominis and Obliques only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion. It may be necessary to completely flex hips before waist flexion is possible. Conversely, it may be necessary to completely flex hips before waist flexion is possible, which is not practical with alternating leg movements. Also see Spot Reduction Myth and Lower Ab Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{BENCH}	t	f
Seated Leg Raise	Sit on edge of bench with legs extended to floor. Place weight between ankles or use no weight. Grasp edge of bench. Lean torso back and balance body weight on edge of bench.	Raise legs by flexing hips and knees while pulling torso slightly forward to maintain balance. Return by extending hips and knees and lean torso back to counter balance. Repeat.	Heels may make contact with floor to maintain balance at bottom of movement. Rectus Abdominis and Obliques only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion. It may be necessary to completely flex hips before waist flexion is possible. Typically, the spine is not extended enough in this movement to constitute significant spinal flexion, so it remains classified as a hip flexor movement. Also known as Seated Leg Tuck or Leg Tuck (across bench). Also see Spot Reduction Myth and Lower Ab Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{BENCH}	t	f
Vertical Leg Raise	Position forearms on padded parallel bars with hands on handles, and back on vertical pad.	Raise legs by flexing hips and knees until hips are completely flexed or knees are well above hips. Return until hips and knees are extended. Repeat.	Rectus Abdominis and Obliques only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion. It may be necessary to completely flex hips before waist flexion is possible, as in leg-hip raise. Also known as Vertical Knee Raise. Also see Spot Reduction Myth and Lower Ab Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{PARALLEL_BARS}	t	f
Vertical Straight Leg Raise	Position forearms on padded parallel bars with hands on handles, and back on vertical pad.	With knees straight, raise legs by flexing hips until thighs are just pass parallel to floor. Return until hips are extended. Repeat.	Rectus Abdominis and Obliques only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion. It may be necessary to completely flex hips before waist flexion is possible, as in leg-hip raise. Also see Spot Reduction Myth and Lower Ab Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{PARALLEL_BARS}	t	f
Jack-knife on Ball	Kneel with chest or waist on exercise ball. Dive over top and place hands on floor with arms extended down supporting upper body. While keeping body horizontal, walk hands further away from ball until shins are positioned on top of ball. With arms vertical and straight, support body off of floor with body straight. See suggested mount onto exercise ball.	Bend hips and knees, allowing shins to roll over top of ball. Pull knees toward chest until heels are under or near glutes. Return by extending hips and knees to original position. Repeat.	Keep arms straight with shoulders positioned above hands. Rectus Abdominis and Obliques only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique act only to stabilize pelvis and waist during hip flexion. If waist flexion were to occur after complete hip flexion, resistive forces are no longer working against abdominal muscles in this final position when knees and hips are flexed. However, abdominal muscles are activated isometrically to keep spine straight when knees are not under body. Also see Spot Reduction Myth and Lower Ab Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{}	t	f
Lying Scissor Kick	Lie supine on bench or mat. Place hands under lower buttock on each side to support pelvis. Raise one leg up vertical with knee nearly straight. If lying on floor, raise other leg slightly off of floor.	Keeping knees nearly straight, simultaneously change positions of legs so vertical leg is lowered while lower leg is raised vertically. Continue alternating leg positions.	Also known as Scissors Kick. Movement involves very short range of motion so greater isometric-like endurance is required. Also see over/under variation.	{AUXILIARY}	{ISOLATED}	{PULL}	{BENCH}	t	f
Jack-knife on Power Wheel	With feet strapped to power wheel, kneel on floor. Place hands shoulder width apart on floor. With arms vertical and straight, support body off of floor while rolling power wheel back until body is straight.	Bend hips and knees, pulling legs under body. Pull bent knees toward chest, allowing rear end to raise upward. Return by extending hips and knees to original position. Repeat.	Keep arms straight with shoulders positioned above hands. Rectus Abdominis and Obliques only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique act only to stabilize pelvis and waist during hip flexion. In this movement, even if waist flexion were to occur after complete hip flexion, the abs have endured much more stabilizing forces in their extended position than dynamic forces they could possibly encounter in the flexed position. Also see Spot Reduction Myth and Lower Ab Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{}	t	f
Pike on Power Wheel	With feet strapped to power wheel, kneel on floor. Place hands shoulder width apart on floor. With arms vertical and straight, support body off of floor while rolling power wheel back until body is straight.	From plank position, raise rear end up as high as possible by bending hips. Pull power wheel toward hands while keeping knees straight. Return by extending hips to original position. Repeat.	Keep arms straight with shoulders positioned above hands. Rectus Abdominis and Obliques only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique act only to stabilize pelvis and waist during hip flexion. If waist flexion were to occur after complete hip flexion, resistive forces are no longer working against abdominal muscles in this final position when knees and hips are flexed. However, abdominal muscles are activated isometrically to keep spine straight when knees are not under body. Also see Spot Reduction Myth and Lower Ab Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{}	t	f
Pike on Discs	Kneel on floor with forefeet on gliding discs. Place hands shoulder width apart on floor. With arms vertical and straight, support body off of floor while sliding gliding discs back until body is straight.	From plank position, raise rear end up as high as possible by bending hips. Pull gliding discs toward hands while keeping knees straight. Return by extending hips to original position. Repeat.	Keep arms straight with shoulders positioned above hands. Rectus Abdominis and Obliques only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique act only to stabilize pelvis and waist during hip flexion. If waist flexion were to occur after complete hip flexion, resistive forces are no longer working against abdominal muscles in this final position when knees and hips are flexed. However, abdominal muscles are activated isometrically to keep spine straight when knees are not under body. Also see Spot Reduction Myth and Lower Ab Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{}	t	f
Suspended Mountain Climber	Sit on floor facing suspension trainer loops in low position. Place right foot in left lower loop. Cross left leg over right leg placed in right lower loop. Turn body to right and place hands on floor, shoulder width apart. Turn body to kneel on hands and knees. Reposition hands (shoulder width or slightly wider) at desired distance from suspension trainer so that body is square with suspension trainer straps. With arms straight, raise knees from ground so body is supported by arms and suspension trainer. Bend one leg so knee is pointing down while keeping other leg extended out straight.	Simultaneously alternate leg positions by straightening bent leg behind, while bending straight leg forward. Repeat.	Attempt to straighten hip each stroke, while maintaining approximate height of hips from floor throughout movement. Dismount by removing straps, while kneeling or after sitting on one side of hip before rotating body to seated position. See Suspended Prone Feet Mount/Dismount.	{AUXILIARY}	{COMPOUND}	{PULL}	{SUSPENSION}	t	f
Suspended Pike	Sit on floor facing suspension trainer loops in low position. Place right foot in left lower loop. Cross left leg over right leg placed in right lower loop. Turn body to right and place hands on floor shoulder width apart. Turn body to kneel on hands and knees. Reposition hands (shoulder width or slightly wider) at desired distance from suspension trainer so that body is square with suspension trainer straps. With arms straight, raise knees from ground, so body is supported by arms and suspension trainer.	Raise rear end up as high as possible by bending hips. Pull feet toward hands, while keeping knees straight. Return by extending hips to original straight body position. Repeat.	Keep arms straight with shoulders positioned above hands. Dismount by removing straps while kneeling or after sitting on one side of hip before rotating body to seated position. See Suspended Prone Feet Mount/Dismount. This exercise can be performed on TRXⓇ style suspension trainer.	{AUXILIARY}	{ISOLATED}	{PULL}	{SUSPENSION}	t	f
Cable Lying Hip External Rotation	Attach cable ankle cuff to ankle, nearest low pulley. Lie prone with legs slightly apart and knee of attached leg bent 90°. Adjust position of legs slightly away from cable pulley so slight stretch is felt in hip.	Keeping knee of attached leg bent approximately 90°, pull cable attachment toward opposite knee by rotating hip. Return until slight stretch is felt in hip, then repeat. Place ankle cuff on opposite leg and continue lying opposite direction.	Exercise name is somewhat counter-intuitive since direction of rotation is relative to movement of hip, or thigh, not bent leg. For example, in this exercises, external rotation of hip causes front of thigh to turn outward despite bent leg moving inward. Incidentally if knee were straight during external rotation of thigh, foot would move outward.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable Seated Hip External Rotation	Sit on bench or chair with low pulley to side. Attach cable ankle cuff to ankle, nearest pulley. Place far stationary foot slightly forward. Grasp lower thigh of leg with attached cuff, position it along side thigh of stationary leg while keeping foot slightly above floor.	Keeping knee of attached leg bent approximately 90°, pull cable attachment under thigh of stationary leg by rotating hip. Return until slight stretch is felt in hip, then repeat. Place ankle cuff on opposite leg and continue facing opposite direction.	Height of knee on exercising leg may require subtle adjustment during movement to permit clearance of traveling foot above floor. Gluteus Maximus will be activated as stabilizer on heavier loads when participant pushes stationary foot onto floor thereby anchoring lower body as hip adductors keep thighs together. Upper body muscles can also assist in keeping thigh of exercising leg along side stationary leg. Exercise name is somewhat counter-intuitive since direction of rotation is relative to movement of hip, or thigh, not bent leg. For example, in this exercises, external rotation of hip causes front of thigh to turn outward despite bent leg moving inward. Incidentally if knee were straight during external rotation of thigh, foot would move outward.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE,BENCH}	f	f
Barbell Front Raise	Grasp barbell with overhand grip with elbows straight or slightly bent.	Raise barbell forward and upward until upper arms are above horizontal. Lower and repeat.	Height of movement may depend on range of motion. Raise should be limited to height achieved just before tightness is felt in shoulder capsule. Alternatively, height just above horizontal may be considered adequate. Elbows may be kept straight or slightly bent throughout movement.	{AUXILIARY}	{ISOLATED}	{PUSH}	{BARBELL}	f	f
Barbell Incline Front Raise	Grasp barbell with shoulder width overhand grip. Lie supine on upper portion of 45 degree incline bench with legs straight. Position barbell on top of upper thighs.	With elbows straight or slightly bent, raise barbell up and over shoulders until uppers arm are vertical. Lower barbell to upper thigh and repeat.	Movement can also be performed on old fashioned incline bench without seat.	{AUXILIARY}	{ISOLATED}	{PUSH}	{BARBELL,BENCH}	f	f
Barbell Military Press	Grasp barbell from rack or clean barbell from floor with overhand grip, slightly wider than shoulder width. Position bar in front of neck.	Press bar upward until arms are extended overhead. Lower to front of neck and repeat.	See unrack and rack technique. Feet may be positioned shoulder width apart or one foot in front of other with forward leg slightly bent (as shown). Upper chest assists (instead of side delts) since grip is slightly narrower and chest is high with low back arched back slightly. Also known as Overhead Press. Also see Push Press and Press Strength Standards.	{BASIC}	{COMPOUND}	{PUSH}	{BARBELL}	f	f
Barbell Seated Military Press	Grasp barbell with slightly wider than shoulder width overhand grip from rack. Position bar near upper chest.	Press bar upward until arms are extended overhead. Return to upper chest and repeat.	Set barbell on forward rack slightly below shoulder height so bar may be more easily unracked and racked. Position seat so bar does not hit uprights but close enough to easily mount and rack. Range of motion will be compromised if grip is too wide. Grip is slightly narrower than shoulder press. Torso is postured more upright than traditional Military Press.	{BASIC}	{COMPOUND}	{PUSH}	{BARBELL}	f	f
Barbell Shoulder Press	Grasp barbell with slightly wider than shoulder width overhand grip from rack. Position bar near upper chest.	Press bar upward until arms are extended overhead. Return to upper chest and repeat.	Set barbell on forward rack slightly below shoulder height so bar may be more easily mounted and racked. Position seat so bar does not hit uprights but close enough to easily mount and rack. Range of motion will be compromised if grip is too wide.	{BASIC}	{COMPOUND}	{PUSH}	{BARBELL}	f	f
Barbell Reclined Shoulder Press	Sit on Incline bench angled at 70° to 80°. Grasp barbell with slightly wider than shoulder width overhand grip from rack. Lean back on reclined back pad with bar positioned near upper chest.	Press bar upward until arms are extended overhead. Return to upper chest and repeat.	Reclined position can be used instead of standard form for those who lack ability to fully flex shoulder. A bench inclined 70° to 80° is equivalent to reclined upright position 10° to 20° from vertical. Exercise can be performed in front of barbell rack with barbell racked slightly below shoulder height so bar may be more easily mounted and racked. Position Incline bench or seat with reclining back support so barbell does not hit uprights when leaning back but close enough to easily mount and rack. Range of motion will be compromised if grip is too wide.	{BASIC}	{COMPOUND}	{PUSH}	{BARBELL,BENCH}	f	f
Cable Bar Behind Neck Press	Stand facing cable bar, mounted on each side to upper waist height narrow double pulley cables. Grasp cable bar with wide overhand grip upper chest height. Stand directly between both cable pulleys with one foot forward and other foot back. Push cable bar over head and position cable bar behind neck or rest on shoulders.	Press cable bar upward until arms are extended overhead. Return behind neck and repeat.	Exercise may also be performed seated, straddling bench or on weight chair with back support.	{BASIC}	{COMPOUND}	{PUSH}	{CABLE,BENCH}	f	f
Cable Bar Front Raise	Grasp cable bar with overhand grip with elbows straight or slightly bent.	Raise cable bar forward and upward until upper arms are above horizontal. Lower and repeat.	Height of movement may depend on range of motion. Raise should be limited to height achieved just before tightness is felt in shoulder capsule. Alternatively, height just above horizontal may be considered adequate. Elbows may be kept straight or slightly bent throughout movement.	{AUXILIARY}	{ISOLATED}	{PUSH}	{CABLE}	f	f
Cable Bar Military Press	Stand facing cable bar, mounted on each side to upper waist height narrow double pulley cables. Grasp cable bar with overhand grip, slightly wider than shoulder width. Position cable bar upper chest height. Stand directly between both cable pulleys with one foot forward and other foot back.	Press cable bar upward until arms are extended overhead. Return to upper chest and repeat.	Feet may be positioned shoulder width apart or one foot in front of other with forward leg slightly bent (as shown). Upper chest assists (instead of side delts) since grip is slightly narrower and chest is high with low back arched back slightly.	{BASIC}	{COMPOUND}	{PUSH}	{CABLE}	f	f
Cable Bar Shoulder Press	Stand facing cable bar mounted on each side to upper waist height narrow double pulley cables. Grasp cable bar with wide overhand grip and position upper chest height. Stand directly between both cable pulleys with one foot forward and other foot back.	Press cable bar upward until arms are extended overhead. Return to upper chest and repeat.	Exercise may also be performed seated, straddling bench or on weight chair with back support. Range of motion will be compromised if grip is too wide.	{BASIC}	{COMPOUND}	{PUSH}	{CABLE,BENCH}	f	f
Cable Seated Front Raise	Sit on seat above twin cable pulleys. Grasp stirrups on each side. Sit upright with arms straight down to each side with palms facing back.	Raise stirrups forward and upward until upper arms are well above horizontal. Lower and repeat.	Height of movement may depend on range of motion or when stirrup or cable makes contact with underside of forearm. Raise should be limited to height achieved just before tightness is felt in shoulder capsule. Alternatively, height just above horizontal may be considered adequate. Elbows may be kept straight or slightly bent throughout movement.	{AUXILIARY}	{ISOLATED}	{PUSH}	{CABLE}	f	f
Cable Alternating Front Raise	Stand with low double pulleys behind. Grasp stirrup attachments, one in each hand. Stand away from pulley slightly with arms back somewhat at side and elbows straight or slightly bent.	Raise one stirrup forward and upward until upper arm is well above horizontal. Lower and repeat with opposite arm, alternating between arms.	Height of movement may depend on range of motion or when stirrup or cable makes contact with underside of forearm. Raise should be limited to height achieved just before tightness is felt in shoulder capsule. Alternatively, height just above horizontal may be considered adequate. Elbows may be kept straight or slightly bent throughout movement.	{AUXILIARY}	{ISOLATED}	{PUSH}	{CABLE}	f	f
Cable Alternating Seated Front Raise	Sit on seat above twin cable pulleys. Grasp stirrups on each side. Sit upright with arms straight down to each side with palms facing back.	Raise one stirrup forward and upward until upper arm is well above horizontal. Lower and repeat with opposite arm. Continue by alternating raises between sides.	Height of movement may depend on range of motion or when stirrup or cable makes contact with underside of forearm. Raise should be limited to height achieved just before tightness is felt in shoulder capsule. Alternatively, height just above horizontal may be considered adequate. Elbows may be kept straight or slightly bent throughout movement.	{AUXILIARY}	{ISOLATED}	{PUSH}	{CABLE}	f	f
Cable One Arm Front Raise	Grasp stirrup attachment. Stand away from pulley slightly with arm back somewhat at side and elbow straight or slightly bent.	Raise stirrup forward and upward until upper arm is well above horizontal. Lower and repeat. Repeat with opposite arm.	Height of movement may depend on range of motion or when stirrup or cable makes contact with underside of forearm. Raise should be limited to height achieved just before tightness is felt in shoulder capsule. Alternatively, height just above horizontal may be considered adequate. Elbows may be kept straight or slightly bent throughout movement.	{AUXILIARY}	{ISOLATED}	{PUSH}	{CABLE}	f	f
Cable Standing Shoulder Press	Stand between two low to medium height pulleys. Grasp cable stirrups from each side. Position stirrups to each side of shoulders with elbows down to sides and stirrups above or slightly narrower than elbows.	Push stirrups upward until arms are extended overhead. Return stirrups to sides of shoulders and repeat.	Wrists maintain their approximate position above each elbow throughout movement. Feet may be positioned apart to each side or one foot back as shown. Cable pulleys should be much closer together than what is typically found on standard cable cross over setup.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE}	f	f
Cable Shoulder Press	Sit on seat and grasp stirrups from low to medium low position from each side. Position stirrups to each side of shoulders with elbows down to sides and stirrups above or slightly narrower than elbows.	Push stirrups upward until arms are extended overhead. Return stirrups to sides of shoulders and repeat.	Wrists maintain their approximate position above each elbow throughout movement.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE}	f	f
Cable Twisting Overhead Press	Stand beside low to medium height pulley. Grasp cable stirrup. Position stirrup to front of shoulder with elbow down to side. Place opposite hand on hip. With feet wide apart, squat down slightly.	Rotate body away from pulley and straighten legs while pushing stirrup diagonally upward toward opposite side of body. Return to original position and repeat.	Internal rotation of far hip (opposite side with resistance) is much greater than spinal rotation.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE}	f	f
Dumbbell Front Raise	Grasp dumbbells in both hands. Position dumbbells in front of upper legs with elbows straight or slightly bent.	Raise dumbbells forward and upward until upper arms are above horizontal. Lower and repeat.	Height of movement may depend on range of motion. Raise should be limited to height achieved just before tightness is felt in shoulder capsule. Alternatively, height just above horizontal may be considered adequate. Elbows may be kept straight or slightly bent throughout movement. Also see Dumbbell Alternating Front Raise.	{AUXILIARY}	{ISOLATED}	{PUSH}	{DUMBBELL}	f	f
Dumbbell Seated Front Raise	Sit on end of bench with dumbbell in each hand and legs together. Position dumbbells with palms facing inward and arms hanging down straight.	Raise dumbbells forward and upward while turning palms downward as soon as dumbbells clear thighs. Continue raising dumbbells until upper arms are above horizontal. Lower dumbbells and turn palms inward while dumbbells travels past thighs until arms are in original vertical position. Repeat.	Height of movement may depend on range of motion. Raise should be limited to height achieved just before tightness is felt in shoulder capsule. Alternatively, height just above horizontal may be considered adequate. Elbows may be kept straight or slightly bent throughout movement. Also see Dumbbell Alternating Seated Front Raise.	{AUXILIARY}	{ISOLATED}	{PUSH}	{DUMBBELL,BENCH}	f	f
Dumbbell Shoulder Press	Position dumbbells to each side of shoulders with elbows below wrists.	Press dumbbells upward until arms are extended overhead. Lower to sides of shoulders and repeat.	See suggested mount and dismount when using heavy dumbbells.	{BASIC}	{COMPOUND}	{PUSH}	{DUMBBELL}	f	f
Dumbbell One Arm Shoulder Press	Stand with dumbbells positioned near shoulder with elbow below wrists.	Press dumbbell upward until arm is extended overhead. Lower to side of shoulder and repeat.	Torso can lean away for balance as shown or torso can maintain upright posture. Also see Kettlebell Press.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{DUMBBELL,KETTLEBELL}	f	f
Dumbbell Reclined Shoulder Press	Position dumbbells to each side of shoulders with elbows below wrists. Lean back on back pad angled 70 to 80 degrees.	Press dumbbells upward until arms are extended overhead. Lower to sides of upper chest and repeat.	See suggested mount and dismount when using heavy dumbbells.	{BASIC}	{COMPOUND}	{PUSH}	{DUMBBELL}	f	f
Lever Reclined Shoulder Press	Lie on back pad facing up. Grasp lever handles to each side with overhand grip.	Press lever until arms are extended. Lower and repeat.	Range of motion will be compromised if grip is too wide.	{BASIC}	{COMPOUND}	{PUSH}	{LEVER}	f	f
Lever Reclined Parallel Grip Shoulder Press	Lie on back pad facing up. Grasp parallel lever handles on each side.	Press lever until arms are extended. Lower and repeat.	Range of motion will be compromised if grip is too wide.	{BASIC}	{COMPOUND}	{PUSH}	{LEVER}	f	f
Lever Shoulder Press	Set and grasp lever handles to each side with overhand grip.	Press lever upward until arms are extended overhead. Lower and repeat.	Range of motion will be compromised if grip is too wide.	{BASIC}	{COMPOUND}	{PUSH}	{LEVER}	f	f
Lever Alternating Shoulder Press	Set and grasp lever handles to each side with overhand grip.	Press one lever upward until arm is extended overhead. Lower to original position. Repeat with opposite arm. Continue by alternating movement between arms.	Range of motion will be compromised if grip is too wide.	{BASIC}	{COMPOUND}	{PUSH}	{LEVER}	f	f
Sled Shoulder Press	Set and grasp lever handles to each side with overhand grip.	Press handles upward until arms are extended overhead. Lower and repeat.	Range of motion will be compromised if grip is too wide.	{BASIC}	{COMPOUND}	{PUSH}	{LEVER,SLED}	f	f
Smith Behind Neck Press	Sit on bench with bar positioned behind shoulders. Grasp bar with wide overhand grip. Disengage bar by rotating bar back.	Press bar upward until arms are extended overhead. Lower bar behind neck and repeat.	Range of motion will be compromised if grip is too wide.	{BASIC}	{COMPOUND}	{PUSH}	{SMITH,BENCH}	f	f
Smith Shoulder Press	Sit on bench with bar positioned in front of shoulders. Grasp bar with wide overhand grip. Disengage bar by rotating bar back.	Press bar upward until arms are extended overhead. Lower bar to front of shoulders and repeat.	Pull head back slightly so bar does not make contact with head. Range of motion will be compromised if grip is too wide.	{BASIC}	{COMPOUND}	{PUSH}	{SMITH,BENCH}	f	f
Lever One Arm Front Raise	Stand with lever to side, fulcrum approximately shoulder height and handle just below hip. Grasp lever handle with elbow straight or slightly bent.	Raise lever handle forward and upward until upper arm is well above horizontal. Lower and repeat. Repeat with opposite arm.	Height of movement may depend on individual range of motion. Raise should be limited to height achieved just before tightness is felt in shoulder capsule. Alternatively, height just above horizontal may be considered adequate. Elbows may be kept straight or slightly bent throughout movement. Exercise is performed on Lever Extended Arm Lateral Raise Machine featuring long lever arms and handles attached to secondary levers as shown.	{AUXILIARY}	{ISOLATED}	{PUSH}	{LEVER}	f	f
Pike Press	Kneel on two benches positioned side by side slightly apart at end nearest head. Place hands on ends of benches. With forefeet on opposite ends of bench, raise rear end high up with arms, back, and knees straight. Adjust feet so they are somewhat close to hands while keeping back and legs straight.	Lower head between ends of benches by bending arms. Push body back up to original position by extending arms. Repeat.	Pike Press (for front delts) differs from Pike Push-up (for upper chest) in that, feet are at closer distance to hands so body is more inverted in lowest position. Keep knees and back straight. A slight curve (spinal flexion) is acceptable if hamstrings are tight.	{BASIC}	{COMPOUND}	{PUSH}	{BENCH}	t	f
Elevated Pike Press	Stand between two incline benches positioned side by side slightly apart at end nearest head. Place hands on ends of benches and straighten arms. Position forefeet on opposite ends of bench. Raise rear end high up with arms, back, and knees straight.	Lower head between ends of benches by bending arms. Push body back up to original position by extending arms. Repeat.	Keep knees and back straight. A slight curve (spinal flexion) is acceptable if hamstrings are tight.	{BASIC}	{COMPOUND}	{PUSH}	{BENCH}	t	f
Suspended Front Raise	Grasp suspension handles and momentarily step back until arms are extended forward and straight. While keeping arms straight and shoulders back, step forward so body reclines back behind suspension handles. Position body and legs straight at desired angle, hanging from handles with arms straight and palms facing downward.	Raise arms upward overhead by flexing shoulders with arms straight. Return and lower body back until arms are extended straight forward in original position. Repeat.	At higher angles, feet can be placed flat on floor. When angled further back, only heels may contact floor with forefeet raising upward. Dismounting can be achieved by walking backward until body is upright. This exercise can be performed on TRXⓇ style suspension trainer or adjustable length gymnastics rings.	{AUXILIARY}	{ISOLATED}	{PUSH}	{SUSPENSION}	t	f
Barbell Upright Row	Grasp bar with shoulder width or slightly narrower overhand grip.	Pull bar to neck with elbows leading. Allow wrists to flex as bar rises. Lower and repeat.	Bar can be recieved from barbell rack, standing behind bar mid-thigh height. See Upright Row Safety.	{BASIC}	{COMPOUND}	{PULL}	{BARBELL}	f	f
Barbell Wide Grip Upright Row	Grasp bar with wide overhand grip.	Pull bar to neck with elbows leading. Allow wrists to flex as bar rises. Lower and repeat.	Bar can be received from barbell rack, standing behind bar mid-thigh height. See Upright Row Safety.	{BASIC}	{COMPOUND}	{PULL}	{BARBELL}	f	f
Cable Lateral Raise	With low pulleys to each side, grasp left stirrup with right hand and right stirrup with left hand. Stand upright.	With elbows slightly bent, raise arms to sides until elbows are shoulder height. Lower and repeat.	Maintain fixed slightly bent elbow position throughout exercise. Stirrup is raised by shoulder abduction, not external rotation. Also see Cable Lateral Raise performed with pulleys very close together.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable One Arm Lateral Raise	Grasp stirrup cable attachment. Stand facing with side of resting arm toward low pulley. Grasp ballet bar if available.	With elbow slightly bent, raise arm to side away from low pulley until elbow is shoulder height. Lower and repeat.	Maintain fixed elbow position (10° to 30° angle) throughout exercise. Stirrup is raised by shoulder abduction, not external rotation.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable Seated Lateral Raise	Sit on seat above twin cable pulleys. Grasp stirrups on each side. Sit upright with arms nearly straight down to each side.	With elbows slightly bent, raise arms to side until elbows are shoulder height. Lower and repeat.	Maintain fixed slightly bent elbow position throughout exercise. At top of movement, elbows (not necessarily dumbbells) should be directly lateral to shoulders since elbows are slightly bent forward. Stirrup is raised by shoulder abduction, not external rotation. If elbows drop lower than wrists, front deltoids become primary mover instead of lateral deltoids.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL,CABLE}	f	f
Cable Upright Row	Grasp cable bar with shoulder width or slightly narrower overhand grip. Stand close to pulley.	Pull bar to neck with elbows leading. Allow wrists to flex as bar rises. Lower and repeat.	See Upright Row Safety.	{BASIC}	{COMPOUND}	{PULL}	{CABLE}	f	f
Cable Bar Upright Row	Grasp cable bar with shoulder width or slightly narrower overhand grip. Stand close to cable bar.	Pull bar to neck with elbows leading. Allow wrists to flex as bar rises. Lower and repeat.	Platform can be placed in front of feet to rest cable bar in between sets. See exercise performed with platform. Also see Upright Row Safety.	{BASIC}	{COMPOUND}	{PULL}	{CABLE}	f	f
Cable One Arm Upright Row	Grasp stirrup on low pulley with overhand grip. Stand with side of arm with stirup away from pulley machine, arm against front of body. Place other hand on ballet bar or side of pulley column for support.	Pull stirup to front side of shoulder with elbow leading. Allow wrist to flex as stirrup is lifted. Lower and repeat.	See Upright Row Safety.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{CABLE}	f	f
Cable Y Raise	Stand facing between low pulleys medium width apart, grasp left stirrup with right hand and right stirrup with left hand. Step back slightly away from pulleys and stand upright with cables crossed in front of hips.	With elbows slightly bent, raise arms upward and outward to sides in Y configuration until elbows are approximately lateral to each ear. Lower stirrups forward and downward in reverse pattern. Repeat.	Maintain fixed slightly bent elbow position throughout exercise. Stirrup is raised by combining shoulder abduction and flexion. Slight shoulder external rotation may occur with elbows bent. Front Deltoid assists shoulder flexion if upper arm angle is slightly high. Rear Deltoid assists shoulder horizontal abduction if upper arm angle is slightly low. Also see Cable Seated Y Raise on dual pulley Cable Row machine.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable Seated Y Raise	On dual pulley seated row machine, sit slightly forward on seat or bench in order to grasp both cable attachments. Place feet on vertical platform. Position torso upright and slide hips back so knees are slightly bent.	Raise arms upward and outward to sides in Y configuration while allowing elbows to partially bend. Pull back until elbows are approximately lateral to each ear. Lower stirrups forward and downward until arms are extended straight in front of body. Repeat.	Keep torso upright throughout exercise. Stirrup is raised by combining shoulder abduction and flexion. Slight shoulder external rotation may occur with elbows bent. Front Deltoid assists shoulder flexion if upper arm angle is slightly high. Rear Deltoid assists shoulder horizontal abduction if upper arm angle is slightly low. Also see Cable Seated Y Raise on single pulley machine with rope attachment.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE,BENCH}	f	f
Cable Wide Grip Upright Row	Grasp cable bar with wide overhand grip. Stand close to pulley.	Pull bar to neck with elbows leading. Allow wrists to flex as bar rises. Lower and repeat.	See Upright Row Safety. Also see side view.	{BASIC}	{COMPOUND}	{PULL}	{CABLE}	f	f
Dumbbell Incline Y Raise	With dumbbells in each hand, lie prone on 45° Incline bench with head over top of bench and arms extended down to each side.	With elbows slightly bent, raise arms with dumbbells upward and outward to sides in Y configuration until elbows are approximately lateral to each ear. Lower dumbbells in reverse pattern until they are below shoulders and repeat.	Maintain fixed slightly bent elbow position throughout exercise. Arms with dumbbells are raised by combining shoulder abduction and flexion. Slight shoulder external rotation may occur with elbows bent. Front Deltoid assists shoulder flexion if upper arm angle is slightly high. Rear Deltoid assists shoulder horizontal abduction if upper arm angle is slightly low.	{AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL,BENCH}	f	f
Dumbbell One Arm Lateral Raise	Position dumbbell in front of pelvis with elbow slightly bent. Grasp stationary object with other hand for support. Bend over with hips and knees bent slightly.	Raise upper arm to side until slightly bent elbow is shoulder height while maintaining elbow's height above or equal to wrist. Lower and repeat.	Maintain fixed elbow position (10° to 30° angle) throughout exercise. At top of movement, elbow (not necessarily dumbbell) should be directly lateral to shoulder since elbow is slightly bent forward. Dumbbell is raised by shoulder abduction, not external rotation. As elbow drops lower than wrist, front deltoid become primary mover instead of lateral deltoid. See Lateral Raise Errors.	{AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL}	f	f
Dumbbell One Arm Seated Lateral Raise	Sit on stool or end of bench with legs together. Position dumbbell to side with elbow slightly bent. Angle torso slightly forward and place free hand on end of thigh for support.	Raise upper arm to side until slightly bent elbow is shoulder height while maintaining elbow's height above or equal to wrist. Lower and repeat.	Maintain fixed elbow position (10° to 30° angle) throughout exercise. At top of movement, elbow (not necessarily dumbbell) should be directly lateral to shoulder since elbow is slightly bent forward. Dumbbell is raised by shoulder abduction, not external rotation. As elbow drops lower than wrist, front deltoid becomes primary mover instead of lateral deltoid. See Lateral Raise Errors.	{AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL,BENCH}	f	f
Lever Lateral Raise	Sit in machine. Situate bent arms between padded lever and sides of body. Grasp handles if available.	Raise arms to sides until upper arms are horizontal. Return and repeat.	Also see alternative machine.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Lever Extended Arm Lateral Raise	Stand facing machine and grasp lever handles to each side with elbows straight or slightly bent.	Raise lever handles to sides until elbows are shoulder height. Maintain elbows' height above or equal to wrists. Lower and repeat.	If elbows drop much lower than wrists, front deltoids become primary mover instead of lateral deltoids. Torso can also lean forward slightly to keep resistance targeted to side delt.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Smith Upright Row	Stand behind bar mid-thigh height. Grasp bar with shoulder width or slightly narrower overhand grip. Disengage bar by rotating bar back and stand upright.	Pull bar to neck with elbows leading. Allow wrists to flex as bar rises. Lower and repeat.	See Upright Row Safety.	{BASIC}	{COMPOUND}	{PULL}	{SMITH}	f	f
Smith Wide Grip Upright Row	Stand behind bar mid-thigh height. Grasp bar with wide grip overhand grip. Disengage bar by rotating bar back and stand upright.	Pull bar to neck with elbows leading. Allow wrists to flex as bar rises. Lower and repeat.	See Upright Row Safety.	{BASIC}	{COMPOUND}	{PULL}	{SMITH}	f	f
Suspended Y Lateral Raise	Grasp suspension handles and momentarily step back until arms are extended forward and straight. While keeping arms straight and shoulders back, step forward so body reclines back behind suspension handles. Position body and legs straight at desired angle hanging from handles with arms straight and palms angled inward.	Raise arms upward and outward in shape of a Y while keeping arms straight. Return and lower body back in opposite motion until arms are extended straight forward in original position. Repeat.	At higher angles, feet can be placed flat on floor. When angled further back, only heels may contact forefeet floor with forefeet raising upward. Dismounting can be achieved by walking backward until body is upright. This exercise can be performed on TRXⓇ style suspension trainer or adjustable length gymnastics rings.	{AUXILIARY}	{ISOLATED}	{PULL}	{SUSPENSION}	t	f
Dumbbell Lying Lateral Raise	Lie on side with legs separated for support. Grasp dumbbell in front of thigh.	Raise dumbbell from floor until arm is vertical. Maintain fixed elbow position (10° to 30° angle) throughout exercise. Lower and repeat.	Dumbbell is raised by shoulder abduction, not external rotation.	{AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL}	f	f
Dumbbell Raise	Stand and grasp dumbbells with arms to side, palms facing sides of thighs.	Pull dumbbells up to sides of ribs with elbows out to sides. Lower and repeat.	When dumbbells are raised, wrist can be flexed, extended, or keep neutral.	{BASIC}	{COMPOUND}	{PULL}	{DUMBBELL}	f	f
Dumbbell Upright Row	Grasp dumbbells and stand with palms facing front of thighs.	Pull dumbbells to front of shoulder with elbows leading out to sides. Allow wrists to flex as dumbbells rise upward. Lower and repeat.	When dumbbells are raised, wrists should be in front or just below of shoulders; elbows should be to sides, not pointing forward. See Upright Row Safety.	{BASIC}	{COMPOUND}	{PULL}	{DUMBBELL}	f	f
Dumbbell One Arm Upright Row	Grasp dumbbells with palms facing front of thighs. Position other hand for support.	Pull dumbbell to front of shoulder with elbow leading. Allow wrist to flex as dumbbell rises upward. Lower and repeat. Continue with opposite arm.	See Upright Row Safety. Also see Seated Upright Row.	{BASIC}	{COMPOUND}	{PULL}	{DUMBBELL}	f	f
Dumbbell Seated Upright Row	Sit on end of bench with legs far apart. Grasp dumbbell between legs with arm vertical under shoulder. Position torso slightly forward with hand on knee for support.	Pull dumbbell to front of shoulder with elbow leading out to side. Allow wrists to flex as dumbbell rises upward. Lower and repeat.	When dumbbell is raised, wrist should be in front or just below of shoulder; elbow should be to side, not too pointing forward. See Upright Row Safety. Also see Dumbbell One Arm Upright Row in standing position.	{BASIC}	{COMPOUND}	{PULL}	{DUMBBELL,BENCH}	f	f
Barbell Rear Delt Row	Bend knees slightly and bend over bar with back straight, approximately horizontal. Grasp bar with wide overhand grip.	Keeping upper arm perpendicular to torso, pull barbell up toward upper chest until upper arms are just beyond horizontal. Return and repeat.	If upper arm travels closer than perpendicular to trunk, latissimus dorsi becomes involved. Elbows should be raised directly lateral to shoulders. Positioning torso at 45° is not sufficient angle to target rear deltoids. Keep torso bent over approximately horizontal. Knees are bent in effort to keep low back straight (See Hamstring Inflexibility). If low back becomes rounded due to tight hamstrings, either knees should be bent more or torso may not be positioned as low. If low back is rounded due to poor form, deadlift weight to standing position and lower torso into horizontal position with knees bent and back straight. Much lighter resistance is required as Barbell Bent-over Row.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{BARBELL}	f	f
Barbell Lying Rear Delt Row	Lie chest down on elevated bench. Grasp bar with wide overhand grip.	Keeping upper arm perpendicular to torso, pull barbell up toward upper chest until upper arms are just beyond parallel to floor. Return and repeat.	If upper arm travels closer than perpendicular to trunk, latissimus dorsi becomes involved. Elbows should be raised directly lateral to shoulders. Bench should be just high enough to prevent barbell from hitting floor and close to horizontal. Lying at 45° is not sufficient angle to target rear deltoids. Much lighter resistance is required as Cambered Bar Lying Row.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{BARBELL,BENCH}	f	f
Cable Seated Reverse Fly	Sit on seat facing twin pulley cables positioned approximately shoulder height. Grasp stirrup cable attachment in each hand. Straighten lower back upright so cable is taut. Point elbows outward with arms slightly bent.	Keeping elbows pointed high, pull stirrups out to sides, maintaining slightly bent elbow position throughout exercise. Return to original position and repeat.	Upper arms should travel in horizontal path at shoulder height (not downward) to minimize Latissimus Dorsi involvement.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable One Arm Reverse Fly	Stand with side to shoulder height cable pulley. Grasp stirrup cable attachment with hand furthest from pulley. Position arm across neck with elbow bent 30° to 45° outward.	Keeping elbows pointed high, pull stirrup out to side, maintaining fixed elbow position throughout exercise. Return to original position and repeat. Repeat with other arm.	Upper arm should travel in horizontal path at shoulder height (not downward) to minimize Latissimus Dorsi involvement.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable Reverse Fly	Stand facing twin pulley cables positioned close together and approximately shoulder height. Grasp stirrup cable attachment in each hand. Step back away from machine so cable is taut. Stand with feet staggered. Point elbows outward with arms straight or slightly bent.	Pull stirrups out to sides, maintaining stiff elbow position throughout exercise. Return to original position and repeat.	Upper arms should travel in horizontal path at shoulder height (not downward) to minimize Latissimus Dorsi involvement.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable Rear Delt Row	Sit slightly forward on bench or platform in order to grasp cable bar attachment. With elbow width overhand grip, straighten torso upright and slide hips back until knees are only slightly bent.	Pull cable attachment toward upper chest, just below neck, with elbows up out to sides until elbows travel slightly behind back. Keep upper arms horizontal, perpendicular to trunk. Return until arms are extended and shoulders are stretched forward. Repeat.	Elbow width is determined when elbows are raised at height of shoulders out to sides. The relatively powerful Latissimus Dorsi becomes involved:	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{CABLE,BENCH}	f	f
Cable One Arm Rear Delt Row	Sit slightly forward on bench or platform in order to grasp stirrup cable attachment with one hand. Straighten torso upright and slide hips back until knees are only slightly bent. Point elbow out to side.		The relatively powerful Latissimus Dorsi becomes involved:	{AUXILIARY}	{COMPOUND}	{PULL}	{CABLE,BENCH}	f	f
Cable Rear Lateral Raise	Stand with cable columns to each side. Grasp left stirrup with right hand and right stirrup with left hand. Bend knees and bend over at hips, so torso is approximately horizontal with back straight. Point elbows outward with arms slightly bent.	Raise upper arms to sides until elbows are shoulder height. Maintain upper arms perpendicular to torso and slight bend in elbows as arms are raised to sides. Lower and repeat.	Upper arm should travel perpendicular to torso to minimize latissimus dorsi involvement. Elbows may bend slightly at bottom of movement (as shown) or they may be kept fixed. If low back cannot be kept straight due to inflexibility of hamstrings, try keeping knees bent more.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable One Arm Rear Lateral Raise	Stand with side to low pulley. Grasp stirrup attachment with hand furthest from pulley. Bend knees slightly and bend over with resting arm to side of low pulley.	Raise arm to side until elbow is shoulder height. Maintain upper arm perpendicular to torso and fixed elbow position (10° to 30° angle) throughout exercise. Lower and repeat. Repeat with other arm.	Upper arm should travel in perpendicular path to torso to minimize Latissimus Dorsi involvement.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable Seated Rear Lateral Raise	Sit at edge of bench with feet of floor ahead of knees. Rest torso on thighs. Reach under legs and grasp stirrup cable attachments, right hand holding left stirrup, left hand holding right stirrup.	Pull stirrups out to sides until elbows are shoulder height. Maintain upper arms perpendicular to torso and fixed elbow position (10° to 30° angle) throughout exercise. Lower until arms contact sides of legs. Repeat.	Upper arm should travel in perpendicular path to torso to minimize Latissimus Dorsi involvement. If stirrups are not within reach, training partner can hand exercises cable attachments.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE,BENCH}	f	f
Cable One Arm Standing Cross Row	Facing shoulder height cable pulley, grasp stirrup cable attachment with one hand, palm orientated down. Step back and turn body inward about 30° to 45° to face extended arm about. Stand back just enough to allow arm to be fully extended with weight raised up slightly.	Pull stirrup back with elbow up at shoulder height until elbow travels just behind shoulder. Keep upper arm horizontal, perpendicular to trunk. Return until arm is fully extended. Repeat.	The relatively powerful Latissimus Dorsi becomes involved:	{AUXILIARY}	{COMPOUND}	{PULL}	{CABLE}	f	f
Dumbbell Rear Lateral Raise	Grasp dumbbells to each side. Bend knees and bend over through hips with back flat, close to horizontal. Position elbows with slight bend and palms facing together.	Raise upper arms to sides until elbows are shoulder height. Maintain upper arms perpendicular to torso and fixed elbow position (10° to 30° angle) throughout exercise. Maintain height of elbows above wrists by raising "pinkie finger" side up. Lower and repeat.	Dumbbells are raised by shoulder transverse abduction, not external rotation, nor extension. Upper arm should travel in perpendicular path to torso to minimize relatively powerful latissimus dorsi involvement. In other words, at top of movement, elbows (not necessarily dumbbells) should be directly lateral to shoulders since elbows are slightly bent forward.	{AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL}	f	f
Dumbbell Rear Delt Row	Kneel over side of bench with arm and leg to side. Grasp dumbbell.	Pull dumbbell up out to side with upper arm perpendicular to trunk until upper arm is just beyond horizontal. Lower and repeat.	If upper arm travels closer than perpendicular to trunk, latissimus dorsi becomes involved. Elbow should be raised dire ctly lateral to shoulder. Positioning torso at 45° is not sufficient angle to target rear deltoids. Keep torso bent over approximately horizontal. See side view of Dumbbell Rear Delt Row. Much lighter resistance is required as Dumbbell Bent-over Row.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{DUMBBELL,BENCH}	f	f
Cable Standing Cross Row	Stand between two shoulder-high cable pulleys (adjustable cross-over machine). Grasp right stirrup with left hand and left stirrup with right hand. Step back until cables are angled back 30° to 45°. Position both elbows at height of shoulders, one over other.	Pull both cable attachments by moving elbows back to sides. Keep upper arms horizontal, perpendicular to trunk. Return and repeat.	Latissimus Dorsi becomes involved if elbows drop below shoulders.	{AUXILIARY}	{COMPOUND}	{PULL}	{CABLE}	f	f
Smith Rear Delt Row	Stand near low smith bar. Bend knees and bend over bar with back straight. Grasp bar with wide overhand grip. Disengage bar by rotating bar back.	Keeping upper arm perpendicular to torso, pull bar up toward upper chest until upper arms are just beyond parallel to floor. Return and repeat.	If upper arm travels closer than perpendicular to trunk, latissimus dorsi becomes involved. Elbows should be raised directly lateral to shoulders. Positioning torso at 45° is not sufficient angle to target rear deltoids. Keep torso bent over approximately horizontal. Knees are bent in effort to keep low back straight (See Hamstring Inflexibility).	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{SMITH}	f	f
Rear Delt Inverted Row	Stand facing horizontal bar positioned waist to lower chest height. Grasp bar with wide overhand grip. Step back until arms are straight. Walk forward under bar until arms are perpendicular to extended body. With heels on floor, position body at angle under bar with legs, hips and spine straight.	Pull shoulders toward bar while keeping body straight, elbows to sides of shoulders, and upper arms perpendicular to torso, until upper arms are parallel to one another, or just beyond. Lower body while keeping elbows positioned high to sides of shoulders until arms are extended straight. Repeat.	If elbows fall so upper arms no longer travel perpendicular to trunk, Latissimus Dorsi becomes involved. Elbows should be positioned directly lateral to shoulders at highest position. Pulling bar to lower chest is not sufficient angle to target rear deltoids. A higher bar (ie: lighter resistance) is required than what is required on Inverted Row. Bar height can be adjusted to vary resistance. See Gravity Vectors for greater understanding of how body angle influences resistance. Also known as Body Row or Supine Row.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{}	t	f
Lever Rear Lateral Raise	Stand on platform facing lateral raise machine. Bend knees and bend over at hips with back flat close to horizontal. With elbows bent under shoulders, position back of upper arms against arm pads.	Maintaining torso position, raise upper arms to sides until elbows are shoulder height. Lower and repeat.	Platform height should allow pivot point of shoulders to be aligned with lever fulcrum. Upper arm should travel in perpendicular path to torso. At lower portion of exercise, keep elbows pointed outward below shoulders. At upper portion of exercise, keep elbows pointed outward to sides of shoulders. Knees are bent in effort to keep low back straight (See Hamstring Inflexibility).	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Lever Seated Rear Delt Row	Place seat at low position. Sit on seat with chest against pad and grasp upper handles.	Pull lever with elbows up out to sides until upper arms are just beyond parallel, keeping upper arm horizontal, perpendicular to torso. Return and repeat.	If upper arm travels closer than perpendicular to trunk, latissimus dorsi becomes involved. Elbows should be kept same height as shoulders. Also see exercise performed on alternative lever row machine. Much lighter resistance is required as compared to Lever Seated Row.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{LEVER}	f	f
Lever Seated Reverse Fly (parallel grip)	Sit on machine with chest against pad. Grasp parallel handles with thumbs up at shoulder height. Slightly bend elbows and internally rotate shoulders so elbows are also at height of shoulders.	Keeping elbows pointed high, pull handles apart and to rear until elbows are just behind back. Return and repeat.	Keep elbows raised at same height of shoulders to minimize Latissimus Dorsi involvement. Thumbs down grip may be used so shoulders more naturally assume height of shoulders. Some machines allow for a more neutral overhand grip.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Lever Seated Reverse Fly (on pec deck)	Sit on machine with chest against vertical pad. Position arms against padded lever arms at height of shoulders.	Pull arms back until elbows are beyond back. Return and repeat.	Can be performed on certain pec deck machines as shown if their range of motion and design are adequate, although Gripless Lever Seated Reverse Fly machine is typically better suited for this exercise.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Lever Seated Reverse Fly (overhand grip)	Sit on machine with chest against pad. Grasp horizontal handles with overhand grip at shoulder height. Internally rotate shoulders so elbows are also at height of shoulders.	Keeping elbows pointed high, pull handles apart and to rear until elbows are just behind back Return and repeat.	Keep elbows raised at same height of shoulders to minimize Latissimus Dorsi involvement. Exercise can also be performed with parallel grip, either with thumbs up or thumbs down positioning.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Lever Seated Reverse Fly (pronated parallel grip)	Sit in machine with chest against pad. Grasp parallel handles from inside with thumbs down at shoulder height.	Keeping elbows pointed high, pull handles apart and to rear until elbows are just behind back. Return and repeat.	Pronated grip will internally rotate shoulders so elbows are kept at height of shoulders. Preventing elbows from dropping below shoulders will minimize Latissimus Dorsi involvement. With thumbs down grip, shoulder must be deliberately internally rotated to keep elbow at proper height. Some machines allow for a more neutral overhand grip.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Suspended Rear Delt Row	Grasp suspension handles and momentarily step back until arms are extended forward and straight. While keeping arms straight and shoulders back, step forward so body reclines back behind suspension handles.\nPosition body and legs straight at desired angle hanging from handles with arms straight. Internally rotate shoulders so elbows are positioned directly outwards.	Pull body up while keeping elbows pointed directly out to each side and body and legs straight. Pull until elbows are directly lateral to each side without allowing elbows to drop. Return until arms are extended straight and shoulders are stretched forward, maintaining high elbow position. Repeat.	If elbows fall so upper arms no longer travels perpendicular to trunk, Latissimus Dorsi becomes involved. Elbows should be positioned directly lateral to shoulders at highest position throughout movement. Executing exercise with elbows dropping lower than shoulders is not sufficient position to target rear deltoids. A more upright position (ie: lighter resistance) is required than what is used on Suspended Row for General Back. Dismounting can be achieved by walking backward until body is upright.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{SUSPENSION}	t	f
Suspended Reverse Fly	Grasp suspension handles and momentarily step back until arms are extended forward and straight. While keeping arms straight and shoulders back, step forward so body reclines back behind suspension handles. Position body and legs straight at desired angle hanging from handles with arms straight. Internally rotate shoulders so elbows are positioned directly outwards with arms straight or slightly bent. Shoulder should be positioned approximately 90° relative to torso position.	Pull handles out to sides while keeping stiff elbow position and maintaining shoulder at 90° plane to torso throughout exercise. Raise up until upper arms are in-line to one another. Return to original position in same plane and repeat.	Upper arms should travel in transverse path at shoulder level without allowing elbows to drop to minimize Latissimus Dorsi involvement. A very upright position (ie: very light resistance) with one foot positioned slightly back (see 'Easier') is typically required for proper execution. Take care to maintain tension on suspension trainer near top of movement. Dismounting can be achieved by walking backward until body is upright or stepping out at top of movement. This exercise can be performed on TRXⓇ style suspension trainer or adjustable length gymnastics rings.	{AUXILIARY}	{COMPOUND}	{PULL}	{SUSPENSION}	t	f
Cable Front Lateral Raise	Grasp dumbbell cable attachment. Stand facing side with resting arm toward low pulley. Grasp ballet bar if available for support. Internally rotate shoulders so elbows point out to sides.	With elbow straight or slightly bent, raise upper arm away from low pulley to side, slightly to front (30°) until upper arm is shoulder height. Lower and repeat. Continue with opposite arm.	Maintain straight or nearly straight elbow position with elbows pointing outward throughout exercise. If low pulley is fixed, turn slightly away from low pulley.	{AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL,CABLE}	f	f
Cable Seated Front Lateral Raise	Sit on seat above twin cable pulleys. Grasp stirrups on each side. Sit upright with arms nearly straight down to each side. Internally rotate shoulders so elbows point out to sides.	With elbows straight or slightly bent, raise upper arm away from low pulley to side, slightly to front (30° to 45°) until upper arm is shoulder height or slightly higher. Lower and repeat.	Maintain straight or nearly straight elbow position with elbows pointing outward throughout exercise.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Barbell Squat	From rack with barbell at upper chest height, position bar high on back of shoulders and grasp barbell to sides. Dismount bar from rack and stand with shoulder width stance.	Squat down by bending hips back while allowing knees to bend forward, keeping back straight and knees pointed same direction as feet. Descend until thighs are just past parallel to floor. Extend knees and hips until legs are straight. Return and repeat.	Keep head facing forward, back straight and feet flat on floor; equal distribution of weight throughout forefoot and heel. Knees should point same direction as feet throughout movement. See:	{BASIC}	{COMPOUND}	{PUSH}	{BARBELL}	f	f
Cable Standing Leg Extension	Stand facing away from low pulley. Place foot in cable boot attachment (as shown) or foot harness. Grasp lateral bars or other prop for support. Stand forward on free leg. Raise knee up positioning thigh approximately 45° forward. Allow lower leg attached to cable to be pulled back.	Keeping thigh stationary, extend lower leg forward until leg is straight. Return by lowering lower leg down and back to original position. Repeat.	Those with hamstring inflexibility may have difficulty fully extending knee if knee is too high. In which case, knee can be raised forward less than 45°. Pectineus, Adductor Longus, Adductor Brevis do not contribute to hip stabilization since they are only involved in initial range of hip flexion.	{AUXILIARY}	{ISOLATED}	{PUSH}	{CABLE}	f	f
Cable Step Down	Grasp cable stirrup(s) with both hands. Place one foot on elevated platform positioned near or between low pulleys.	Raise body by extending knee and hip on platform until leg is straight. Return until foot of lower leg makes contact with lower platform or floor and repeat. Continue with opposite leg.	Keep lower leg straight throughout movement. Forward knee should point same direction as foot throughout movement. Instead of grasping cable stirrups, dip belt attached to low pulley cable can be placed around waist.	{AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE}	f	f
Cable Belt Half Squat	Place cable belt or dip belt around waist. Kneel before low pulley and attach it to cable. Stand on elevated platform with feet shoulder width or slightly wider on platform between very low and close pulley cables. Place hand(s) on ballet bar or machine (not on guide rod!) for balance.	Squat down by bending hips back while allowing knees to bend forward, keeping back straight and knees pointed same direction as feet. Descend until weight stack taps or comes very close from making contact. Keeping chest high and back straight, raise back up by extending knees and hips until legs are straight. Repeat.	More or less 3/4 squat depth can be achieved depending upon exerciser's height, chain length on dip belt, and height of elevated platform. If greater depth can be achieved, descend as low as thighs being parallel to floor. Keep head facing forward, back straight, chest high, arms straight to sides, and feet flat on platform; equal distribution of weight through forefoot and heel. Knees should point same direction as feet throughout movement. See Squat Analysis.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{CABLE}	f	f
Dumbbell Seated Front Lateral Raise	Sit on stool or end of bench with dumbbell. Position dumbbell down to side with arm straight. Turn pinkie finger side outward.	Raise arms to side, slightly in front until shoulder height or slightly higher. Lower and repeat. Continue with opposite arm.	Raise toward 10 o'clock with left arm and toward 2 o'clock with right arm. Maintain straight elbow position with elbow pointing outward throughout exercise.	{AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL,BENCH}	f	f
Sled Squat	Position shoulders under padded bars. Place feet shoulder width apart directly under shoulders. Disengage lever brace if available.	Squat down by bending hips back while allowing knees to bend forward, keeping back straight and knees pointed same direction as feet. Descend until thighs are just past parallel to floor. Raise sled by extending knees and hips until legs are straight. Return and repeat.	Re-engage support lever in extended position before dismounting. Keep head facing forward, back straight and feet flat on floor; equal distribution of weight through forefoot and heel. Knees should point same direction as feet throughout movement. See Squat Analysis.	{BASIC}	{COMPOUND}	{PUSH}	{LEVER,SLED}	f	f
Smith Step Down	Position smith bar upper chest height with platform under bar off to one side. Positioned shoulders under bar and one foot on platform with other leg extended slightly forward on floor.	Raise bar upward by straightening leg and pushing body upward. Lower body downward by returning foot off of bench to floor and repeat. Continue with opposite position.	Keep torso upright and foot flat on platform during exercise. Knee of exercised leg should point same direction as foot. Extended leg can be positioned slight forward.	{AUXILIARY}	{COMPOUND}	{PUSH}	{SMITH,BENCH}	f	f
Barbell Good-morning	Position barbell on back of shoulders and grasp bar to sides.	Keeping back straight, bend hips to lower torso forward until parallel to floor. Raise torso until hips are extended. Repeat.	Begin with very light weight and add additional weight gradually to allow adequate adaptation. Throughout lift, keep back and knees straight. Do not lower weight beyond mild stretch through hamstrings. Full range of motion will vary from person to person depending on flexibility. Also see Bent Knee Goodmorning emphasizing Glutes.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{BARBELL}	f	f
Barbell Glute-Ham Raise	Place ankles between ankle roller pads with feet on vertical platform and position knees on pad with lower thighs against large padded hump. If barbell can safely be placed on horizontal handles, grasp barbell in upright position and place behind shoulders. If barbell is placed on floor, lower torso by extending knees and flexing hips, then position barbell on back of shoulders. Grasp bar to sides.	From lower position, raise torso by extending hips until fully extended. Continue to raise body by flexing knees until body is upright. Lower body by straightening knees until body is horizontal. Continue to lower torso by bending hips until body is upside down. Repeat.	Exercise can be performed without added weight until more resistance is needed.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{BARBELL}	f	f
Barbell Straight Leg Deadlift (Romanian)	Stand with shoulder width or narrower stance on shallow platform with feet flat beneath bar. Bend knees and bend over with lower back straight. Grasp barbell with shoulder width overhand or mixed grip, shoulder width or slightly wider. Lift weight to standing position.	With knees straight, lower bar toward top of feet by bending hips and waist. Lift bar by extending waist and hip until standing upright. Pull shoulders back slightly if rounded. Repeat.	Begin with very light weight and add additional weight gradually to allow lower back adequate adaptation. Throughout lift keep arms and knees straight. Keep bar over top of feet, close to legs. Do not pause or bounce at bottom of lift. Do not lower weight beyond mild stretch throughout hamstrings and low back. Full range of motion will vary from person to person.	{BASIC}	{COMPOUND}	{PULL}	{BARBELL}	f	f
Cable Bent-over Leg Curl	Attach ankle cuff to low pulley. With cuff on one ankle, grasp ballet bar with both hands and step far back with other foot. Elbows remain straight to support body leaning forward. Attached foot is stretched off floor.	Pull cable attachment back and up slightly by flexing knee. Raise knee slightly by flexing hip until knee is fully flexed. Return by straightening knee and lowering knee slightly to original position. Repeat. Continue with opposite leg.	Raise knee very slightly as knee is flexing and return as weight is lowered. Keep hip from sagging or from being pulled forward. Heavier resistances can tear apart standard leather ankle cuffs.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{CABLE}	f	f
Cable Lying Leg Curl	Attach two ankle cuffs to low pulley attachment. With cuffs on both ankles lie prone on flat bench with knees just beyond edge of bench. Grip under side or base of bench for support.	Raise ankles to glutes by flexing knees. Lower ankles until knees are straight. Repeat.	Keep torso on bench to reduce hyperextension of lower back. Dorsal flexion of ankle reduces active insufficiency of Gastrocnemius allowing it to assist in knee flexion.	{BASIC}	{ISOLATED}	{PULL}	{CABLE,BENCH}	f	f
Cable Standing Leg Curl	Attach foot harness to low pulley. With foot harness on one ankle, grasp support bar with both hands and step back with other foot. Elbows remain straight to support body. Attached foot is slightly off floor.	Pull cable attachment back by flexing knee until knee is fully flexed. Return by straightening knee to original position and repeat. Continue with opposite leg.	Keep hip from sagging or from being pulled forward. Dorsal flexion of ankle reduces active insufficiency of Gastrocnemius allowing it to assist in knee flexion. Also see Cable Bent-over Leg Curl.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{CABLE}	f	f
Trap Bar Straight Leg Deadlift (Romanian)	Stand on platform under loaded trap bar. Squat down and grasp handles to sides. Squat / Deadlift bar up to standing position.	With knees straight, lower bar down by bending hips. After hips can no longer flex, bend waist as weights approach floor. Hands should be lowered near sides of ankles. Set weight on floor. Lift bar by extending waist and hip until standing upright. Pull shoulders back slightly if rounded. Repeat.	Not all trap bar designs may allow for this movement. A squared open-ended trap bar is used in this demonstration. Begin with very light weight and add additional weight gradually to allow lower back adequate adaptation. Throughout lift, keep arms and knees straight.	{BASIC}	{COMPOUND}	{PULL}	{TRAP_BAR}	f	f
Cable Straight Leg Deadlift (Romanian)	Stand between two very low pulleys with shoulder width or narrower stance. Squat down and grasp stirrup attachments to each side. Stand upright with arms straight down to sides.	With knees straight, bow forward by bending hips. Bend waist as stirrups approach lowest position. Lift dumbbells by extending hips and waist until standing upright. Pull shoulders back slightly if rounded. Repeat.	Begin with very light weight and add additional weight gradually to allow lower back adequate adaptation. Throughout lift, keep arms and knees straight. Do not stand behind pulleys. Do not pause or bounce at bottom of lift. Lower back may bend slightly during full hip flexion phase. Do not lower weight beyond mild stretch throughout hamstrings and low back. Full range of motion will vary from person to person depending on flexibility. See Dangerous Exercise Essay. Also see Straight Back Straight Leg Deadlift.	{BASIC}	{COMPOUND}	{PULL}	{CABLE}	f	f
Lever Straight-leg Lying Hip Extension	Lie on bench and place back of lower legs against leg pad. Position hips in line with fulcrum. Grasp bottom sides of bench to keep body from moving under resistance.	With knees straight, extend lever downward until hips are extended. Return lever to upright position without allowing back of hips to raise up off of bench. Repeat.	Throughout lift, knees straight and back of hips on bench. Hip may tend to raise up when legs are pulled up. Full range of motion will vary from person to person depending on flexibility.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER,BENCH}	f	f
Smith Good-morning	Position bar on back of shoulders. Grasp bar to sides. Disengage bar by rotating bar back.	Bend hips to lower torso forward until parallel to floor. Raise torso until hips are extended. Repeat.	Begin with very light weight and add additional weight gradually to allow adequate adaptation. Throughout lift, keep back and knees straight. At lower position, forefoot may raise off floor slightly. Do not lower weight beyond mild stretch. Full range of motion will vary from person to person depending on flexibility. Also see Bent Knee Goodmorning emphasizing Glutes.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{SMITH}	f	f
Lever Bent-over Leg Curl	Stand in machine with lower pads behind lower legs, upper pads in front of thighs, and lever fulcrum between knees. Bend over, placing forearms on pads, and grasp handles. Stand with body weight shifted on foot of resting leg and raise foot of exercising leg slightly off of floor or platform.	Raise lever up by bending knee as high as possible. Return lever until knee is straight. Repeat. Continue with opposite leg.	The bent-over posture decreases active insufficiency of three of four heads of hamstring at completion of knee flexion. Dorsal flexion of ankle reduces active insufficiency of Gastrocnemius allowing it to assist in knee flexion. This exercise is variation of Standing Leg Curl but is similar biomechanically to Kneeling Leg Curl.	{BASIC}	{ISOLATED}	{PULL}	{LEVER}	f	f
Lever Alternating Bent-over Leg Curl	Stand in machine with lower pads behind lower legs, upper pads in front of thighs, and lever fulcrum between knees. Bend over, placing forearms on pads, and grasp handles.	Raise left foot slightly off of floor or platform. Raise lever up with left leg, bending knee as high as possible. Return lever until knee is straight. Shift body weight to left foot and raise right foot slightly off of floor or platform. Raise lever up with right leg, bending knee as high as possible. Continue alternating movement between legs.	The bent-over posture decreases active insufficiency of three of four heads of hamstring at completion of knee flexion. Dorsal flexion of ankle reduces active insufficiency of Gastrocnemius allowing it to assist in knee flexion.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Lever Kneeling Leg Curl	Mount machine by placing supporting knee on horizontal pad and other leg under roller pad with knee against vertical pad. Grip handles and place forearm on padded arm rest.	Raise ankle to back of thigh by flexing knee. Lower ankle until knee is straight. Repeat. Continue with opposite leg.	Dorsal flexion of ankle reduces active insufficiency of Gastrocnemius allowing it to assist in knee flexion.	{BASIC}	{ISOLATED}	{PULL}	{LEVER}	f	f
Lever Lying Leg Curl	Facing bench, stand between bench and lever pads. Lie prone on bench with knees just beyond edge of bench and lower legs under lever pads. Grasp handles.	Raise lever pad to back of thighs by flexing knees. Lower lever pads until knees are straight. Repeat.	Keep torso on bench to reduce hyperextension of lower back. Most machines are angled at user's hip to position hamstring in more favorable mechanical position. If this angle is sharp (as shown), Rectus Femoris is less likely involved as Antagonist Stabilizer. Dorsal flexion of ankle reduces active insufficiency of Gastrocnemius allowing it to assist in knee flexion. See Knee flexion abduction force vector diagram.	{BASIC}	{ISOLATED}	{PULL}	{LEVER,BENCH}	f	f
Lever Alternating Lying Leg Curl	Facing bench, stand between bench and lever pads. Lie prone on bench with knees just beyond edge of bench and lower legs under lever pads. Grasp handles.	Raise lever pad to back of thighs by flexing one knee. Lower lever pads until knee is straight and repeat with opposite leg. Continue to alternate between sides.	Keep torso on bench to reduce hyperextension of lower back. Most machines are angled at user's hip to position hamstring in more favorable mechanical position. If angle is at much greater angle than one illustrated, Rectus Femoris will less likely be involved as Antagonist Stabilizer. Dorsal flexion of ankle reduces active insufficiency of Gastrocnemius allowing it to assist in knee flexion. See Knee flexion abduction force vector diagram.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{LEVER,BENCH}	f	f
Lever Single Leg Seated Leg Curl	Sit on seat with back against padded back support. Position back of lower leg on top of far padded lever and other leg bent over lap pad. Secure lap pad against thigh just above knee. Grasp handles on lap support.	Pull far padded lever toward back of thighs as far as possible by flexing knee. Return padded lever until knee is straight. Change legs and repeat for opposite leg.	Position back of seat so knee is aligned with fulcrum of lever. Position lever pad so it makes contact with lower leg just above ankle. Place leg closest to lever in/on machine first, followed by further leg. Keep resting leg down throughout exercise as not to interfere with movement of lever. Dorsal flexion of ankle reduces active insufficiency of Gastrocnemius allowing it to assist in knee flexion.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Glute-Ham Raise (hands behind neck)		From upright position, lower body by straightening knees until body is horizontal. Continue to lower torso by bending hips until body is upside down. Raise torso by extending hips until fully extended. Continue to raise body by flexing knees until body is upright. Repeat.	Easier	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{}	t	f
Hanging Hamstring Bridge	Stand behind bar facing elevated platform positioned slightly away on other side of bar. Grasp bar with slightly wider than shoulder width grip. Walk body under bar and position back of heels on elevated platform. With legs extended forward, hang under bar with arms straight and hips bent just above floor.	Raise hips up as high as possible by extending hips. Lower hips to original position just above floor. Repeat.	Platform should be high enough to allow hips to flex without buttocks contacting floor. Full range of motion will vary from person to person. Adductor Magnus may only assist at initial phase hip extension depending on degree of hip flexion at bottom of movement. Also see Hanging Hyperextension for Erector Spinae performed with fuller range of movement.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{}	t	f
Single Leg Hanging Hamstring Bridge	Stand behind bar facing elevated platform positioned slightly away on other side of bar. Grasp bar with slightly wider than shoulder width grip. Walk body under bar. Position back of heel on elevated platform. Place other foot on or just over floor so leg is bent. Hang under bar with arms straight and hips bent just above floor.	Raise hips up as high as possible by extending hip and spine. Maintain bent position of lower leg allowing it to rise with hips. Lower hips along with bent lower leg to original position and repeat. Continue with legs in opposite position.	Platform should be high enough to allow hip to flex without buttocks contacting floor. Full range of motion will vary from person to person. Adductor Magnus may only assist at initial phase hip extension depending on degree of hip flexion at bottom of movement.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{}	t	f
Hanging Hamstring Bridge Curl		Raise hips by extending hips. Before full hip extension, pull body toward feet by bending knees and hips. Roll onto feet until knees are fully flexed. Return body to original position by extending knees, then lowering hips to original position just above floor. Repeat.	Platform should be high enough to allow hips to flex without buttocks contacting floor. Full range of motion will vary from person to person.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{}	t	f
Single Leg Hanging Hamstring Bridge Curl		Raise hip and bent lower leg up by extending hip of elevated leg. Maintain bent position of lower leg allowing it to rise with hips. Before full hip extension, pull body toward foot by bending knee and hip of elevated leg. Roll onto foot until knee is fully flexed. Return body to original position by extending knee, then lowering hips and bent lower leg to original position just above floor. Repeat. Continue with opposite leg position.	Platform should be high enough to allow hip to flex without buttocks contacting floor. Full range of motion will vary from person to person.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{}	t	f
Hanging Leg Curl	Lay supine under fixed horizontal bar. Grasp bar with wide overhand grip. Straighten and raise body off of floor keeping heels on floor.	Pull body toward feet by bending knees and hips. Roll onto feet until knees are fully flexed. Return body to original position by extending knees and hips. Repeat.	Positioned bar so back is slightly above floor once grip is established. Keep low back straight, maintaining approximate height from floor throughout movement. Hamstrings seemingly acts as a dynamic stabilizer, since it shortens through knee, while it lengthens through hip. However, net contraction actually appears to occur, since hip flexes only slightly, while knee flexes nearly 100%, allowing hamstrings to remain in a mechanically strong position throughout movement. Dorsal flexion of ankle reduces active insufficiency of Gastrocnemius, allowing it to assist in knee flexion. Apart from Sartorius involvement, flexion of hips is largely passive and is accomplished by eccentric contraction of glutes during concentric contraction of hamstrings.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{}	t	f
Hanging Straight Hip Leg Curl	Lay supine under fixed horizontal bar. Grasp bar with wide overhand grip. Straighten and raise body off of floor keeping heels on floor.	Pull body toward feet by bending knees while keeping hips straight. Roll onto feet until knees are fully flexed. Return body to original position by extending knees. Repeat.	Positioned bar so back is slightly above floor once grip is established. Keep low back and hips straight throughout movement. With hips fully extended, Hamstrings enter active insufficiency near complete knee flexion. Dorsal flexion of ankle reduces active insufficiency of Gastrocnemius, allowing it to assist in knee flexion.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{}	t	f
Smith Straight Leg Deadlift (Romanian)	Stand with shoulder width or narrower stance on elevated platform with thigh against bar. Grasp bar with shoulder width or slightly wider overhand grip. Disengage bar by rotating bar back.	With knees straight, lower bar toward top of feet by bending hips. After hips can no longer flex, bend waist as bar approaches top of feet. Lift bar by extending waist and hip until standing upright. Pull shoulders back slightly if rounded. Repeat.	Begin with very light weight and add additional weight gradually to allow lower back adequate adaptation. Throughout lift, keep arms and knees straight. Do not pause or bounce at bottom of lift. Do not lower weight beyond mild stretch throughout hamstrings and low back. Full range of motion will vary from person to person. Those with less flexibility may not even need to stand on platform. See Dangerous Exercise Essay. Also see Stiff Leg Deadlift.	{BASIC}	{COMPOUND}	{PULL}	{SMITH}	f	f
Straight Hip Leg Curl (on stability ball)	Lie supine on floor with lower legs on exercise ball. Extended arms out to sides. Straighten low back, knees, and hips, raising back and hips off of floor.	Keeping hips and low back straight, bend knees, pulling heels toward rear end. Allow feet to rollup on to ball. Lower to original position by straightening knees. Repeat.	Keep hips straight throughout movement. Dorsal flexion of ankle reduces active insufficiency of Gastrocnemius allowing it to assist in knee flexion.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{STABILITY_BALL}	t	f
Single Leg Straight Hip Leg Curl (on stability ball)	Lie supine on floor with lower legs on exercise ball. Extended arms out to sides. Straighten low back, knees, and hips, raising back and hips off of floor.	Keeping hips and low back straight, bend knee, pulling heel toward rear end while keeping other leg extended straight so it raises upward. Allow foot to rollup on to ball. Lower to original position by straightening knee until other leg makes contact with ball. Repeat.	Keep hips straight throughout movement. Knee of rising straight leg will be kept close to knee of bending leg. Dorsal flexion of ankle reduces active insufficiency of Gastrocnemius allowing it to assist in knee flexion.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{STABILITY_BALL}	t	f
Lever Lying Hip Adduction	Sit in machine with legs outside of vertical center pads. If available, place heels on foot bars. Lie back on back pad. Disengage and pull lever brace to position legs apart until slight stretch is felt. Engage lever into locked position. Lie back and grasp bars to sides.	Move legs together. Return and repeat.	Mount machine with leg levers together. Use lever to extend legs apart. See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Suspended Straight Hip Leg Curl	Sit on floor facing suspension trainer loops in low position. Grasp bottom of loops, then lay supine. Raise legs and place heels in loops with soles contacting handles. Extend legs out and place arms on floor off to sides. Straighten low back, knees, and hips, raising back and hips off of floor.	Bend knees, pulling heels toward rear end while keeping hips and low back straight. Raise up until lower legs are vertical or fully flexed. Lower body to original position by straightening knees, maintaining straight hip position. Repeat.	Keep hips straight throughout movement. With hips fully extended, Hamstrings enter active insufficiency near complete knee flexion. Dorsal flexion of ankle reduces active insufficiency of Gastrocnemius, allowing it to assist in knee flexion.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{SUSPENSION}	t	f
Lever Seated Hip Adduction	Sit in machine with legs outside of vertical center pads. If available, place heels on foot bars. Disengage and pull lever brace to position legs apart until slight stretch is felt. Engage lever into locked position. Lie back and grasp bars to sides.	Move legs together. Return and repeat.	Mount machine with leg levers together. Use lever to extend legs apart. See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Cable Hip Adduction	Stand in front of low pulley facing to one side. Attach cable cuff to near ankle. Step out away from stack with wide stance and grasp ballet bar. Stand on far foot and allow near leg to be Pulled toward low pulley.	Move near leg just in front of far leg by abduction hip. Return and repeat. Turn around and continue with opposite leg.	Notice cable pulley in use is out of view to left. Exerciser is holding on to ballet bar above opposite cable pulley, not in use. See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable Lying Hip Adduction	Stand or sit in front of low pulley and attach cable cuff to ankle. Step away from pulley toward opposite pull, pulling weight plates up just far enough get next to opposite cable pulley. Attach other cable cuff to opposite ankle. Sit so hips are between both low pulley cables to each side. Lie down on back and lift legs up vertically.	Lower legs apart out to each side until stretch is felt in inner thigh. Raise legs together. Return and repeat.	See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Barbell Push Sit-up	Position feet under foot pad and lie supine on flat or incline bench. Pull barbell from floor or grasp from rack behind with overhand grip. Position barbell over chest with shoulder width or slightly wider grip.	Raise torso from bench as high as possible by bending waist and hips. Keep weight positioned above shoulders. Achieve near upright posture (hip flexibility, incline, and initial hip position permitting). Return to original lying posture with back of shoulders contacting padded incline board. Repeat.	Keep weight above shoulders throughout movement. Incline can also be elevated to increase resistance. If upper back does not come completely down at end of movement, abdominal muscles may only be isometrically involved in exercise.	{BASIC}	{COMPOUND}	{PUSH}	{BARBELL,BENCH}	f	f
Cable Lying Crunch (on stability ball)	Sit on stability ball against low pulley column. Roll back away from low pulley column, so back is on ball. Reach back and grasp cable rope attachment with both hands and place inside of wrists on sides of head. Allow weight to hyperextend lower back against stability ball.	With hips stationary, flex waist so elbows travel toward thighs. Return and repeat.	See Spot Reduction Myth. Certain individuals may need to keep their neck in neutral position with space between their chin and sternum. Some individuals may experience low back discomfort if hips are not bent so they must use smaller ball size or lower their hip position on ball.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE,STABILITY_BALL}	f	f
Cable Lying Leg-Hip Raise	Attach cable ankle straps to both ankles then attach ankle straps to cable. Lie supine on floor or mat, back far enough so cable is taut. Grasp support behind head.	Raise legs by flexing hips while flexing knees until hips are fully flexed. Raise hips from floor by flexing waist. Return until waist, hips and knees are extended downward. Repeat.	Movement can also be performed on bench. Rectus Abdominis and Obliques only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion. It may be necessary to completely flex hips before waist flexion is possible. See Spot Reduction Myth and Lower Ab Myth. Also see Cable Lying Leg Raise.	{BASIC}	{COMPOUND}	{PULL}	{CABLE,BENCH}	f	f
Cable Lying Straight Leg-Hip Raise	Attach cable ankle straps to both ankles, then attach ankle straps to cable. Lie supine on floor or mat, back far enough so cable is taut. Grasp support behind head.	Raise legs by flexing hips until fully flexed. Raise hips from floor by flexing waist. Return until waist and hips are extended downward. Repeat.	Rectus Abdominis and Obliques only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion. Waist flexion will occur earlier in lift if legs are straighter or Hamstrings are not that flexible. See Spot Reduction Myth and Lower Ab Myth. Also see Cable Lying Straight Leg Raise.	{BASIC}	{COMPOUND}	{PULL}	{CABLE}	f	f
Cable Kneeling Crunch	Kneel below high pulley. Grasp cable rope attachment with both hands. Place wrists against head. Position hips back and flex hips, allowing resistance on cable pulley to lift torso upward so spine is hyperextended.	With hips stationary, flex waist so elbows travel toward middle of thighs. Return and repeat.	Note movement occurs in waist, not hips. See Spot Reduction Myth. Hyperextension of spine at top of motion is achieved by anterior rotation of pelvis with flexed hips.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable Overhead Seated Crunch	Sit on bench or seat below two very close high pulleys. Grasp two separate cable stirrups, one with each hand. Pull stirrups down with palms facing back over each shoulder. Holding arms in place, allow weight to pull torso up, hyperextend lower back slightly.	With arms fixed in place, flex waist so shoulders travel forward and downward toward thighs. Return until chest is high and back is hyperextended. Repeat.	Keep arms fixed in position keeping them close to body throughout movement. See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE,BENCH}	f	f
Cable Standing Crunch	Position back against back pad with knees slightly bent, shoulders back, and chest high. Position both cable ropes over shoulders, one in each hand. Place hands with cable ropes in front of each shoulder so that cable is taut. If available, place hand in rope slot that allows cable to be taut when hands are in position.	Flex waist so torso pulls ropes forward and downward. Return until back of shoulders return to surface. Repeat alternating twists with opposite sides.	Padded hump should be adjusted to height of low back. See Spot Reduction Myth. Also see Cable Standing Twisting Crunch and Cable Standing Overhead Crunch.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable Standing Overhead Crunch	Stand below high pulley. Grasp cable rope attachment and place wrists against head. Squat down slightly with hips flexed, allowing resistance on cable pulley to lift torso upward so spine is hyperextended.	With knees and hips stationary, flex waist so elbows travel toward middle of thighs. Return and repeat.	Note movement occurs in waist, not hips. Hyperextension of spine at top of motion is achieved by anterior rotation of pelvis with flexed hips. See Spot Reduction Myth. Two soft stirrups or multi-exercise bar can be substituted for rope. If two soft stirrups are used, grasp stirrups at side of head.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Lever Lying Crunch	Lie on machine with legs over pads or feet on foot bar. Grasp bars near head at each side.	With hips stationary, raise upper back pad by flexing waist. Return and repeat.	Lever fulcrum should be aligned with waist, not hips. Some lever lying crunch machines have handles to sides. See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Dumbbell Push Sit-up	Position feet under foot pad and lie supine on flat or incline bench. Position dumbbells straight over shoulders.	Raise torso from bench as high as possible by bending waist and hips. Keep weight positioned above shoulders. Achieve near upright posture (hip flexibility, incline, and initial hip position permitting). Return to original lying posture with back of shoulders, contacting padded incline board. Repeat.	Keep weight above shoulders throughout movement. Incline can also be elevated to increase resistance. If upper back does not come completely down at end of movement, abdominal muscles may only be isometrically involved in exercise.	{BASIC}	{COMPOUND}	{PUSH}	{DUMBBELL,BENCH}	f	f
Lever Lying Leg-Hip Raise	Lie supine on machine with lower legs between padded bars. Grasp handles on each side.	Pull lower leg bar up by flexing hips toward arms by flexing hips then waist. Continue to raise knees toward shoulders by flexing waist, raising hips from board. Return until waist and hips are extended down to original position. Repeat.	Rectus Abdominis and Obliques dynamically contract only if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only isometrically contract to stabilize pelvis and waist during hip flexion. It may be necessary to completely flex hips before waist flexion is possible. See Spot Reduction Myth and Lower Ab Myth.	{BASIC}	{COMPOUND}	{PULL}	{LEVER}	f	f
Lever Push Crunch	Sit on machine with back of hips against hip support. Push hips securely back by pushing feet against foot bar. Grasp handles and push resistance lever until arms are extended in front of body.	Push resistance lever forward by flexing waist. Return by allowing upper body to be pushed back until low back is hyperextended. Repeat.	Foot bar should be adjusted to allow for slight bend in knees as hips are forcefully being pushed against hip pad. Throughout exercise, keep arms straight and hips securely pushed back against hip pad. See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PUSH}	{LEVER}	f	f
Lever Seated Crunch	Sit on machine with back and hips against back supports. If available, place lower legs under pads or on platform. Grasp handles above and position back of arm against pads to each side.	With hips stationary, flex waist so elbows travel downward. Return and repeat.	See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Lever Seated Leg Raise Crunch	Sit on machine with back against back support and lower legs under padded bar. Grasp handles above to each side.	Pull handles down while pulling lower leg bar up by flexing waist and pelvis. Return and repeat.	See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Lever Side Lying Leg Hip Raise	Lie on side with head on elevated head pad and legs between padded rollers. Flex hips slightly until rear and front of thighs are snugly positioned against pads. Flex knees so back of lower leg is against furthest padded roller. Grasp handles in front of head.	Pull knees toward arms by flexing waist and hips. Return and repeat.	See Spot Reduction Myth.	{AUXILIARY,BASIC}	{ISOLATED}	{PULL}	{LEVER}	f	f
Bird Dog	Kneel on mat on all fours with legs and hands slightly apart.	Raise arm out straight beside head while raising and extending leg on opposite side up out behind body. Lower arm and leg to floor to original position and repeat. Perform movement with opposite arm and leg.	Lift leg and arm deliberately with no jerking. Also see Alternating Bird Dog.	{AUXILIARY}	{ISOLATED}	{PULL}	{}	t	f
Alternating Bird Dog	Kneel on mat on all fours with legs and hands slightly apart.	Raise left arm out straight beside head while raising and extending right leg up out behind body. Lower arm and leg to floor to original position. Repeat by raising and lowering right arm and left leg in same manner. Repeat by alternating between opposite sides.	Lift legs and arms deliberately with no jerking. Also see Bird Dog.	{AUXILIARY}	{ISOLATED}	{PULL}	{}	t	f
Cable Standing Twisting Crunch	Position back against back pad with knees slightly bent, shoulders back, and chest high. Place both cable straps over shoulders, one in each hand. Place hands with cable strap in front of each shoulder so that cable is taut. If available, place hands in strap slots that allow cable to be taut when hands are in position with shoulders back.	Flex and twist spine so torso pulls strap forward and downward while twisting one shoulder to forward center. Return until back of shoulders return to back pad. Repeat alternating twists with opposite sides.	To allow for full range of motion, grip height on strap should not allow weight to bottom out (weights touching stack) when shoulders are back. Padded hump should be adjusted to height of low back. See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Crunch	Lie supine on mat with lower legs on bench. Place hands behind neck or head.	Flex waist to raise upper torso from mat. Keep low back on mat and raise torso up as high as possible. Return until back of shoulders contact mat. Repeat.	Certain individuals may need to keep their neck in neutral position with space between their chin and sternum. See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{BENCH}	t	f
Crunch Up	Lie supine on mat or floor with bent leg and arms pointed up.	Flex waist to raise upper torso from floor. Return until back of shoulders contact padded incline board. Repeat.	Hip may move slightly during exercise. Exercise can be performed with added resistance if needed, by holding weight above. Quadriceps were not listed under stabilizers since they are not under significant resistance. Certain individuals may need to keep their neck in neutral position with space between their chin and sternum. See Arm Position During Waist Exercises and Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{}	t	f
Incline Crunch	Hook feet under foot brace and lie supine on incline board with hips bent. Place hands behind neck or head.	Flex waist to raise upper torso from bench. Keep low back on bench and raise torso up as high as possible. Return until back of shoulders contact incline board. Repeat.	If no knee support is built in to incline board, ball can be placed under legs. Hip and knee flexors may be involved as stabilizers if incline is steep and no calf support is used. Certain individuals may need to keep their neck in neutral position with space between their chin and sternum. See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{BENCH}	t	f
Jack-knife Sit-up	Sit on floor or mat. Lie supine with hands to sides.	Simultaneously raise knees and torso until hips and knees are flexed. Return to starting position with waist, hips and knees extended. Repeat.	Begin each repetition with upper back on floor to allow abdominal muscles to work dynamically. The Rectus Abdominis and Obliques dynamically contract only when actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only isometrically contract to stabilize pelvis and waist during hip flexion. See Spot Reduction Myth and Lower Ab Myth.	{BASIC}	{COMPOUND}	{PULL}	{}	t	f
Hanging Leg-Hip Raise	Stand below ab straps hanging from high bar. Place upper arms in straps and grasp straps above.	Raise legs by flexing hips and knees until hips are fully flexed. Continue to raise knees toward shoulders by flexing waist. Return until waist, hips, and knees are extended downward. Repeat.	Exercise can be performed hanging from ab straps. Rectus Abdominis and Obliques only dynamically contract if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only isometrically contract to stabilize pelvis and waist during hip flexion. It may be necessary to completely flex hips before waist flexion is possible. See Spot Reduction Myth and Lower Ab Myth.	{BASIC}	{COMPOUND}	{PULL}	{PULL_UP_BAR}	t	f
Hanging Straight Leg-Hip Raise	Grasp and hang from high bar.	Raise legs by flexing hips until fully flexed. Continue to raise feet toward bar by flexing waist. Return until waist and hips are extended downward. Repeat.	Attempt to decrease shoulder flexion during movement. Rectus Abdominis and Obliques only dynamically contract if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only isometrically contract to stabilize pelvis and waist during hip flexion.	{BASIC}	{COMPOUND}	{PULL}	{PULL_UP_BAR}	t	f
Incline Leg-Hip Raise	Lie supine on incline board with torso elevated. Grasp feet hooks or sides of board by head for support.	Raise legs by flexing hips and knees until hips are fully flexed. Continue to raise knees toward shoulders by flexing waist, raising hips from board. Return until waist, hips and knees are extended. Repeat.	When raising hips, keep knees fully flexed, so as not to throw weight of lower legs over head. Rectus Abdominis and Obliques dynamically contract only if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only isometrically contract to stabilize pelvis and waist during hip flexion. It may be necessary to completely flex hips before waist flexion is possible. See Spot Reduction Myth and Lower Ab Myth. Also see Incline Leg Raise.	{BASIC}	{COMPOUND}	{PULL}	{}	t	f
Lying Leg-Hip Raise	Lie supine on bench or floor. Grasp sides of bench for support.	Raise legs by flexing hips while flexing knees until hips are fully flexed. Continue to raise knees toward shoulders by flexing waist, raising hips from board. Return until waist, hips and knees are extended. Repeat.	When raising hips, keep knees fully flexed, so as not to throw weight of lower legs over head. Rectus Abdominis and Obliques dynamically contract only if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only isometrically contract to stabilize pelvis and waist during hip flexion. It may be necessary to completely flex hips before waist flexion is possible. See Spot Reduction Myth and Lower Ab Myth.	{BASIC}	{COMPOUND}	{PULL}	{BENCH}	t	f
Leg-Hip Raise (on stability ball)	Position ball against sturdy support. Lie with back on ball and heels on floor with legs straight. Grasp sturdy bar(s) near head for support.	Raise legs by flexing hips and knees until hips are fully flexed. Continue to raise knees toward shoulders by flexing waist, raising hips from board. Return until waist, hips and knees are extended. Repeat.	When raising hips, keep knees fully flexed, so as not to throw weight of lower legs over head. Rectus Abdominis and Obliques dynamically contract only if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only isometrically contract to stabilize pelvis and waist during hip flexion. It may be necessary to completely flex hips before waist flexion is possible. See Spot Reduction Myth and Lower Ab Myth. Also Incline Leg-Hip Raise on incline board.	{BASIC}	{COMPOUND}	{PULL}	{STABILITY_BALL}	t	f
Vertical Leg-Hip Raise	Position forearms on padded parallel bars with hands on handles, and back on vertical pad.	Raise legs by flexing hips and knees until hips are fully flexed. Continue to raise knees toward shoulders by flexing waist, raising hips from back board. Return until waist, hips, and knees are extended. Repeat.	Rectus Abdominis and Obliques dynamically contract only if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only isometrically contract to stabilize pelvis and waist during hip flexion; see Weighted Vertical Leg Raise. It may be necessary to completely flex hips before waist flexion is possible. See Spot Reduction Myth and Lower Ab Myth.	{BASIC}	{COMPOUND}	{PULL}	{PARALLEL_BARS}	f	f
Vertical Straight Leg-Hip Raise (parallel bars)	Stand between parallel bars and grip bar on each side with overhand grip. Lift body off floor and balance body upright with arms straight.	Raise legs by flexing hips until fully flexed. Continue to raise feet toward bar by flexing waist. Return until waist and hips are extended downward. Repeat.	This exercise is alternative to Hanging Straight Leg-Hip Raise when high bar is not available or too low to allow for adequate leg clearance. Rectus Abdominis and Obliques dynamically contract only if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only isometrically contract to stabilize pelvis and waist during hip flexion; see Weighted Vertical Leg Raise on parallel bars. It may be necessary to completely flex hips before waist flexion is possible. Waist flexion will occur earlier in lift if legs are straighter or Hamstrings are not that flexible. See Spot Reduction Myth and Lower Ab Myth.	{BASIC}	{COMPOUND}	{PULL}	{PARALLEL_BARS,PULL_UP_BAR}	f	f
Incline Sit-up	Hook feet under support and lie supine on incline bench with hips bent. Place hands behind neck or on side of neck.	Raise torso from bench by bending waist and hips. Return until back of shoulders contact incline board. Repeat.	Certain individuals may need to keep their neck in neutral position with space between their chin and sternum. If no knee support is built in to incline board, ball can be placed under legs. If upper back does not come completely down at end of movement, abdominal muscles may only be isometrically involved in exercise. Pectineus, Adductor Longus, and Brevis do not assist in hip flexion since hips are already initially bent. Knee flexors may be involved as stabilizers if incline is steep and no calf support is used. See Spot Reduction Myth. Also see Dangerous Exercise Essay.	{BASIC}	{COMPOUND}	{PULL}	{BENCH}	t	f
V-up	Sit on floor or mat. Lie supine with hands on floor over head.	Simultaneously raise straight legs and torso. Reach toward raised feet. Return to starting position. Repeat.	Keep knees straight throughout movement. Begin each repetition with upper back on floor to allow abdominal muscles to work dynamically. The Rectus Abdominis and Obliques dynamically contract only when actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only isometrically contract to stabilize pelvis and waist during hip flexion. See Spot Reduction Myth and Lower Ab Myth.	{BASIC}	{COMPOUND}	{PULL}	{}	t	f
Suspended Jack-knife	Sit on floor facing suspension trainer loops in low position. Place right foot in left lower loop. Cross left leg over right leg placed in right lower loop. Turn body to right and place hands on floor, shoulder width apart. Turn body to kneel on hands and knees. Reposition hands squared with desired distance from suspension trainer, shoulder width or slightly wider. With arms straight, raise knees from ground so body is supported by arms and suspension trainer.	Pull legs under torso by bending hips and knees. Pull knees toward chest hips and knees until completely flexed. Return by extending hips and knees to original position. Repeat.	See Suspended Prone Feet Mount/Dismount. Keep shins close to horizontal and arms straight with shoulders positioned above hands. Dismount by removing straps while kneeling or after sitting on one side of hip before rotating body to seated position.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{SUSPENSION}	t	f
Suspended Jack-knife Pike	Sit on floor facing suspension trainer loops in low position. Place right foot in left lower loop. Cross left leg over right leg placed in right lower loop. Turn body to right and place hands on floor, shoulder width apart. Turn body to kneel on hands and knees. Reposition hands (shoulder width or slightly wider) at desired distance from suspension trainer so that body is square with suspension trainer straps. With arm straight, raise knees from ground so body is supported by arms and suspension trainer.	Pull knees toward shoulders while raising hips very high. Lower hips by extending body to original straight position, while keeping shins close to horizontal. Repeat.	See Suspended Prone Feet Mount/Dismount . Keep shins close to horizontal and arms straight with shoulders positioned above hands. Dismount by removing straps, while kneeling or after sitting on one side of hip before rotating body to seated position. This exercise can be performed on TRXⓇ style suspension trainer.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{SUSPENSION}	t	f
Suspended Standing Rollout	Stand facing suspension trainer handles. Bend over slightly at hips and grasp suspension handles with each hand. With handles together, extend arms with slight bend angled forward and downward.	Lean body forward while extending hips and allowing arms to extend forward to sides of head. Bend over as far as possible. Raise body back up by pulling arms back until standing while being bent over slightly at hips in original position. Repeat.	Try to keep elbows nearly straight throughout exercise. Target muscle, Rectus Abdominis practically contracts isometrically since only a small degree of waist flexion occurs under resistance and, with the assistance of the External Oblique, act to stabilize spine. See target muscle of rollout question. Also see Spot Reduction Myth and Lower Ab Myth.	{AUXILIARY}	{ISOLATED}	{PUSH}	{SUSPENSION}	t	f
Suspended Hanging Leg Hip Raise	Stand below suspension trainer handles positioned up high. Grasp handles above.	Raise legs by flexing hips and knees until hips are fully flexed. Continue to raise knees toward shoulders by flexing waist. Return until waist, hips, and knees are extended downward. Repeat.	If handles cannot be positioned high enough, knees can be kept partially bent near bottom so hips can be extended fully. If knees are not extended at botton, Rectus Femoris becomes synergist. Rectus Abdominis and Obliques only dynamically contract if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only isometrically contract to stabilize pelvis and waist during hip flexion. It may be necessary to completely flex hips before waist flexion is possible. See Spot Reduction Myth and Lower Ab Myth.	{BASIC}	{COMPOUND}	{PULL}	{SUSPENSION}	t	f
Cable Kneeling Twisting Crunch	Kneel below high pulley. Grasp cable rope attachment with both hands. Place wrists against head. Position hips back and flex hips, allowing resistance on cable pulley to lift torso upward so spine is hyperextended.	With hips stationary, flex waist to one side so elbow travels toward mid-thigh on opposite side. Return to original position and repeat on opposite side. Continue by alternating between sides.	Note movement occurs in waist, not hips. See Spot Reduction Myth. Hyperextension of spine at top of motion is achieved by anterior rotation of pelvis with flexed hips. Certain individuals may need to keep their neck in neutral position with space between their chin and sternum. If two soft stirrups are used instead of rope attachment, grasp stirrups at side of head.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable Side Bend	With side to low pulley, grasp stirrup attachment with near arm. Stand with arm straight.	Pull stirrup by bending sideways through waist so torso moves away from pulley. Lower stirrup by leaning torso toward pulley. Repeat. Continue with opposite side.	See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable Side Crunch	With side close to high pulley, grasp stirrup attachment with near hand. Position stirrup at side of shoulder, palm orientated inward, and elbow down to side.	Pull stirrup downward by bending toward cable column through waist so torso moves toward base of cable column. Bend in opposite direction by leaning torso away from cable column, allowing stirrup to rise upward. Repeat. Continue with opposite side.	Keep stirrup attachment near side of shoulder with elbow down to side. See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE}	f	f
Cable Seated Twist	Grasp stirrup and straddle bench orientated with side facing medium height cable pulley. Sit with feet on floor. Hold onto stirrup with both hands with arms extending out straight toward stirrup.	Keeping arms straight, rotate torso to opposite side until cable makes contact with shoulder. Return to original position and repeat. Continue with opposite side.	Slightly squeeze legs on sides of bench to prevent shifting. Bench should be far enough away from cable pulley so cable is taut when stirrup is turned back toward cable pulley. See side view and Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE,BENCH}	f	f
Bird Dog (on stability ball)	Lay on top of exercise ball with legs and hands slightly apart. Place chest down so torso is wrapped over ball.	Raise arm and torso upward beside head while raising leg on opposite side up out behind body. Lower arm, torso, and leg to original position and repeat. Perform movement with opposite arm and leg.	Lift leg and arm deliberately with no jerking. Also see Alternating Bird Dog (one exercise ball).	{AUXILIARY}	{ISOLATED}	{PULL}	{STABILITY_BALL}	t	f
Cable Seated Cross Arm Twist	Grasp stirrup from medium height cable pulley with far hand. Sit on stool or straddle bench with lower body facing away from pulley. Allow torso to turn to side of near arm. Place far arm across body onto near arm. Support far elbow with near hand.	Rotate torso through waist to face opposite side until slight stretch if felt. Return to original side until slight stretch is felt. Repeat. Continue with opposite side.	Place feet wide for support, or if straddling bench, slightly squeeze legs on sides of bench to prevent shifting. Upper body stabilizing occurs primarily on far side through isometric shoulder abduction and isometric scapular upward rotation. Upper body stabilization also occurs somewhat on near side through shoulder protraction. See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE,BENCH}	f	f
Lever Seated Side Bend	Position seat so shoulders are same height of padded lever. Sit in machine with legs to one side. Place over lever pad. Push padded lever down slightly until shoulder is fixed at approximately 90º; upper arm parallel to floor.	With hips stationary, push down lever by bending to side so elbow points downward. Return and repeat. Position lower body to opposite side and repeat.	Maintain shoulder fixed at approximately 90º so upper arm and upper back are perpendicular. See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Lever Seated Twist	Adjust range of motion setting on arm levers to one side. Sit on seat with feet on platform. Position arms between pads and grasp handles above to each side.	Rotate torso through waist to opposite side. Return and repeat. Adjust range of motion setting to opposite side and repeat in opposite direction.	See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Dumbbell Side Bend	Grasp dumbbell with arm straight to side.	Bend waist to opposite side of dumbbell until slight stretch is felt. Lower to opposite side, same distance and repeat. Continue with opposite side.	See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL}	f	f
Lever Standing Side Bend	Stand with side to lever handle and grasp. Stand upright.	Bend waist to opposite side of lever. Lower weight by bending to opposite side and repeat. Continue with opposite side facing opposite direction.	Stand on platform if lever is too high to allow for full range of movement. See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Lever Seated Side Crunch	Position seat so shoulders are same height of padded lever. Sit on machine with legs angled to one side. Place arms over lever pad. Push padded lever down slightly until shoulders are are approximately 90º; upper arm parallel to floor.	With hips stationary, flex waist in "C" shape so elbows point downward. Return and repeat. Position lower body to opposite side and repeat.	Maintain shoulders fixed at approximately 90º so upper arm and upper back are perpendicular. Men should keep chest close to padded lever. Women may choose to position chest as close as possible without making contact with inside of padded bar. See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Lying Twist	Lie on back on floor or mat with arms extended out to sides. Raise legs upward with knees slightly bent.	Lower legs to one side until side of thigh is on floor. Raise and lower legs to opposite side. Repeat.	Maintain knee position throughout movement. See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{}	t	f
Bent-knee Lying Twist	Lie on back on floor or mat with arms extended out to sides. Raise bent legs so thighs are vertical and lower legs are horizontal.	Lower legs to one side until side of thigh is on floor. Raise and lower legs to opposite side. Repeat.	Maintain knee position throughout movement. See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{}	t	f
Side Bend (on stability ball)	Lie on ball on side of torso, waist, and hip. Position legs outward with feet on floor or against floor board.	Raise side of torso up by lateral flexing waist. Lower torso back on ball and repeat. Position other side on ball and repeat with opposite side.	See alternative form. Also see Spot Reduction Myth and Arm Position During Waist Exercises.	{AUXILIARY}	{ISOLATED}	{PULL}	{STABILITY_BALL}	t	f
Hanging Twisting Leg Raise	Grasp and hang from high bar with shoulder width or slightly wider overhand grip.	Raise legs to one side by flexing hips and knees until hips are completely flexed or knees are well above hips. Return until hips and knees are extended downward. Raise legs to opposite side in same manner. Continue by bending and lifting legs, alternating between sides.	Obliques are largely exercised isometrically with relatively little movement. Obliques and Rectus Abdominis only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion. Conversely, rotation of spine occurs perpendicular to line force (ie: gravity). It may be necessary to completely flex hips before waist flexion is possible, as in Leg-hip Raise where knees travel to height of shoulders. Also known as Hanging Twisting Knee Raise. Exercise can be performed with ab straps. Also see Spot Reduction Myth and Lower Ab Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{PULL_UP_BAR}	t	f
Vertical Twisting Leg Raise	Position forearms on padded parallel bars with hands on handles, and back on vertical pad.	Raise legs to one side by flexing hips and knees until hips are completely flexed or knees are above hips. Return until hips and knees are extended downward. Raise legs to opposite side in same manner. Continue by bending and lifting legs, alternating between sides.	Obliques are largely exercised isometrically with relatively little movement. Obliques and Rectus Abdominis only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion. Conversely, rotation of spine occurs perpendicular to line force (ie: gravity). It may be necessary to completely flex hips before waist flexion is possible, as in Leg-hip Raise where knees travel to height of shoulders. Also known as Vertical Twisting Knee Raise. Also see Spot Reduction Myth and Lower Ab Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{PARALLEL_BARS}	t	f
Vertical Twisting Leg Raise (on dip bar)	Stand between parallel bars and grip bar on each side with overhand grip. Lift body off floor and balance body upright with arms straight.	Raise legs to one side by flexing hips and knees until hips are completely flexed or knees are above hips. Return until hips and knees are extended downward. Raise legs to opposite side in same manner. Continue by bending and lifting legs, alternating between sides.	Obliques are largely exercised isometrically with relatively little movement. Obliques and Rectus Abdominis only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion. Conversely, rotation of spine occurs perpendicular to line force (ie: gravity). It may be necessary to completely flex hips before waist flexion is possible, as in Leg-hip Raise where knees travel to height of shoulders. Also known as Vertical Twisting Knee Raise (on parallel bars). Also see Spot Reduction Myth and Lower Ab Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{PARALLEL_BARS}	t	f
Incline Twisting Sit-up	Hook feet under foot or ankle brace and lie supine on incline bench with hips and knees bent. Place hands behind neck.	Flex and twist waist to one direction while raising torso from bench by bending hips. Return until back of shoulders contact padded incline board. Repeat to opposite side alternating twists.	Certain individuals may need to keep their neck in neutral position with space between their chin and sternum. If no knee support is built in to incline board, ball can be placed under legs. If upper back does not come completely down at end of movement, abdominal muscles may only be isometrically involved in exercise. Pectineus, Adductor Longus, and Brevis do not assist in hip flexion since hips are already initially bent. Knee flexors may be involved as stabilizers if incline is steep and no calf support is used. See Spot Reduction Myth.	{BASIC}	{COMPOUND}	{PULL}	{BENCH}	t	f
Side Crunch	Lie upper back supine on floor or mat. With both legs together, knees and hips bent, position outside of leg down to side. Place one hand base on of neck or place arms across upper chest.	Flex waist, raising upper torso off mat or floor. Return until back of shoulders return to mat or floor. Repeat and continue with movement in opposite position.	Certain individuals may need to keep their neck in neutral position with space between their chin and sternum. See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{}	t	f
Side Crunch (on stability ball)	Sit on exercise ball. Walk forward on ball and lie back on ball with shoulders and head hanging off. Switch position of feet by positioning bent leg under extended leg so waist is twisted with hip positioned sideways. Gently hyperextend back to contour of ball. Place hands behind neck or cross arms across chest.	Flex waist to raise upper torso. Return to original position and repeat. Position legs in opposite position and continue.	Certain individuals may need to keep their neck in neutral position with space between their chin and sternum. Some individuals may experience low back discomfort if hips are not bent, so they must use smaller ball size or lower their hip position on ball. Also see Spot Reduction Myth and Arm Position During Waist Exercises.	{AUXILIARY}	{ISOLATED}	{PULL}	{STABILITY_BALL}	t	f
Twisting Crunch	Lie supine on mat with lower legs on bench. Place hands behind neck or head.	Flex and twist waist to raise upper torso from mat to one side. Return until back of shoulders contact mat. Repeat to opposite side alternating twists.	Leg elevation keeps pelvis tilted back keeping low back on mat. Certain individuals may need to keep their neck in neutral position with space between their chin and sternum, particularly with their hands are behind their heads. See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{BENCH}	t	f
Twisting Crunch (on stability ball)	Sit on exercise ball. Walk forward on ball and lie back on ball with shoulders and head hanging off, and knees and hips bent. Gently hyperextend back to contour of ball. Hold plate behind neck or on chest with both hands or use no weight.	Flex waist to raise upper torso. Return to original position. Repeat.	Certain individuals may need to keep their neck in neutral position with space between their chin and sternum. Some individuals may experience low back discomfort if hips are not bent, so they must use smaller ball size or lower their hip position on ball. Also Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{STABILITY_BALL}	t	f
Hanging Windshield Wiper	Grasp and hang from high bar with shoulder width overhand grip. With arms straight, raise hips and position legs vertically by extending shoulders and flexing hips.	Turn legs to one side by rotating waist until stretch is felt through waist. Rotate legs to opposite side in same manner. Continue by rotating from side to side.	Alternative easier mount involves raising hips with knees bent, then extending legs upward. Arms and legs may bend slightly throughout movement. Knees may bend more during movement if hamstrings are somewhat tight. Although some movement occurs through shoulders and scapula, engaged musculature is classified as stabilizer since movement is relatively limited. Rectus Femoris enters active insufficiency so it's not significantly involved as hip flexor stabilizer. See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{PULL_UP_BAR}	t	f
Suspended Pendulum	Sit on floor facing suspension trainer loops in low position. Place right foot in left lower loop. Cross left leg over right leg placed in right lower loop. Turn body to right and place hands on floor shoulder width apart. Turn body to kneel on hands and knees. Reposition hands (shoulder width or slightly wider) at desired distance from suspension trainer so that body is square with suspension trainer straps. With arms straight, raise knees from ground, so body is supported by arms and suspension trainer.	Move both legs to one side then to opposite side by moving through waist and hips. Continue swinging legs side to side.	Keep arms straight with shoulders positioned above hands. Hips abduct and adduct slightly as waist rotates and laterally flexes as it remains somewhat flexed. Dismount by removing straps while kneeling or after sitting on one side of hip before rotating body to seated position. See Suspended Prone Feet Mount/Dismount. This exercise can be performed on TRXⓇ style suspension trainer. See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{SUSPENSION}	t	f
Suspended Twisting Jack-knife	Sit on floor facing suspension trainer loops in low position. Place right foot in left lower loop. Cross left leg over right leg placed in right lower loop. Turn body to right and place hands on floor, shoulder width apart. Turn body to kneel on hands and knees. Reposition hands (shoulder width or slightly wider) at desired distance from suspension trainer so that body is square with suspension trainer straps. With arms straight, raise knees from ground so body is supported by arms and suspension trainer.	Pull knees toward one elbow by bending hips a nd knees to one side. Twist legs to one side, until hips and knees are completely flexed. Return by extending hips and knees to original straight position. Perform movement to opposite side. Continue by alternating each side.	See Suspended Prone Feet Mount/Dismount. Keep arms straight with shoulders positioned above hands. Dismount by removing straps while kneeling or after sitting on one side of hip, before rotating body to seated position. This exercise can be performed on TRXⓇ style suspension trainer.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{SUSPENSION}	t	f
Lever Back Extension	Sit on machine with back against padded lever. Push hips back against back of seat by pushing feet against platform. Arch back in "C" shape.	Extend spine until hyperextended. Return and repeat.	To avoid hip movement, push hips back into seat by pushing feet into platform throughout exercise. Position foot platform, so small space remains between edge of seat and back of lower thigh. Use seat belt if it becomes difficult to stabilize hips. See Low Back Debate. Also see exercises on old Nautilus Machine and MedEx Low Back Machine.	{AUXILIARY}	{ISOLATED}	{PULL}	{LEVER}	f	f
Back Extension (on stability ball, arms crossed)	Lie prone on ball, with front of feet apart on floor or with feet against base of wall. Cross arms, hands in front of shoulders.	Raise torso off of ball by hyperextending spine. Lower torso onto ball allowing spine to flex. Repeat.	If no wall is available, hips can be positioned lower on ball and toes can be positioned out wide on floor for balance.	{AUXILIARY}	{ISOLATED}	{PULL}	{STABILITY_BALL}	t	f
Rear Bridge	Sit on mat or floor with legs bent and feet on floor or mat. Place hands back to sides on floor or mat so torso is reclined back slightly.	Raise hips up off floor until hips are straight. Hold position.	Muscles are exercised isometrically.	{AUXILIARY}	{ISOLATED}	{PUSH}	{}	t	f
Decline Rear Bridge	Lie supine on mat with arms to sides. Place feet flat on floor or mat with knees bent.	Raise hips up off floor until hips are straight. Hold position.	Muscles are exercised isometrically.	{AUXILIARY}	{ISOLATED}	{PUSH}	{}	t	f
Single Leg Decline Rear Bridge	Lie supine on mat with arms to sides. Place one foot flat on floor or mat with knee bent. Keep other leg straight. Place arms out to sides of body for stability.	While keeping leg straight inline with body, raise hips up off floor until hip of bent leg is straight. Hold position. Change position and repeat hold on opposite side.	Muscles are exercised isometrically.	{AUXILIARY}	{ISOLATED}	{PUSH}	{}	t	f
Incline Rear Bridge	Sit on mat with legs straight and placed together. Place hands back to sides on floor or mat so torso is reclined back slightly.	Raise hips up off floor until hips are straight. Hold position.	Muscles are exercised isometrically.	{AUXILIARY}	{ISOLATED}	{PUSH}	{}	t	f
Dumbbell One Arm Triceps Extension	Sit on seat with back support just below shoulder height. Position dumbbell overhead with arm straight up or slightly back.	Lower dumbbell behind neck or shoulder while maintaining upper arm's vertical position throughout exercise. Extend arm until straight. Return and repeat. Continue with opposite arm.	Let dumbbell pull back arm slightly to maintain full shoulder flexion. Keep elbow in so movement does not resemble overhead press. Back support should not be so high that it interferes with dumbbell being completely lowered (ie: full range of motion). See rear view. Exercise may be performed on bench without back support.	{BASIC,AUXILIARY}	{ISOLATED}	{PUSH}	{DUMBBELL,BENCH}	f	f
Dumbbell One Arm Reclined Triceps Extension	Sit on bench with dumbbell in one hand. Place other hand on bench behind body and recline back so arm supports body. Position dumbbell overhead with arm straight up.	Lower dumbbell behind neck or shoulder while maintaining upper arm's vertical position throughout exercise. Extend arm until straight. Return and repeat. Continue with opposite arm.	Reclined position can be used instead of standard form for those who lack ability to fully flex shoulder. Keep elbow pointed upward so movement does not resemble overhead press.	{BASIC,AUXILIARY}	{ISOLATED}	{PUSH}	{DUMBBELL,BENCH}	f	f
Dumbbell Curl	Position two dumbbells to sides, palms facing in, arms straight.	With elbows to sides, raise one dumbbell and rotate forearm until forearm is vertical and palm faces shoulder. Lower to original position and repeat with opposite arm. Continue to alternate between sides.	Biceps may be exercised alternating (as described), simultaneous, or in simultaneous-alternating fashion. When elbow is fully flexed, it can travel forward slightly, allowing forearms to be no more than vertical. This additional movement allows for relative release of tension in muscles between repetitions. Also see mechanical analysis of arm curl and question regarding elbow position.	{BASIC}	{ISOLATED}	{PULL}	{DUMBBELL}	f	f
Dumbbell Hammer Curl	Position two dumbbells to sides, palms facing in, arms straight.	With elbows to sides, raise one dumbbell until forearm is vertical and thumb faces shoulder. Lower to original position and repeat with alternative arm.	The biceps may be exercised alternating (as described), simultaneous, or in simultaneous-alternating fashion. When elbows are fully flexed, they can travel forward slightly allowing forearms to be no more than vertical. This additional movement allows for relative release of tension in muscles between repetitions.	{AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL}	f	f
Hyperextension	Lie face down on the bench and adjust your position such that your hips are at the edge and your upper body is outside the bench. Ensure that the bench does not lift up while you're performing the exercise.Place hands behind neck or to sides of head.	Raise upper body until hips and waist are extended. Lower body by bending hips and waist until mild stretch is felt or torso is vertical. Repeat.	Adjust lower leg brace so pressure is evenly distributed on thigh pad and full range of motion is permitted; abdomen should not press on side of pad when upper body is lowered. Do not pause or bounce at bottom of lift. Do not lower weight beyond mild stretch throughout hamstrings and low back. Full range of motion will vary from person to person.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{BENCH}	t	f
Reverse Hyper-extension	Lie on your stomach on a flat bench with your legs hanging off the edge. Your hips should be at the end of the bench. Hug the bench with your arms and lift your feet a few inches off the ground, keeping your knees straight.	Keeping your legs straight, exhale as you lift your feet as high as you can. Hold for a count of two. Inhale as you lower your feet back to the starting position. Repeat.	Also see Reverse Hyper-extension performed with exercise ball on bench.	{AUXILIARY}	{ISOLATED}	{PUSH}	{BENCH}	t	f
Dumbbell Kickback	Kneel over bench with arm supporting body. Grasp dumbbell. Position upper arm parallel to floor.	Extend arm until it is straight. Return and repeat. Continue with opposite arm.	For greater range of motion, upper arm can be positioned with elbow slightly higher than shoulder. Also see Triceps Kickback Errors.	{AUXILIARY}	{ISOLATED}	{PUSH}	{DUMBBELL,BENCH}	f	f
Dumbbell Alternating Incline Front Raise	Grasp dumbbells and lie supine on upper portion of 45 degree incline bench with legs straight. Position dumbbells downward below each shoulder.	With elbows straight or slightly bent, raise one dumbbell forward, up and over shoulder until upper arm is vertical. Lower dumbbell down to starting position. Repeat raise with other arm, alternating between sides.	Movement can also be performed on old fashion incline bench without seat.	{AUXILIARY}	{ISOLATED}	{PUSH}	{DUMBBELL,BENCH}	f	f
Dumbbell Alternating Seated Front Raise	Sit on end of bench with dumbbell in each hand and legs together. Position dumbbells with palms facing inward and arms hanging down straight.	Raise one dumbbell forward and upward while turning palms downward as soon as dumbbell clears thigh. Continue raising dumbbell until upper arm is above horizontal. Lower and turn palms inward while dumbbells travels past thigh until arm is in original vertical position. Repeat with opposite arm, alternating movement pattern between arms.	Height of movement may depend on range of motion. Raise should be limited to height achieved just before tightness is felt in shoulder capsule, which may be slightly higher than which is felt in the palms down version. Alternatively, height just above horizontal may be considered adequate. Elbows may be kept straight or slightly bent throughout movement. Also see Dumbbell Seated Front Raise.	{AUXILIARY}	{ISOLATED}	{PUSH}	{DUMBBELL,BENCH}	f	f
Dumbbell Alternating Side Lunge	Stand with dumbbells grasped to sides.	Lunge to one side with first leg. Position closest dumbbell behind thigh and opposite dumbbell to front. Land on heel, then forefoot. Lower body by flexing knee and hip of lead leg, keeping knee pointed same direction of foot. Return to original standing position by forcibly extending hip and knee of lead leg. Repeat by alternating lunge with opposite leg.	Keep torso upright during lunge. Flexible hip adductors will allow fuller range of motion. Forward knee should point same direction as foot throughout lunge. A long lunge emphasizes Gluteus Maximus; short lunge emphasizes Quadriceps. Dumbbells may be positioned - one to front and other to back.	{AUXILIARY}	{COMPOUND}	{PUSH}	{DUMBBELL}	f	f
Dumbbell Arnold Press	Stand with two dumbbells position in front of shoulders, palms facing body and elbows under wrists.	Initiate movement by bringing elbows out to sides. Continue to raise elbows outward while pressing dumbbells overhead until arms are straight. Lower to front of shoulders in opposite pattern and repeat.	Movement should emphasize shoulder abduction while minimizing forearm pronation as this exercise attempts to combine lateral raise like motion with shoulder press. Lean forward slightly when lifting Dumbbells.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{DUMBBELL}	f	f
Dumbbell Seated Curl	Sit on end of bench with dumbbell in each hand and legs together. Position dumbbells with palms facing inward and arms hanging down straight.	With elbows back to sides, raise one dumbbell and rotate forearm until forearm is vertical and palm faces shoulder. Lower to original position and repeat with opposite arm. Continue to alternate between sides.	This exercise may be performed by alternating (as described), simultaneous, or in simultaneous-alternating fashion. When elbow is fully flexed, it can travel forward slightly, allowing forearms to be no more than vertical. This additional movement allows for relative release of tension in muscles between repetitions. Also see mechanical analysis of arm curl and question regarding elbow position.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL,BENCH}	f	f
Dumbbell Concentration Curl	Sit on bench. Grasp dumbbell between feet. Place back of upper arm to inner thigh. Lean into leg to raise elbow slightly.	Raise dumbbell to front of shoulder. Lower dumbbell until arm is fully extended. Repeat. Continue with opposite arm.	The long head (lateral head) of Biceps Brachii is activated significantly more than short head (medial head) of Biceps Brachii since short head enters into active insufficiency as it continues to contract.	{AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL,BENCH}	f	f
Dumbbell Bent-over Row	Kneel over side of bench by placing knee and hand of supporting arm on bench. Position foot of opposite leg slightly back to side. Grasp dumbbell from floor.	Pull dumbbell to up to side until it makes contact with ribs or until upper arm is just beyond horizontal. Return until arm is extended and shoulder is stretched downward. Repeat and continue with opposite arm.	Allow scapula to articulate but do not rotate torso in effort to throw weight up. Torso should be close to horizontal. Positioning supporting knee and/or arm slightly forward or back will allow for proper levelling of torso. Torso may be positioned lower to allow for heavier dumbbell to make contact with floor, if desired.	{BASIC}	{COMPOUND}	{PULL}	{DUMBBELL,BENCH}	f	f
Dumbbell Shrug	Stand holding dumbbells to sides.	Elevate shoulders as high as possible. Lower and repeat.	Exercise may be performed standing perfectly upright or very slightly bent over. Since this movement becomes more difficult as full shoulder elevation is achieved, height criteria for shoulder elevation may be needed. For example, raising shoulders until slope of shoulders becomes horizontal may be considered adequate depending upon individual body structure and range of motion with lighter weight. Also see ROM Criteria and Shoulder Shrug Errors.	{BASIC}	{ISOLATED}	{PULL}	{DUMBBELL}	f	f
Dumbbell Lying Shoulder External Rotation	Lie on side with legs separated for support. Grasp dumbbell and position elbow against side and forearm across belly.	Lift dumbbell by rotating shoulder. Return and repeat. Flip over and continue with opposite arm.	Maintain elbow against side and fixed elbow position (90° angle) throughout exercise. Placing towel roll under arm increase infraspinatus and teres minor EMG signal activity compared to no towel roll (Wilk KE 2002), although subsequent study found no significant difference (Reinold MM 2004). Also see Dumbbell Shoulder External Rotation Errors.	{AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL}	f	f
Dumbbell Incline Bench Press	Sit down on incline bench with dumbbells resting on lower thigh. Kick weights to shoulders and lean back. Position dumbbells to sides of chest with upper arm under each dumbbell.	Press dumbbells up with elbows to sides until arms are extended. Lower weight to sides of upper chest until slight stretch is felt in chest or shoulder. Repeat.	Dumbbell should follow slight arch pattern, above upper arm between elbow and chest at bottom, traveling inward over each shoulder at top. See suggested mount & dismount and mount & dismount from special machine rack. Also see elevated foot leg positioning to decrease arch in back and Bench Press Analysis.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{DUMBBELL,BENCH}	f	f
Dumbbell Incline Shoulder Raise	Sit down on incline bench with dumbbells resting on lower thigh. Kick weights to shoulders and lean back. Position dumbbells above shoulders with elbows extended.	Raise shoulders toward dumbbells as high as possible. Lower shoulders to bench and repeat.	Keep arms straight throughout execution. For convenience, exercise can be performed immediately after warm up on Dumbbell Incline Chest Press.	{AUXILIARY}	{ISOLATED}	{PUSH}	{DUMBBELL,BENCH}	f	f
Dumbbell Reverse Wrist Curl	Sit and grip dumbbell with overhand grip. Rest forearm on thigh with wrist just beyond knee.	Raise dummbell by pointing knuckles upward as high as possible. Return until knuckles are pointing downward as far as possible. Repeat.	Keep elbow approximately wrist height to maintain resistance through full range of motion. Hand may be placed under wrist to offer stability and to maintain horizontal orientation of forearm.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL}	f	f
Dumbbell Seated Supination	Sit next to elevated surface, approximately arm pit height. With hand of arm next to elevated surface, grasp unilaterally loaded dumbbell; thumb next to side with weight. Bend elbow approximately 90-degrees and place upperarm on elevated surface. Position thumb downward (pronated).	Rotate dumbbell so thumb turns upward (supination). Return and repeat.	If unilaterally loaded dumbbell, or "half dumbbell" is not available, grasp conventional dumbbell to one side of handle with pinkie against inside surface.	{AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL}	f	f
Dumbbell Lateral Step-up	Stand between two benches, one to each side. Hold dumbbells in each hand down to sides	Lift leg and place foot on bench to side slightly forward of straight knee. Stand on bench by straightening leg and pushing body upward. Step down returning feet to original position. Repeat with opposite leg alternating between legs.	Keep torso upright during exercise. Stepping knee should point same direction as foot. A modest degree of knee rotation occurs during this movement. See Controversial Exercises and Rotary Force in Squat Analysis.	{AUXILIARY}	{COMPOUND}	{PUSH}	{DUMBBELL,BENCH}	f	f
Dumbbell Step-up	Stand with dumbbells grasped to sides facing side of bench.	Place foot of first leg on bench. Stand on bench by extending hip and knee of first leg and place foot of second leg on bench. Step down with second leg by flexing hip and knee of first leg. Return to original standing position by placing foot of first leg to floor. Repeat first step with opposite leg alternating first steps between legs.	Keep torso upright during exercise. Lead knee should point same direction as foot throughout movement. Stepping distance from bench emphasizes Gluteus Maximus; stepping close to bench emphasizes Quadriceps.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{DUMBBELL,BENCH}	f	f
Dumbbell Lunge	Stand with dumbbells grasped to sides.	Lunge forward with first leg. Land on heel, then forefoot. Lower body by flexing knee and hip of front leg until knee of rear leg is almost in contact with floor. Return to original standing position by forcibly extending hip and knee of forward leg. Repeat by alternating lunge with opposite leg.	Keep torso upright during lunge; flexible hip flexors are important. Lead knee should point same direction as foot throughout lunge. A long lunge emphasizes Gluteus Maximus; short lunge emphasizes Quadriceps.	{AUXILIARY}	{COMPOUND}	{PUSH}	{DUMBBELL}	f	f
Dumbbell Bench Press	Sit down on bench with dumbbells resting on lower thigh. Kick weights to shoulder and lie back. Position dumbbells to sides of chest with bent arm under each dumbbell.	Press dumbbells up with elbows to sides until arms are extended. Lower weight to sides of chest until slight stretch is felt in chest or shoulder. Repeat.	Dumbbells should follow slight arch pattern, above upper arm between elbow and chest at bottom, traveling inward over each shoulder at top. No need to drop weights - see suggested mount and dismount techniques: standard or advanced. Also see mount & dismount from special machine rack and Bench Press Analysis.	{BASIC}	{COMPOUND}	{PUSH}	{DUMBBELL,BENCH}	f	f
Dumbbell Rear Lunge	Stand with dumbbells grasped to sides.	Step back with one leg while bending supporting leg. Plant forefoot far back on floor. Lower body by flexing knee and hip of supporting leg until knee of rear leg is almost in contact with floor. Return to original standing position by extending hip and knee of forward supporting leg and return rear leg next to supporting leg. Repeat movement with opposite legs alternating between sides.	Keep torso upright during lunge; flexible hip flexors are important. Forward knee should point same direction as foot throughout lunge. A long lunge emphasizes Gluteus Maximus; short lunge emphasizes Quadriceps.	{AUXILIARY}	{COMPOUND}	{PUSH}	{DUMBBELL}	f	f
Dumbbell Side Lunge	Stand with dumbbells grasped to sides.	Lunge to one side with first leg. Position closest dumbbell behind thigh and opposite dumbbell to front. Land on heel, then forefoot. Lower body by flexing knee and hip of lead leg, keeping knee pointed same direction of foot. Return to original standing position by forcibly extending hip and knee of lead leg. Repeat by alternating lunge with opposite leg.	Keep torso upright during lunge. Flexible hip adductors will allow fuller range of motion. Forward knee should point same direction as foot throughout lunge. A long lunge emphasizes Gluteus Maximus; short lunge emphasizes Quadriceps. Dumbbells may be positioned - one to front and other to back.	{AUXILIARY}	{COMPOUND}	{PUSH}	{DUMBBELL}	f	f
Dumbbell Split Squat	Stand with dumbbells grasped to sides. Position feet far apart; one foot forward and other foot behind.	Squat down by flexing knee and hip of front leg. Allow heel of rear foot to rise up while knee of rear leg bends slightly until it almost makes contact with floor. Return to original standing position by extending hip and knee of forward leg. Repeat. Continue with opposite leg.	Knees should point same direction as feet throughout movement. Heel of rear foot can be kept elevated off floor throughout movement as shown. Keep torso upright during squat; flexible hip flexors are important. With feet further apart: Gluteus Maximus is emphasized, Quadriceps are less emphasized.	{AUXILIARY}	{COMPOUND}	{PUSH}	{DUMBBELL}	f	f
Dumbbell Step Down	Hold dumbbells in each hand down to sides and stand with one foot on bench. Position foot on bench to side slightly forward of straight knee.	Stand on bench by straightening leg and pushing body upward. Step down returning foot off of bench to floor and repeat. Continue with opposite position.	Keep torso upright during exercise. Knee of exercised leg should point same direction as foot. Exercise can also be performed by placing traveling foot onto and off of bench next to foot of exercised leg. See alternative form.	{AUXILIARY}	{COMPOUND}	{PUSH}	{DUMBBELL,BENCH}	f	f
Dumbbell Lying Hip Abduction	Lie on side on floor or mat. Extend top leg down straight and position lower leg back underneath. Grasping dumbbell with hand of arm furthest from floor, position dumbbell as low as possible on top side of thigh.	Raise weighted leg up off ground as high as possible, keeping dumbbell positioned on side of upper thigh. Return to leg to floor and repeat. Repeat and continue with opposite leg.	Do not allow upper hip to fall behind upper hip throughout movement. See ROM Criteria and Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PUSH}	{DUMBBELL}	f	f
Dumbbell Side Lying Rear Delt Raise	Lie on side with legs separated for support. Grasp dumbbell in front of chest, palm facing down, arm extended forward with slight bend.	Raise dumbbell from floor until it travels above shoulder. Return dumbbell to floor at original position. Repeat.	Maintain fixed elbow position straight or slightly bent and keep upper arm perpendicular to trunk throughout exercise.	{AUXILIARY}	{COMPOUND}	{PULL}	{DUMBBELL}	f	f
Dumbbell Incline Lateral Raise	Grasp dumbbell in one hand. Lie on 30° to 45° incline bench with opposite side of body on incline, arm over top of bench, lower leg positioned on front side of seat, and upper leg on back side of seat. Position dumbbell inside of lower leg, just in front of upper leg.	Raise dumbbell from until upper arm is perpendicular to torso. Maintain slight fixed bend in elbow throughout exercise. Lower dumbbell to front of upper leg and repeat.	In order for lateral deltoid to be exercised, dumbbell must be raised by shoulder abduction, not external rotation. Also see exercise Dumbbell Incline Lateral Raise performed on preacher bench.	{AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL,BENCH,PREACHER}	f	f
Dumbbell Lateral Raise	Grasp dumbbells in front of thighs with elbows slightly bent. Bend over slightly with hips and knees bent slightly.	Raise upper arms to sides until slightly bent elbows are shoulder height while maintaining elbows' height above or equal to wrists. Lower and repeat.	Keep elbows pointed high while maintaining slight bend through elbows (10° to 30° angle) throughout movement. At top of movement, elbows (not necessarily dumbbells) should be directly lateral to shoulders since elbows are slightly bent forward. Dumbbells are raised by shoulder abduction, not external rotation. If elbows drop lower than wrists, front deltoids become primary mover instead of lateral deltoids. To keep resistance targeted to side delt, torso is bent over slightly. See other view and Lateral Raise Errors.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL}	f	f
Dumbbell Seated Lateral Raise	Sit on end of bench with dumbbell in each hand and legs together. Position dumbbells with palms facing inward and arms hanging down slightly bent.	Raise upper arms to sides until slightly bent elbows are shoulder height while maintaining elbows' height above or equal to wrists. Lower and repeat.	Maintain fixed elbow position (10° to 30° angle) throughout exercise. At top of movement, elbow (not necessarily dumbbell) should be directly lateral to shoulder since elbow is slightly bent forward. Dumbbell is raised by shoulder abduction, not external rotation. As elbow drops lower than wrist, front deltoid becomes primary mover instead of lateral deltoid. See Lateral Raise Errors.	{AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL,BENCH}	f	f
Dumbbell Lying One Arm Rear Lateral Raise	With dumbbell in one hand, lie chest down on elevated bench. Position palm forward (thumb up) with elbow straight or slightly bent.	Raise upper arm to side until elbow is shoulder height. Maintain upper arms perpendicular to torso with elbow straight throughout exercise. Maintain palm forward position. Lower and repeat.	Bench should be horizontal and be high enough to prevent dumbbell from touching floor. Upper arm should travel in perpendicular path to torso to minimize latissimus dorsi involvement. Bench should be high enough to prevent dumbbells from hitting floor and close to horizontal. Lying at 45° is not sufficient angle to target rear deltoids. This exercise AKA "prone full can" has been suggested to exercise supraspinatus muscle in rehabilitation settings (Blackburn TA, et al. 1990; Reinold MM, et al. 2007). See exercise performed on propped incline bench.	{AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL,BENCH}	f	f
Dumbbell Seated Rear Lateral Raise	Sit on edge of bench with feet placed beyond knees. Bend over and rest torso on thighs. Grasp dumbbells with each hand under legs. Position elbows with slight bend with palms facing together behind ankles (as shown) or just to sides of ankles.	Raise upper arms to sides until elbows are shoulder height. Maintain upper arms perpendicular to torso and fixed elbow position (10° to 30° angle) throughout exercise. Maintain elbows height above wrists by raising "pinkie finger" side up. Lower and repeat.	Dumbbells are raised by shoulder transverse abduction, not external rotation, nor extension. Upper arm should travel in perpendicular path to torso to minimize relatively powerful latissimus dorsi involvement. This mean at top of movement, elbows (not necessarily dumbbells) should be directly lateral to shoulders since elbows are slightly bent forward. To exercise posterior deltoid and not lateral deltoid, keep upper torso close to horizontal. Positioning upper torso at 45° is not sufficient angle to target rear deltoids. The spine can be flexed to achieve this positioning if thighs can provide sufficient support for torso. Some individuals may not be able to bend sufficiently at hip due to flexibility or girth constraints. Also see Rear Lateral Raise Errors and Low Back Alignment Exceptions.	{AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL,BENCH}	f	f
Dumbbell Front Lateral Raise	Grasp dumbbell and position in front of thigh with arm straight. Turn pinkie finger side outward.	Raise arms to side, slightly to front until shoulder height or slightly higher. Lower and repeat. Continue with opposite arm.	Raise toward 10 o'clock with left arm and toward 2 o'clock with right arm. Maintain straight elbow position with elbow pointing outward throughout exercise.	{AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL}	f	f
Dumbbell Straight Leg Deadlift (Romanian)	Stand with shoulder width or narrower stance. Grasp dumbbells to sides.	With knees straight, lower dumbbells to top or sides of feet by bending hips. Allow hips to fall back and bend waist as dumbbell approaches feet. Lift dumbbells by extending hips and waist until standing upright. Pull shoulders back if rounded. Repeat.	Begin with very light weight and add additional weight gradually to allow lower back adequate adaptation. Throughout lift keep arms and knees straight. Keep dumbbells close to legs. Do not pause or bounce at bottom of lift. Lower back may bend slightly during full hip flexion phase. Do not lower weight beyond mild stretch throughout hamstrings and low back. Full range of motion will vary from person to person depending on flexibility. See Dangerous Exercise Essay.	{BASIC}	{COMPOUND}	{PULL}	{DUMBBELL}	f	f
Dumbbell Russian Twist (on stability ball)	With dumbbell in hand, sit on stability ball. Roll body down and lie with back on ball, hips nearly straight, and feet apart on floor. Hold onto dumbbell with both hands with arms extending straight upward.	Turn torso to one side while keeping arms straight and perpendicular to torso throughout movement. Return dumbbell back over shoulders by rotating torso to original position. Continue lowering dumbbell to opposite side. Repeat.	Both arms should be kept straight and perpendicular to torso. Hips should also be kept nearly straight, only slightly bent. See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{DUMBBELL,STABILITY_BALL}	f	f
Dumbbell Alternating Front Raise	Grasp dumbbells in both hands. Position dumbbells in front of upper legs with elbows straight or slightly bent.	Raise one dumbbell forward and upward with palms positioned downward until upper arm is above horizontal. Lower and repeat with opposite arm, alternating between arms.	Height of movement may depend on range of motion. Raise should be limited to height achieved just before tightness is felt in shoulder capsule. Alternatively, height just above horizontal may be considered adequate. Elbows may be kept straight or slightly bent throughout movement. Also see Dumbbell Front Raise.	{AUXILIARY}	{ISOLATED}	{PUSH}	{DUMBBELL}	f	f
Incline Twisting Crunch	Hook feet under foot bar and lie supine on incline bench with hips bent. Place hands behind neck.	Flex and twist waist to raise upper torso from bench to one side. Return until back of shoulders contact padded incline board. Repeat to opposite side alternating twists.	Certain individuals may need to keep their neck in neutral position with space between their chin and sternum. If no knee support is built in to incline board, ball can be placed under legs. Hip and knee flexors may be involved as stabilizers if incline is steep and no calf support is used. See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{BENCH}	t	f
Cable Supine Reverse Fly	With bench between two high pulleys to each side, grasp left stirrup with right hand and right stirrup with left hand. Lie on bench with pulleys to each side of shoulders. Arms should be crossed above upper chest with elbows slightly bent.	Pull upper arms down to sides until elbows are shoulder height. Maintain upper arms perpendicular to torso and fixed elbow position (just slightly bent) as arms are pulled down to sides. Return arms to original position and repeat.	Upper arm should travel perpendicular to torso to minimize latissimus dorsi involvement. Elbows may bend slightly at top of movement (as shown) or they may be kept fixed.	{AUXILIARY}	{ISOLATED}	{PULL}	{CABLE,BENCH,PULL_UP_BAR}	f	f
Twisting Sit-up	Place feet under foot bar or low overhanging stationary object. Lie supine on floor, mat, or sit-up bench with hips and knees bent. Place hands behind neck.	Flex and twist waist to one direction while raising torso from bench by bending hips. Return until back of shoulders contact floor or mat. Repeat to opposite side alternating twists.	Feet can be held down by partner instead of foot bar. Certain individuals may need to keep their neck in neutral position with space between their chin and sternum. If upper back does not come completely down at end of movement, abdominal muscles may only be isometrically involved in exercise. Pectineus, Adductor Longus, and Brevis do not assist in hip flexion since hips are already initially bent. See Spot Reduction Myth.	{BASIC}	{COMPOUND}	{PULL}	{BENCH}	t	f
Sit-up	Hook feet under foot brace or secure low overhang. Lie supine on floor or bench with hips bent. Place hands behind neck or on side of neck.	Raise torso from bench by bending waist and hips. Return until back of shoulders contact incline board. Repeat.	Feet can be held down by partner instead of foot bar. Certain individuals may need to keep their neck in neutral position with space between their chin and sternum. If upper back does not come completely down at end of movement, abdominal muscles may only be isometrically involved in exercise. Pectineus, Adductor Longus, and Brevis do not assist in hip flexion since hips are already initially bent. See Spot Reduction Myth. Also see Dangerous Exercise Essay.	{BASIC}	{COMPOUND}	{PULL}	{BENCH}	t	f
Weighted Bench Dip	Sit on inside of one of two benches placed parallel, slightly less than leg's length away. Place hands on edge of bench. Straighten arms, slide rear end off of edge of bench and position heels on adjacent bench with legs straight. Have assistant place weight on lap near hips.	Lower body by bending arms until slight stretch is felt in chest or shoulder, or rear end touches floor. Raise body and repeat.	Bench height should allow for full range of motion. If assistant is not available, place weight on lap sitting on floor or edge of bench.	{BASIC}	{COMPOUND}	{PUSH}	{BENCH}	f	f
Weighted Parallel Close Grip Pull-up	Step up and grasp close grip parallel bars.	Pull body up until elbow are to sides. Lower body until arms and shoulders are fully extended. Repeat.	Added weight can be placed on dip belt or dumbbell can be placed between ankles. Also see Parallel Close Grip Pull-up without added weight.	{BASIC}	{COMPOUND}	{PULL}	{PULL_UP_BAR}	f	f
Weighted Inverted Row	Lay on back under fixed horizontal bar. Grasp bar with wide overhand grip. Place back of heels on elevated surface.	Keeping body straight, pull body up to bar. Return until arms are extended and shoulders are stretched forward. Repeat.	Fixed bar should be just high enough to allow arm to fully extend. Placing back of heels on elevated surface is optional. This exercise is typically performed without added resistance, although a weight vest can be worn or additional weight can be placed on belly or pelvis. Partner can add and remove weight, and keep weight from sliding off belly. Resistance can be further reduced by performing movement from higher bar and/or positioning heels on floor (see Inverted Row on high bar). See Gravity Vectors for greater understanding of how body angle influences resistance. Also known as Weighted Body Row or Weighted Supine Row.	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{BARBELL}	f	f
Weighted Push-up	Lie prone on floor with hands slightly wider than shoulder width. Raise body up off floor by extending arms with body straight. Partner can place weight plate(s) on back if needed.	Keeping body straight, lower body to floor by bending arms. Push body up until arms are extended. Repeat.	Both upper and lower body must be kept straight throughout movement. Exercise can be performed without additional weight. If additional weight is used, partner will need to add and remove weight, and keep weight from sliding off back. See narrower grip push-up.	{BASIC,AUXILIARY}	{COMPOUND}	{PUSH}	{}	f	f
Weighted Reverse Hyper-extension	Place sandbag or medicine ball between ankles. Lay torso and waist on bench and grasp handles. Feet should be above floor with legs straight.	Raise weight by extending hips as high as possible until legs are nearly straight. Lower legs to original position. Repeat.	Exercise can be performed without added weight. Some individuals may be able to articulate both through the hips and through the lower back (i.e. lumbar spine), in which case, Erector Spinae also becomes synergist.	{AUXILIARY}	{ISOLATED}	{PUSH}	{BENCH}	f	f
Weighted Single Leg Squat	Stand with arms extended out in front holding medicine ball or weight plate. Balance on one leg with opposite leg extended forward off of ground.	Squat down as far as possible while keeping leg elevated off of floor. Keep supporting knee pointed same direction as foot supporting. Raise body back up to original position until knee and hip of supporting leg is straight. Return and repeat. Continue with opposite leg.	Supporting knee should point same direction as foot throughout movement. Range of motion will be improved with greater leg strength and glute flexibility. Significant spinal flexion occurs at bottom of deep single leg squat to maintain center of gravity over foot. Erector Spinae becomes a stabilizer if spine is kept straight.	{AUXILIARY}	{COMPOUND}	{PUSH}	{}	f	f
Weighted Lying Hip Abduction	Sit on floor or mat with bar, plates loaded on one side. Sit on hip with knees bent and place bar on outside of shoe with weight plate(s) positioned beyond foot. Holding on to opposite end of bar, lie on side with weighted leg extended out straight and lower leg bent underneath.	Raise weighted leg up off ground as high as possible. Balance bar on side of foot while holding onto closest side of bar. Return to floor and repeat. Continue with opposite leg.	Do not allow upper hip to fall behind upper hip throughout movement. See ROM Criteria and Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PUSH}	{}	f	f
Weighted Hanging Leg Raise	Place weight between ankles or use no weight. Grasp and hang from high bar.	Raise legs by flexing hips and knees until hips are completely flexed or knees are well above hips. Return until hips and knees are extended. Repeat.	Rectus Abdominis and Obliques only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion. Exercise may be performed with ab straps. It may be necessary to completely flex hips before waist flexion is possible; see Weighted Hanging Leg-Hip Raise.	{AUXILIARY}	{ISOLATED}	{PULL}	{PULL_UP_BAR}	f	f
Weighted Hanging Straight Leg Raise	Place weight between ankles or use no weight. Grasp and hang from high bar.	With knees straight, raise legs by flexing hips until thighs are just past parallel to floor. Return until hips are extended downward. Repeat.	Rectus Abdominis and Obliques only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion. It may be necessary to completely flex hips before waist flexion is possible; see Weighted Hanging Leg-Hip Raise.	{AUXILIARY}	{ISOLATED}	{PULL}	{PULL_UP_BAR}	f	f
Weighted Pull-up	Step up and grasp bar with overhand wide grip.	Pull body up until chin is above bar. Lower body until arms and shoulders are fully extended. Repeat.	Added weight can be placed on dip belt or dumbbell can be placed between ankles as shown. Range of motion will be compromised if grip is too wide. Also see Pull-up without added weight.	{BASIC}	{COMPOUND}	{PULL}	{PULL_UP_BAR}	f	f
Weighted Incline Straight Leg Raise	Sit on incline board. Place weight between ankles. Lie supine on incline board with torso elevated. Grasp feet hooks or sides of board for support.	With knees straight, raise legs by flexing hips until thighs are just past perpendicular to torso. Return until hips and knees are extended. Repeat.	Rectus Abdominis and Obliques only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion. It may be necessary to completely flex hips before waist flexion is possible; see Weighted Incline Leg-Hip Raise. Care should be taken not to have weight falling over or thrown onto sensive bodily areas. For this reason increasing incline to increase intensity may be wiser than adding additional weight.	{AUXILIARY}	{ISOLATED}	{PULL}	{BENCH}	f	f
Weighted Incline Leg Raise	Sit on incline board. Place weight between feet or use no weight. Lie supine on incline board with torso elevated. Grasp feet hooks or sides of board for support.	Raise legs by flexing hips and knees until hips are completely flexed. Return until hips and knees are extended. Repeat.	Rectus Abdominis and Obliques only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion. It may be necessary to completely flex hips before waist flexion is possible; see Weighted Incline Leg-Hip Raise.	{AUXILIARY}	{ISOLATED}	{PULL}	{BENCH}	f	f
Weighted Vertical Leg Raise	Place weight between ankles or use no weight. Position forearms on padded parallel bars with hands on handles, and back on vertical pad.	Raise legs by flexing hips and knees until hips are completely flexed or knees are well above hips. Return until hips and knees are extended. Repeat.	Rectus Abdominis and Obliques only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion. It may be necessary to completely flex hips before waist flexion is possible; see Weighted Vertical Leg-Hip Raise.	{AUXILIARY}	{ISOLATED}	{PULL}	{PARALLEL_BARS}	f	f
Weighted Vertical Straight Leg Raise	Place weight between ankles or use no weight. Position forearms on padded parallel bars with hands on handles, and back on vertical pad.	With knees straight, raise legs by flexing hips until thighs are just past parallel to floor. Return until hips are extended. Repeat.	Rectus Abdominis and Obliques only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion. It may be necessary to completely flex hips before waist flexion is possible; see Weighted Vertical Leg-Hip Raise.	{AUXILIARY}	{ISOLATED}	{PULL}	{PARALLEL_BARS}	f	f
Weighted Glute-Ham Raise		From upright position, lower body by straightening knees until body is horizontal. Continue to lower torso by bending hips until body is upside down. Raise torso by extending hips until fully extended. Continue to raise body by flexing knees until body is upright. Repeat.	Weight can be positioned closer (easier) or further away (harder) from hips to adjust intensity; see Arm Position During Waist Exercises. Exercise can be performed without added weight until more resistance is needed.	{BASIC,AUXILIARY}	{ISOLATED}	{PULL}	{}	f	f
Weighted Crunch (on stability ball)	Sit on exercise ball. Walk forward on ball and lie back on ball with shoulders and head hanging off and knees and hips bent. Gently hyperextend back to contour of ball. Hold plate behind neck or on chest with both hands or use no weight.	Flex waist to raise upper torso. Return to original position. Repeat.	Certain individuals may need to keep their neck in neutral position with space between their chin and sternum. Exercise can be performed without added weight until more resistance is needed. Movement can be made easier by positioning hips low on ball. In contrast, exercise can be made more challenging by using positioning ball lower on back and hips higher. Some individuals may experience low back discomfort if hips are not bent so they must use smaller ball size or lower their hip position on ball. See Arm Position During Waist Exercises and Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{STABILITY_BALL}	f	f
Weighted Incline Crunch	Hook feet under support and lie supine on incline bench with hips bent. Hold plate behind neck or clasp hands behind neck with no weight.	Flex waist to raise upper torso from bench. Keep low back on bench and raise torso up as high as possible. Return until back of shoulders contact padded incline board. Repeat.	Exercise can be performed without added weight until more resistance is needed. Elevate incline to increase resistance. See Arm Position During Waist Exercises. Certain individuals may need to keep their neck in neutral position with space between their chin and sternum. Hip and knee flexors may be involved as stabilizers if incline is steep and no calf support is used. Also see intermediate technique. See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{BENCH}	f	f
Weighted Incline Sit-up	Hook feet under support and lie supine on incline bench with hips bent. Hold plate behind neck or clasp hands behind neck with no weight.	Raise torso from bench by bending waist and hips. Return until back of shoulders contact padded incline board. Repeat.	Exercise can be performed without added weight until more resistance is needed. Incline can also be elevated to increase resistance. See Arm Position During Waist Exercises. Certain individuals may need to keep their neck in neutral position with space between their chin and sternum. If upper back does not come completely down at end of movement, abdominal muscles may only be isometrically involved in exercise. Pectineus, Adductor Longus, and Brevis do not assist in hip flexion since hips are already initially bent. Knee flexors may be involved as stabilizers if incline is steep and no calf support is used. See Spot Reduction Myth. Also see Dangerous Exercise Essay.	{BASIC}	{COMPOUND}	{PULL}	{BENCH}	f	f
Weighted Lying Twist	On floor or mat, place exercise ball between lower legs. Lie on back with arms extended out to sides. Raise legs upward with knees slightly bent.	Lower legs to one side until side of thigh is on floor. Raise and lower legs to opposite side. Repeat.	Maintain knee position throughout movement. For less resistance, bend knees more and/or do not use additional weight. See Spot Reduction Myth. Also see Bent-knee Lying Twist.	{AUXILIARY}	{ISOLATED}	{PULL}	{}	f	f
Weighted Sit-up	Hook feet under support and lie supine on floor or mat with hips bent. Hold plate behind neck.	Raise torso from floor by bending waist and hips. Return until back of shoulders contact with floor or mat. Repeat.	Feet can be held down by partner instead of foot bar. Exercise can be performed without added weight until more resistance is needed. Exercise can be performed on incline board to increase resistance or decline board to decrease resistance. See Arm Position During Waist Exercises. Certain individuals may need to keep their neck in neutral position with space between their chin and sternum. If upper back does not come completely down at end of movement, abdominal muscles may only be isometrically involved in exercise. Pectineus, Adductor Longus, and Brevis do not assist in hip flexion since hips are already initially bent. See Spot Reduction Myth. Also see Dangerous Exercise Essay.	{BASIC}	{COMPOUND}	{PULL}	{}	f	f
Weighted Hanging Leg-Hip Raise	Place weight between ankles or use no weight. Grasp and hang from high bar.	Raise legs by flexing hips and knees until hips are fully flexed. Continue to raise knees toward shoulders by flexing waist. Return until waist, hips, and knees are extended. Repeat.	Exercise can be performed without added weight until more resistance is needed. Also see Hanging Leg Hip Raise with Ab Straps. Rectus Abdominis and Obliques dynamically contract only if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only isometrically contract to stabilize pelvis and waist during hip flexion. It may be necessary to completely flex hips before waist flexion is possible. See Spot Reduction Myth and Lower Ab Myth. Also Weighted Hanging Leg Raise.	{BASIC}	{COMPOUND}	{PULL}	{PULL_UP_BAR}	f	f
Weighted Vertical Leg-Hip Raise	Place weight between ankles or use no weight. Position forearms on padded parallel bars with hands on handles and back on vertical pad.	Raise legs by flexing hips and knees until hips are fully flexed. Continue to raise knees toward shoulders by flexing waist, raising hips from back board. Return until waist, hips, and knees are extended. Repeat.	Exercise can be performed without added weight until more resistance is needed. Rectus Abdominis and Obliques dynamically contract only if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only isometrically contract to stabilize pelvis and waist during hip flexion; see Weighted Vertical Leg Raise. It may be necessary to completely flex hips before waist flexion is possible. See Spot Reduction Myth and Lower Ab Myth.	{BASIC}	{COMPOUND}	{PULL}	{PARALLEL_BARS}	f	f
Weighted Bent-knee Lying Twist	On floor or mat, place medicine ball between bent knees. Lie on back with arms extended out to sides. Raise bent legs so thighs are vertical and lower legs are horizontal.	Lower legs to one side until side of thigh is on floor. Raise and lower legs to opposite side. Repeat.	Maintain knee position throughout movement. For less resistance, do not use additional weight (See Bent-knee lying Twist without ball). See Spot Reduction Myth. Also see Lying Twist with exercise ball.	{AUXILIARY}	{ISOLATED}	{PULL}	{}	f	f
Weighted Incline Leg-Hip Raise	Sit on incline board. Place weight between ankles or use no weight. Lie supine on incline board with torso elevated. Grasp feet hooks or sides of board by head for support.	Raise legs by flexing hips while flexing knees until hips are fully flexed. Continue to raise knees toward shoulders by flexing waist, raising hips from board. Return until waist, hips and knees are extended. Repeat.	Exercise can be performed without added weight until more resistance is needed. Elevate incline to increase resistance. When raising hips, keep knees fully flexed, so as not to throw weight of lower legs over head.	{BASIC}	{COMPOUND}	{PULL}	{BENCH}	f	f
Weighted Side Crunch	Lie upper back supine on floor or mat. With both legs together, knees and hips bent, position outside of leg down to side. Use no weight or hold weight to opposite side of head or across upper chest.	Flex waist, raising upper torso off surface. Return until back of shoulders return to surface. Repeat and continue with movement in opposite position.	Exercise can be performed without added weight until more resistance is needed. Certain individuals ma y need to keep their neck in neutral position with space between their chin and sternum. See Spot Reduction Myth and Arm Position During Waist Exercises.	{AUXILIARY}	{ISOLATED}	{PULL}	{}	f	f
Weighted Side Crunch (on stability ball)	Sit on exercise ball. Walk forward on ball and lie back on ball with shoulders and head hanging off. Switch position of feet by positioning bent leg under extended leg so waist is twisted with hip positioned sideways. Gently hyperextend back to contour of ball. Hold plate behind neck or on chest with both hands or use no weight.	Flex waist to raise upper torso. Return to original position and repeat. Position legs in opposite position and continue.	Certain individuals may need to keep their neck in neutral position with space between their chin and sternum. Exercise can be performed without added weight until more resistance is needed. Movement can also be made easier by po sitioning hip low on ball or by using no added weight. In contrast, exercise can be made more challenging by positioning hip higher on ball. In which case, feet may be placed against base of wall for stability. Also see Spot Reduction Myth and Arm Position During Waist Exercises.	{AUXILIARY}	{ISOLATED}	{PULL}	{STABILITY_BALL}	f	f
Weighted Twisting Crunch (on stability ball)	Sit on exercise ball. Walk forward on ball and lie back on ball with shoulders and head hanging off and knees and hips bent. Gently hyperextend back to contour of ball. Hold plate behind neck or on chest with both hands or use no weight.	Flex waist to raise upper torso. Return to original position and repeat.	Weight can be held behind neck. Certain individuals may need to keep their neck in neutral position with space between their chin and sternum. Exercise can be performed without added weight until more resistance is needed. Movement can be made easier by positioning hips low on ball. In contrast, exercise can be made more challenging by positioning ball lower on back and hips higher. Some individuals may experience low back discomfort if hips are not bent, so they must use smaller ball size or lower their hip position on ball. See Arm Position During Waist Exercises and Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{STABILITY_BALL}	f	f
Weighted Russian Twist (on stability ball)	With weight plate or medicine ball in hand, sit on stability ball. Roll body down and lie with back on ball, hips nearly straight, and feet apart on floor. Hold onto weight with both hands with arms extending straight upward.	Turn torso to one side while keeping arms straight and perpendicular to torso throughout movement. Return weight back over shoulders by rotating torso to original position. Continue lowering weight to opposite side. Repeat.	Both arms should be kept straight and perpendicular to torso. Hips should also be kept nearly straight, only slightly bent. See Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{STABILITY_BALL}	f	f
Weighted Side Bend (on stability ball)	Lie on ball on side of torso, waist, and hip. Position legs outward with feet on floor or against floor board. Hold weight behind or above head.	Raise side of torso up by laterally flexing waist. Lower torso back on ball and repeat. Position other side on ball and repeat with opposite side.	Exercise can be performed without added weight until more resistance is needed. Movement can also be made easier by positioning hip low on ball. In contrast, exercise can be made more challenging by positioning hip higher on ball. In which case, feet may be placed against base of wall for stability. See alternative form. Also see Spot Reduction Myth and Arm Position During Waist Exercises.	{AUXILIARY}	{ISOLATED}	{PULL}	{STABILITY_BALL}	f	f
Weighted Back Extension (on stability ball)	Lie prone on ball. Position toes out wide on floor for balance. Hold weight under chin or behind neck.	Raise torso off of ball by hyperextending spine. Lower torso onto ball allowing spine to flex. Repeat.	Movement can be made easier by using no additional weight or by positioning hips low on ball. In contrast, exercise can be made more challenging by positioning ball lower toward hip. In which case, feet may be placed against base of wall for stability. See Arm Position During Waist Exercises. If weight is positioned behind head, neck extensors act as stabilizers.	{AUXILIARY}	{ISOLATED}	{PULL}	{STABILITY_BALL}	f	f
Weighted Hyperextension	Position thighs prone on large pad and lower legs under padded brace. Hold weight to chest or behind neck.	Raise upper body until hips and waist are fully extended. Lower body by bending hips and waist until mild stretch is felt or torso is vertical. Repeat.	If weight is positioned behind head, neck extensors act as stabilizers:	{BASIC,AUXILIARY}	{COMPOUND}	{PULL}	{BENCH}	f	f
Weighted Neutral Grip Pull-up	Step up and grasp bar with neutral grip.	Pull body up until neck reaches height of hands. Lower body until arms and shoulders are fully extended. Repeat.	Added weight can be placed on dip belt or dumbbell can be placed between ankles.  Also see Neutral Grip Pull-up without added weight.	{BASIC}	{COMPOUND}	{PULL}	{PULL_UP_BAR}	f	f
Weighted Chin-up	Step up and grasp bar with underhand shoulder width grip.	Pull body up until elbows are to sides. Lower body until arms and shoulders are fully extended. Repeat.	Added weight can be placed on dip belt or dumbbell can be placed between ankles. Also see Chin-up without added weight.	{BASIC}	{COMPOUND}	{PULL}	{PULL_UP_BAR}	f	f
Weighted Rear Pull-up	Step up and grasp bar with overhand wide grip.	Pull body up until bar touches back of neck. Lower body until arms and shoulders are fully extended. Repeat.	Added weight can be placed on dip belt (as shown) or dumbbell can be placed between ankles. Range of motion will be compromised if grip is too wide. Also see Rear Pull-up without added weight.	{BASIC}	{COMPOUND}	{PULL}	{PULL_UP_BAR}	f	f
Weighted Chest Dip	Place weight on dip belt around waist or place dumbbell between lower legs just above feet. Mount wide dip bar with oblique grip (bar diagonal under palm), arms straight with shoulders above hands. Keep hips and knees bent.	Lower body by bending arms, allowing elbows to flare out to sides. When slight stretch is felt in chest or shoulders, push body up until arms are straight. Repeat.	Added weight can be placed on dip belt or dumbbell can be placed between ankles. Also see Weighted Triceps Dip and Chest Dip.	{BASIC}	{COMPOUND}	{PUSH}	{PARALLEL_BARS}	f	f
Weighted Overhead Crunch (on stability ball)	Sit on exercise ball with medicine ball in hands. Walk forward on ball and lie back on ball with shoulders and head hanging off and knees and hips bent. Gently hyperextend back to contour of ball. Position medicine ball over upper chest with arms extended.	Keeping arms extended and medicine ball over upper chest, flex waist to raise upper torso. Return to original position. Repeat.	If ball is positioned lower than upper chest (eg: over waist), effective resistance dramatically diminishes. See how length of lever arm affects resistance. Movement can be made easier by positioning hips low on ball. In contrast, exercise can be made more challenging by using positioning ball lower on back and hips higher. Some individuals may experience low back discomfort if hips are not bent so they must use smaller ball size or lower their hip position on ball. See Arm Position During Waist Exercises and Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{STABILITY_BALL}	f	f
Weighted Neutral Grip Chin-up	Reach up and grasp bars angled inward with underhand shoulder width grip.	Pull body up until elbows are to sides. Lower body until arms and shoulders are fully extended. Repeat.	Added weight can be placed on dip belt or dumbbell can be placed between ankles. Also see Neutral Grip Chin-up without added weight.	{BASIC}	{COMPOUND}	{PULL}	{PULL_UP_BAR}	f	f
Weighted V-up	Sit on floor or mat. Place dumbbell between feet. Lie supine with hands on floor over head.	While keeping feet together, simultaneously raise straight legs and torso. Reach toward raised feet. Return to starting position. Repeat.	Weight can also be held with hands and feet at same time. Keep knees straight throughout movement. Begin each repetition with upper back on floor to allow abdominal muscles to work dynamically. The Rectus Abdominis and Obliques dynamically contract only when actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only isometrically contract to stabilize pelvis and waist during hip flexion. See Spot Reduction Myth and Lower Ab Myth.	{BASIC}	{COMPOUND}	{PULL}	{}	f	f
Weighted Close Grip Push-up	Lie prone on floor with hands under shoulders or slightly narrower. Position body up off floor with extended arms and body straight. Partner can place weight plate(s) on back if needed.	Keeping body straight, lower body to floor by bending arms. Push body up until arms are extended. Repeat.	Both upper and lower body must be kept straight throughout movement. Exercise can be performed without additional weight (See Close Grip Pushup without weight). If additional weight is used, partner will need to add and remove weight, and keep weight from sliding off back. See wider grip push-up.	{BASIC}	{COMPOUND}	{PUSH}	{PULL_UP_BAR}	f	f
Weighted Lying Leg-Hip Raise	Place weight between ankles or use no weight. Lie supine on bench or floor. Grasp sides of bench for support.	Raise legs by flexing hips while flexing knees until hips are fully flexed. Continue to raise knees toward shoulders by flexing waist, raising hips from board. Return until waist, hips and knees are extended. Repeat.	Exercise can be performed without added weight until more resistance is needed. When raising hips, keep knees fully flexed, so as not to throw weight of lower legs over head. Rectus Abdominis and Obliques dynamically contract only if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only isometrically contract to stabilize pelvis and waist during hip flexion. It may be necessary to completely flex hips before waist flexion is possible. See Spot Reduction Myth and Lower Ab Myth. Also see Weighted Incline Leg Raise.	{BASIC}	{COMPOUND}	{PULL}	{}	f	f
Weighted Twisting Sit-up	Place feet under low overhanging stationary object. Lie supine on floor or mat with hips and knees bent. Hold plate behind neck with both hands.	Flex and twist waist to one direction while raising torso from bench by bending hips. Return until back of shoulders contact floor or mat. Repeat to opposite side alternating twists.	Feet can be held down by partner instead of foot bar. Exercise can be performed without added weight until more resistance is needed. Add more weight or perform on incline board to increase resistance. Also see Arm Position During Waist Exercises. Certain individuals may need to keep their neck in neutral position with space between their chin and sternum. Also see exercise with weight placed on chest. If upper back does not come completely down at end of movement, abdominal muscles may only be isometrically involved in exercise. Pectineus, Adductor Longus, and Brevis do not assist in hip flexion since hips are already initially bent. See Spot Reduction Myth.	{BASIC}	{COMPOUND}	{PULL}	{}	f	f
Weighted Seated Leg Raise	Sit on edge of bench with legs extended to floor. Place weight between ankles. Grasp edge of bench. Lean torso back and balance bodyweight on edge of bench.	Raise legs by flexing hips and knees while pulling torso slightly forward to maintain balance. Return by extending hips and knees and lean torso back to counter balance. Repeat.	Heels may make contact with floor to maintain balance at bottom of movement. Rectus Abdominis and Obliques only contract dynamically if actual waist flexion occurs. With no waist flexion, Rectus Abdominis and External Oblique will only act to stabilize pelvis and waist during hip flexion. It may be necessary to completely flex hips before waist flexion is possible. Exercise can be performed without added weight until more resistance is needed (See Seated Leg Raise without weight). Also known as Weighted Knee Tuck across bench. Also see Spot Reduction Myth and Lower Ab Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{}	f	f
Weighted Triceps Dip	Place weight on dip belt around waist or place dumbbell between lower legs just above feet. Mount shoulder width dip bar, arms straight with shoulders above hands. Keep hips straight.	Lower body until slight stretch is felt in shoulders. Push body up until arms are straight. Repeat.	Exercise can also be performed without weight. Also see Weighted Chest Dips.	{BASIC}	{COMPOUND}	{PUSH}	{PARALLEL_BARS}	f	f
Weighted Crunch	Lie supine on bench with head hanging off and knees and hips bent. Hold plate behind neck.	Flex waist to raise upper torso from bench. Keep low back on bench and raise torso up as high as possible. Return until back of shoulders contact padded incline board. Repeat.	Exercise can be performed without added weight until more resistance is needed. Certain individuals may need to keep their neck in neutral position with space between their chin and sternum. See Arm Position During Waist Exercises and Spot Reduction Myth.	{AUXILIARY}	{ISOLATED}	{PULL}	{}	f	f
Weighted Lying Leg Raise	Sit on end of bench. Place weight between feet. Lie supine on bench. Grasp bench on each side behind head for support.	Raise legs by flexing hips and knees until hips are completely flexed. Return until hips and knees are extended. Repeat.	Exercise can be performed without added weight until more resistance is needed (see Lying Leg Raise). Knees may be kept extended throughout leg raise to increase intensity.	{AUXILIARY}	{ISOLATED}	{PULL}	{}	f	f
Weighted Twisting Crunch	Lie supine on floor or bench with knees and hips bent. Hold plate behind neck or on chest with both hands.	Flex and twist waist to raise upper torso off surface to one side. Return until back of shoulders return to surface. Repeat to opposite side alternating twists.	If weight is held behind head, position head hanging off bench. See Spot Reduction Myth. Certain individuals may need to keep their neck in neutral position with space between their chin and sternum. See Arm Position During Waist Exercises.	{AUXILIARY}	{ISOLATED}	{PULL}	{}	f	f
Weighted Incline Twisting Sit-up	Hook feet under foot or ankle brace and lie supine on incline bench with hips and knees bent. Hold plate behind neck with both hands.	Flex and twist waist to one direction while raising torso from bench by bending hips. Return until back of shoulders contact padded incline board. Repeat to opposite side, alternating twists.	Exercise can be performed without added weight until more resistance is needed. Elevate incline to increase resistance. See Arm Position During Waist Exercises. Certain individuals may need to keep their neck in neutral position with space between their chin and sternum. If upper back does not come completely down at end of movement, abdominal muscles may only be isometrically involved in exercise. Pectineus, Adductor Longus, and Brevis do not assist in hip flexion since hips are already initially bent. Knee flexors may be involved as stabilizers if incline is steep and no calf support is used. See Spot Reduction Myth.	{BASIC}	{COMPOUND}	{PULL}	{BENCH}	f	f
\.


--
-- Data for Name: ExcerciseMetadata; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."ExcerciseMetadata" (excercise_metadata_state, "haveRequiredEquipment", preferred, last_excecuted, best_weight, weight_unit, best_rep, rest_time_lower_bound, rest_time_upper_bound, user_id, excercise_name) FROM stdin;
LEARNING	\N	\N	2022-08-09 15:10:36.219	50	KG	3	90	150	49	Cable Underhand Pulldown
LEARNING	\N	\N	2022-08-09 15:10:36.303	0	KG	0	90	150	49	Incline Sit-up
LEARNING	\N	\N	2022-08-13 18:35:08.087	20	LB	5	90	150	73	Barbell Lying Triceps Extension
LEARNING	\N	\N	2022-08-13 18:35:08.107	20	LB	5	90	150	73	Barbell Decline Triceps Extension
LEARNING	\N	\N	2022-08-14 08:38:50.775	0	KG	0	90	150	62	Chest Dip
LEARNING	\N	\N	2022-08-14 08:38:50.901	15	KG	10	90	150	62	Cable Pullover
LEARNING	\N	\N	\N	100	KG	4	90	150	50	Barbell Straight Leg Deadlift (Romanian)
LEARNING	\N	\N	2022-09-08 15:50:47.293	0	KG	0	90	150	50	Crunch
LEARNING	\N	\N	2022-09-21 16:46:14.731	30	KG	8	90	150	50	Barbell Triceps Extension
LEARNING	\N	\N	\N	0	KG	0	30	60	50	Incline Twisting Sit-up
LEARNING	\N	\N	\N	0	KG	0	90	150	50	Dumbbell Push Sit-up
LEARNING	\N	\N	2022-09-24 15:00:24.932	20	KG	5	90	150	50	Dumbbell Lateral Raise
LEARNING	\N	\N	2022-09-19 04:46:30.06	7.5	KG	15	90	150	62	Cable One Arm Lateral Raise
LEARNING	\N	\N	2022-09-19 04:46:30.109	10	KG	10	90	150	62	Dumbbell One Arm Lateral Raise
LEARNING	\N	\N	2022-08-23 13:40:29.412	20	KG	8	50	150	50	Barbell Lying Triceps Extension
LEARNING	\N	\N	2022-09-12 12:40:30.036	5	KG	8	90	150	45	Dumbbell Lateral Raise
LEARNING	\N	\N	2022-08-29 13:23:31.186	20	KG	8	90	150	45	Barbell Bent-over Row
LEARNING	\N	\N	\N	0	KG	0	90	150	50	Twisting Sit-up
LEARNING	\N	\N	\N	0	KG	0	90	150	45	Push-up (on knees)
LEARNING	\N	\N	\N	70	KG	4	90	150	50	Barbell Rear Delt Row
LEARNING	\N	\N	\N	0	KG	0	90	150	45	Hanging Straight Hip Leg Curl
LEARNING	\N	\N	2022-09-01 16:19:44.435	42.5	KG	12	90	150	62	Cable Seated Rear Lateral Raise
LEARNING	\N	\N	2022-09-19 04:46:30.141	13	KG	10	90	150	62	Cable Decline Fly
LEARNING	\N	\N	\N	0	KG	0	90	150	62	Cable Chest Dip
LEARNING	\N	\N	2022-09-20 09:56:53.864	23.5	KG	8	90	150	62	Cable Straight Back Seated Row
LEARNING	\N	\N	2022-08-29 13:34:05.045	0	KG	0	29	150	50	Crunch Up
LEARNING	\N	\N	\N	0	KG	0	90	150	45	Glute-Ham Raise (hands behind neck)
LEARNING	\N	\N	2022-08-29 13:34:05.018	100	KG	5	90	150	50	Barbell Sumo Deadlift
LEARNING	\N	\N	2022-09-12 12:40:30.018	0	KG	0	90	150	45	V-up
LEARNING	\N	\N	2022-09-18 16:15:44.004	50	KG	5	90	150	50	Barbell Military Press
LEARNING	\N	\N	\N	0	KG	0	90	150	45	Jack-knife Sit-up
LEARNING	\N	\N	2022-09-21 16:46:14.752	50.75	KG	7	70	150	50	Barbell Good-morning
LEARNING	\N	\N	2022-08-29 13:34:05.058	0	KG	0	29	150	50	Side Bridge
LEARNING	\N	\N	\N	72.5	KG	3	90	150	64	Barbell Bench Press
LEARNING	\N	\N	2022-09-20 09:56:53.808	30	KG	8	90	150	62	Cable One Arm Seated Row
LEARNING	\N	\N	2022-09-19 04:46:30.126	9	KG	8	90	150	62	Cable Incline Fly
LEARNING	\N	\N	\N	32.5	KG	8	90	150	64	Barbell Shoulder Press
LEARNING	\N	\N	\N	0	KG	0	29	60	45	Side Bridge Hip Abduction
LEARNING	\N	\N	\N	70	KG	4	90	150	50	Barbell Upright Row
LEARNING	\N	\N	2022-09-07 14:39:34.615	0	KG	0	90	180	62	Incline Sit-up
LEARNING	\N	\N	2022-09-20 09:56:53.848	46	KG	10	90	150	62	Cable Curl
LEARNING	\N	\N	\N	10	KG	6	90	150	64	Cable Standing Fly
LEARNING	\N	\N	2022-09-24 15:00:24.977	100	KG	4	90	150	50	Barbell Squat
LEARNING	\N	\N	2022-09-20 09:56:53.825	25	KG	8	90	150	62	Cable Rear Delt Row
LEARNING	\N	\N	2022-08-30 15:13:39.65	0	KG	0	90	150	45	Bench Dip
LEARNING	\N	\N	2022-08-29 13:23:31.148	10	KG	8	40	60	45	Barbell Squat
LEARNING	\N	\N	\N	10	KG	6	90	150	64	Cable Triceps Extension
LEARNING	\N	\N	2022-09-21 16:46:14.714	70	KG	5	90	150	50	Barbell Bent-over Row
LEARNING	\N	\N	2022-08-30 15:13:39.672	0	KG	0	90	150	45	Crunch
LEARNING	\N	\N	2022-08-30 15:13:39.69	0	KG	0	90	150	45	Inverted Row
LEARNING	\N	\N	2022-09-24 15:00:24.952	120	KG	5	160	329	50	Barbell Deadlift
LEARNING	\N	\N	2022-09-12 12:49:39.86	0	KG	0	90	150	50	Lying Leg-Hip Raise
LEARNING	\N	\N	\N	0	KG	0	90	150	45	Chest Dip
LEARNING	\N	\N	2022-09-12 12:40:30.006	0	KG	0	29	60	45	Lunge
LEARNING	\N	\N	\N	0	KG	0	90	150	45	Rear Delt Inverted Row
LEARNING	\N	\N	2022-09-12 12:40:29.993	10	KG	8	20	29	45	Dumbbell Incline Row
LEARNING	\N	\N	2022-09-12 12:49:39.878	0	KG	0	90	150	50	Incline Sit-up
LEARNING	\N	\N	2022-09-20 09:56:53.788	0	KG	15	300	480	62	Pull-up
LEARNING	\N	\N	2022-09-20 09:56:53.885	0	KG	0	90	150	62	Cable Pulldown
LEARNING	\N	\N	\N	0	KG	0	90	150	50	Sit-up
LEARNING	\N	\N	2022-09-19 04:46:30.155	0	KG	0	90	150	62	Triceps Dip
LEARNING	\N	\N	2022-09-18 16:15:43.991	80	KG	5	90	150	50	Barbell Bench Press
LEARNING	\N	\N	2022-08-30 16:06:09.181	25	KG	8	90	150	62	Barbell Curl
LEARNING	\N	\N	2022-08-31 06:45:49.25	92.5	KG	6	90	150	64	Barbell Deadlift
LEARNING	\N	\N	2022-08-31 06:45:49.272	0	KG	0	90	150	64	Sit-up
LEARNING	\N	\N	2022-09-10 05:32:13.486	22.5	KG	9	90	150	62	Dumbbell Incline Bench Press
LEARNING	\N	\N	2022-09-02 16:31:53.683	20	KG	12	90	150	62	Seated Leg Raise
LEARNING	\N	\N	2022-09-02 16:31:53.699	35	KG	12	90	150	62	Cable Lying Leg Curl
LEARNING	\N	\N	2022-09-02 16:31:53.722	0	KG	0	90	180	62	Lying Leg-Hip Raise
LEARNING	\N	\N	2022-09-02 16:31:53.667	80	KG	5	90	150	62	Barbell Squat
LEARNING	\N	\N	\N	40	KG	10	90	150	50	Dumbbell Incline Bench Press
LEARNING	\N	\N	2022-09-19 04:46:30.041	75	KG	7	90	150	62	Barbell Bench Press
LEARNING	\N	\N	2022-09-19 04:46:30.091	25	KG	9	90	150	62	Cable Triceps Extension
LEARNING	\N	\N	\N	0	KG	0	90	150	50	Barbell Close Grip Bench Press
LEARNING	\N	\N	2022-09-25 20:03:04.651	50	KG	3	90	150	49	Barbell Incline Bench Press
LEARNING	\N	\N	\N	0	KG	0	90	150	90	Cable Pulldown
LEARNING	\N	\N	\N	0	KG	0	90	150	90	Cable Wide Grip Seated Row
LEARNING	\N	\N	2022-09-07 06:21:41.163	42.5	KG	10	90	150	62	Cable Seated Reverse Fly
LEARNING	\N	\N	\N	0	KG	0	90	180	58	Cable Standing Leg Curl
LEARNING	\N	\N	2022-09-19 04:46:30.075	50	KG	10	90	180	62	Barbell Incline Bench Press
LEARNING	\N	\N	2022-09-19 04:46:30.172	15	KG	10	90	150	62	Dumbbell Shoulder Press
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Chest Press
LEARNING	\N	\N	2022-09-07 14:39:34.63	0	KG	0	90	150	62	Incline Leg Raise
LEARNING	\N	\N	2022-09-07 14:39:34.643	7.5	KG	12	90	150	62	Cable Twist
LEARNING	\N	\N	2022-09-07 14:39:34.657	0	KG	0	90	150	62	Weighted Lying Leg Raise
LEARNING	\N	\N	2022-09-07 14:39:34.677	0	KG	0	90	150	62	Cable Kneeling Crunch
LEARNING	\N	\N	2022-09-07 14:39:34.691	0	KG	0	90	150	62	Dumbbell Reverse Wrist Curl
LEARNING	\N	\N	\N	0	KG	0	90	180	64	Barbell Full Squat
LEARNING	\N	\N	\N	0	KG	0	90	180	64	Barbell Bent-over Row
LEARNING	\N	\N	\N	0	KG	0	90	180	64	Pull-up
LEARNING	\N	\N	\N	0	KG	0	90	180	64	Dumbbell Curl
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Bar Behind Neck Press
LEARNING	\N	\N	\N	0	KG	0	90	180	58	Trap Bar Shrug
LEARNING	\N	\N	2022-09-25 19:57:22.268	50	KG	1	90	150	49	Cable Squat
LEARNING	\N	\N	2022-09-12 10:23:50.23	50	KG	3	90	150	49	Dumbbell Decline Bench Press
LEARNING	\N	\N	2022-09-12 10:23:50.249	50	KG	3	90	150	49	Cable One Arm Kneeling Pulldown
LEARNING	\N	\N	2022-09-25 20:03:04.675	0	KG	8	90	150	49	Jack-knife Sit-up
LEARNING	\N	\N	2022-09-28 10:37:00.807	0	KG	15	90	150	49	Lying Leg-Hip Raise
LEARNING	\N	\N	2022-09-12 12:49:39.819	40	KG	15	90	150	50	Dumbbell Incline Row
LEARNING	\N	\N	2022-09-12 12:49:39.831	20	KG	12	90	180	50	Dumbbell Triceps Extension
LEARNING	\N	\N	2022-09-12 12:49:39.844	0	KG	0	90	180	50	Lunge
LEARNING	\N	\N	\N	0	KG	0	90	180	99	Cable Alternating Seated Pushdown
LEARNING	\N	\N	\N	0	KG	0	90	180	99	Dumbbell Reclined Triceps Extension
LEARNING	\N	\N	\N	0	KG	0	90	180	99	Bench Dip
LEARNING	\N	\N	\N	0	KG	0	90	180	99	Dumbbell Incline Curl
LEARNING	\N	\N	\N	0	KG	0	90	180	99	Cable Close Grip Pulldown
LEARNING	\N	\N	\N	0	KG	0	90	180	99	Cable Shrug
LEARNING	\N	\N	\N	0	KG	0	90	180	99	Incline Push-up
LEARNING	\N	\N	\N	0	KG	0	90	180	99	Barbell Wrist Curl
LEARNING	\N	\N	\N	0	KG	0	90	180	99	Cable Wrist Curl
LEARNING	\N	\N	\N	0	KG	0	90	180	99	Barbell Sumo Deadlift
LEARNING	\N	\N	\N	0	KG	0	90	180	99	Barbell Full Squat
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Sit-up
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Lying Leg Curl
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Pushdown (forward leaning)
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Wide Grip Seated Row
LEARNING	\N	\N	2022-09-14 06:43:26.753	50	KG	3	90	150	102	Cable Alternating Pulldown
LEARNING	\N	\N	2022-09-14 06:43:26.769	50	KG	3	90	150	102	Dumbbell Incline Bench Press
LEARNING	\N	\N	2022-09-14 06:43:26.784	50	KG	3	90	150	102	Cable Upright Row
LEARNING	\N	\N	2022-09-14 06:43:26.798	0	KG	0	90	150	102	Incline Sit-up
LEARNING	\N	\N	2022-09-14 06:43:26.815	0	KG	0	90	150	102	V-up
LEARNING	\N	\N	\N	0	KG	0	90	180	50	Barbell Prone Incline Curl
LEARNING	\N	\N	\N	0	KG	0	90	180	58	Cable Incline Chest Press
LEARNING	\N	\N	\N	0	KG	0	90	180	50	Barbell Push Sit-up
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Dumbbell Upright Row
LEARNING	\N	\N	\N	0	KG	0	90	180	58	Hanging Straight Leg-Hip Raise
LEARNING	\N	\N	\N	0	KG	0	90	180	58	Jack-knife Sit-up
LEARNING	\N	\N	\N	0	KG	0	90	180	58	Barbell Rear Delt Row
LEARNING	\N	\N	\N	0	KG	0	90	180	58	Dumbbell One Arm Triceps Extension
LEARNING	\N	\N	\N	0	KG	0	90	180	58	Lever Lying Leg Curl
LEARNING	\N	\N	2022-09-18 16:15:44.016	35	KG	5	90	180	50	Barbell Curl
LEARNING	\N	\N	2022-09-19 10:36:30.253	0	KG	0	90	180	49	Barbell Close Grip Incline Bench Press
LEARNING	\N	\N	2022-09-19 10:36:30.267	0	KG	0	90	180	49	Barbell Lying Triceps Extension
LEARNING	\N	\N	\N	0	KG	0	90	180	58	Sit-up
LEARNING	\N	\N	\N	0	KG	0	90	150	92	Barbell Deadlift
LEARNING	\N	\N	\N	0	KG	0	90	180	92	Pull-up
LEARNING	\N	\N	\N	0	KG	0	90	180	58	Lying Leg-Hip Raise
LEARNING	\N	\N	\N	0	KG	0	90	180	58	Barbell Decline Bench Press
LEARNING	\N	\N	\N	0	KG	0	90	180	58	Cable Incline Row
LEARNING	\N	\N	\N	0	KG	0	90	180	58	Cable Wide Grip Upright Row
LEARNING	\N	\N	\N	0	KG	0	90	180	58	Suspended Hanging Leg Hip Raise
LEARNING	\N	\N	\N	0	KG	0	90	180	58	Hanging Leg-Hip Raise
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Upright Row
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Decline Triceps Extension
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Barbell Decline Bench Press
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Barbell Squat
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Dumbbell Straight Leg Deadlift (Romanian)
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Incline Twisting Sit-up
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Kneeling Row
LEARNING	\N	\N	2022-09-24 13:11:27.512	12	KG	1	10	900	49	Barbell Close Grip Bench Press
LEARNING	\N	\N	2022-09-28 10:37:00.82	0	KG	14	90	180	49	Incline Leg-Hip Raise
LEARNING	\N	\N	2022-09-25 19:57:22.295	3	KG	1	90	180	49	Cable Standing Low Row
LEARNING	\N	\N	2022-09-28 10:37:00.758	17	KG	2	90	180	49	Cable Incline Chest Press
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Standing Shoulder Press
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Barbell Straight Leg Deadlift (Romanian)
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Barbell Bench Press
LEARNING	\N	\N	2022-09-25 20:03:04.689	0	KG	7	10	180	49	V-up
LEARNING	\N	\N	\N	0	KG	0	90	180	50	Weighted Glute-Ham Raise
LEARNING	\N	\N	\N	0	KG	0	90	180	50	Dumbbell Shrug
LEARNING	\N	\N	\N	0	KG	0	90	180	50	Incline Leg-Hip Raise
LEARNING	\N	\N	\N	0	KG	0	90	180	50	Weighted Inverted Row
LEARNING	\N	\N	\N	0	KG	0	90	180	50	Dumbbell Seated Upright Row
LEARNING	\N	\N	\N	0	KG	0	90	180	50	Dumbbell Curl
LEARNING	\N	\N	\N	0	KG	0	90	180	50	Barbell Incline Bench Press
LEARNING	\N	\N	\N	0	KG	0	90	180	50	V-up
LEARNING	\N	\N	\N	0	KG	0	90	180	50	Barbell Close Grip Bent-over Row
LEARNING	\N	\N	\N	0	KG	0	90	180	50	Dumbbell Reclined Shoulder Press
LEARNING	\N	\N	\N	0	KG	0	90	180	50	Weighted Push-up
LEARNING	\N	\N	\N	0	KG	0	90	180	50	Barbell Underhand Bent-over Row
LEARNING	\N	\N	\N	0	KG	0	90	180	50	Dumbbell Bench Press
LEARNING	\N	\N	\N	0	KG	0	90	180	50	Dumbbell Raise
LEARNING	\N	\N	\N	0	KG	0	90	180	50	Dumbbell Step-up
LEARNING	\N	\N	\N	0	KG	0	90	180	50	Jack-knife Sit-up
LEARNING	\N	\N	\N	0	KG	0	90	180	50	Dumbbell Arnold Press
LEARNING	\N	\N	\N	0	KG	0	90	180	50	Barbell Lying Triceps Extension "Skull Crusher"
LEARNING	\N	\N	\N	0	KG	0	90	180	50	Dumbbell Straight Leg Deadlift (Romanian)
LEARNING	\N	\N	\N	0	KG	0	90	180	50	Dumbbell Squat
LEARNING	\N	\N	\N	0	KG	0	90	180	50	Barbell Decline Triceps Extension
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Chest Dip
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Lying Row
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Twisting Overhead Press
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Straight Back Seated Row
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Bar Military Press
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Parallel Grip Pulldown
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Straight Back Incline Row
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Dumbbell One Arm Upright Row
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Barbell Glute-Ham Raise
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Cable Incline Bench Press
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Cable One Arm Seated High Row
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Lying Leg-Hip Raise
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Jack-knife Sit-up
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Cable Bar Upright Row
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Dumbbell Seated Curl
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Cable Standing Leg Curl
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Incline Leg-Hip Raise
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Cable Bench Press
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Cable Twisting Overhead Press
LEARNING	\N	\N	\N	0	KG	0	90	180	107	V-up
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Dumbbell Lying Triceps Extension
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Barbell Full Squat
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Dumbbell Incline Bench Press
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Cable Alternating Pulldown
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Dumbbell Reclined Shoulder Press
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Dumbbell Incline Curl
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Twisting Sit-up
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Cable Bar Bench Press
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Barbell Close Grip Bent-over Row
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Incline Twisting Sit-up
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Barbell Upright Row
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Dumbbell One Arm Reclined Triceps Extension
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Cable Step-up
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Cable Chest Press
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Cable Seated High Row
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Cable Alternating Curl
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Cable Belt Half Squat
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Cable Decline Chest Press
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Dumbbell Shoulder Press
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Barbell Bench Press
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Cable One Arm Pulldown
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Decline Chest Press
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Barbell Military Press
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Leg-Hip Raise (on stability ball)
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Dumbbell Front Squat
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Bar Bent-over Triceps Extension
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Bench Press
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Rear Pulldown
LEARNING	\N	\N	2022-09-25 19:09:24.375	0	KG	13	90	180	107	Incline Sit-up
LEARNING	\N	\N	2022-09-25 19:57:22.282	8	KG	1	90	180	49	Cable Incline Bench Press
LEARNING	\N	\N	2022-09-25 19:09:24.348	9.75	KG	1	90	180	107	Barbell Incline Bench Press
LEARNING	\N	\N	2022-09-25 19:09:24.331	3	KG	1	90	180	107	Cable Bar Squat
LEARNING	\N	\N	2022-09-25 20:03:04.637	6.75	KG	1	90	180	49	Barbell Good-morning
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Barbell Upright Row
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Bar Squat
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Bar Pushdown
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Pulldown
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Twisting Sit-up
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Weighted Push-up
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Standing Leg Curl
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Bar Curl
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Lateral Raise
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Pushdown
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Dumbbell Arnold Press
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Belt Half Squat
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Barbell Reclined Triceps Extension
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable One Arm Pulldown
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Barbell Full Squat
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Barbell Curl
LEARNING	\N	\N	\N	0	KG	0	90	180	50	Barbell Lying Rear Delt Row
LEARNING	\N	\N	\N	0	KG	0	90	180	50	Barbell Full Squat
LEARNING	\N	\N	\N	0	KG	0	90	180	50	Dumbbell One Arm Triceps Extension
LEARNING	\N	\N	\N	0	KG	0	90	180	50	Dumbbell Decline Bench Press
LEARNING	\N	\N	\N	0	KG	0	90	180	50	Dumbbell Incline Curl
LEARNING	\N	\N	\N	0	KG	0	90	180	50	Barbell Close Grip Incline Bench Press
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Cable Standing Leg Curl
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Barbell Incline Triceps Extension
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Cable Kneeling Row
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Twisting Sit-up
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Incline Leg-Hip Raise
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Cable Incline Bench Press
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Cable Twisting Overhead Press
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Cable Lying Leg Curl
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Jack-knife Sit-up
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Dumbbell Triceps Extension
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Dumbbell Shrug
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Cable Incline Chest Press
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Incline Twisting Sit-up
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Barbell Reclined Shoulder Press
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Cable Decline Triceps Extension
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Incline Sit-up
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Barbell Shrug
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Cable Chest Dip
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Barbell Upright Row
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Dumbbell Bench Press
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Cable Alternating Standing Pulldown
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Cable Bar Shoulder Press
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Dumbbell Lying Triceps Extension
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Dumbbell Front Squat
LEARNING	\N	\N	2022-09-25 13:35:05.361	3	KG	1	90	180	47	Barbell Underhand Bent-over Row
LEARNING	\N	\N	2022-09-25 13:35:05.391	3	KG	1	90	180	47	Cable Bar Incline Bench Press
LEARNING	\N	\N	2022-09-25 13:35:05.407	3	KG	4	90	180	47	Dumbbell Raise
LEARNING	\N	\N	2022-09-25 13:35:05.426	0	KG	14	90	180	47	Lying Leg-Hip Raise
LEARNING	\N	\N	2022-09-25 13:35:05.443	0	KG	23	90	180	47	V-up
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Cable Belt Squat
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Dumbbell Incline Bench Press
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Cable Parallel Grip Pulldown
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Cable Bar Behind Neck Press
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Sit-up
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Dumbbell Reclined Triceps Extension
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Barbell Squat
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Cable Wide Grip Seated Row
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Dumbbell One Arm Reclined Triceps Extension
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Cable Bar Squat
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Dumbbell Decline Bench Press
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Cable One Arm Upright Row
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Dumbbell Triceps Extension
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Cable One Arm Kneeling Pulldown
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Cable Standing Shoulder Press
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Cable Bar Curl
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Cable Lying Leg Curl
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Dumbbell Squat
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Barbell Straight Leg Deadlift (Romanian)
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Cable Shoulder Press
LEARNING	\N	\N	\N	0	KG	0	90	180	107	Cable Curl
LEARNING	\N	\N	2022-09-25 19:09:24.362	3	KG	5	90	180	107	Cable Straight Leg Deadlift (Romanian)
LEARNING	\N	\N	2022-09-25 19:09:24.387	0	KG	8	90	180	107	Sit-up
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Dumbbell Bench Press
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Barbell Shoulder Press
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Barbell Glute-Ham Raise
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Incline Triceps Extension
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Dumbbell Seated Upright Row
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Barbell Decline Triceps Extension
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Wide Grip Upright Row
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Curl
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Dumbbell Incline Row
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Barbell Reclined Shoulder Press
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Barbell Incline Triceps Extension
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Barbell Underhand Bent-over Row
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Dumbbell Reclined Shoulder Press
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Dumbbell One Arm Triceps Extension
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Straight Leg Deadlift (Romanian)
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Bar Incline Bench Press
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Bar Bench Press
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Dumbbell Seated Curl
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Dumbbell Lateral Raise
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Barbell Lying Triceps Extension "Skull Crusher"
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Dumbbell Incline Bench Press
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Barbell Rear Delt Row
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Weighted Glute-Ham Raise
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Dumbbell Reclined Triceps Extension
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable One Arm Seated Row
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Alternating Standing Pulldown
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Dumbbell Incline Curl
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Barbell Bent-over Row
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Dumbbell Shoulder Press
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable One Arm Seated High Row
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable One Arm Upright Row
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Alternating Curl
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Seated Row
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Dumbbell One Arm Shoulder Press
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Bar Lying Triceps Extension
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Dumbbell Squat
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Dumbbell Triceps Extension
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Shoulder Press
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Barbell Deadlift
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Seated Lateral Raise
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Rear Delt Row
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Seated Curl
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Close Grip Pulldown
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Triceps Extension
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Bar Shrug
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Alternating Seated High Row
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Dumbbell Rear Delt Row
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Lying Triceps Extension
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Dumbbell One Arm Reclined Triceps Extension
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Dumbbell Curl
LEARNING	\N	\N	\N	0	KG	0	90	180	110	Cable Standing Incline Chest Press
LEARNING	\N	\N	2022-09-25 20:03:04.663	6	KG	4	90	180	49	Barbell Close Grip Bent-over Row
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Incline Row
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Twisting Seated Row
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Barbell Lying Rear Delt Row
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Bent-over Leg Curl
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Cable Belt Squat
LEARNING	\N	\N	\N	0	KG	0	90	180	49	Barbell Sumo Deadlift
LEARNING	\N	\N	2022-09-28 10:34:37.304	12.5	KG	3	90	180	49	Cable Standing Row
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Dumbbell Kickback
LEARNING	\N	\N	\N	0	KG	0	90	180	110	Cable Rear Lateral Raise
LEARNING	\N	\N	\N	0	KG	0	90	180	110	Dumbbell Fly
LEARNING	\N	\N	\N	0	KG	0	90	180	110	Barbell Incline Triceps Extension
LEARNING	\N	\N	2022-09-28 10:37:00.774	18	KG	3	90	180	49	Cable Seated High Row
LEARNING	\N	\N	2022-09-28 10:37:00.791	16	KG	3	90	180	49	Cable Bar Shoulder Press
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Barbell Bench Press
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Dumbbell Arnold Press
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Dumbbell Pullover
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Cable Lying Triceps Extension
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Cable Lying Straight Leg-Hip Raise
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Weighted Incline Straight Leg Raise
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Weighted Inverted Row
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Cable Bent-over Pullover
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Dumbbell Alternating Side Lunge
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Cable Standing Leg Raise
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Cable Split Squat
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Dumbbell Prone External Rotation
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Cable Lying Hip Adduction
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Dumbbell Seated Supination
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Dumbbell Fly
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Cable Triceps Dip
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Weighted Side Crunch
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Barbell Full Squat
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Dumbbell Decline Bench Press
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Dumbbell Seated Lateral Raise
LEARNING	\N	\N	\N	0	KG	0	90	180	47	Cable Step-up
\.


--
-- Data for Name: ExcerciseSet; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."ExcerciseSet" (excercise_set_id, target_weight, weight_unit, target_reps, actual_weight, actual_reps, excercise_set_group_id) FROM stdin;
8018	70	KG	4	70	4	1707
8019	70	KG	4	70	4	1707
8020	70	KG	4	70	4	1707
8021	70	KG	4	70	4	1707
8022	70	KG	4	70	4	1707
8023	100	KG	4	100	4	1708
8024	100	KG	4	100	4	1708
8025	100	KG	4	100	4	1708
8026	100	KG	4	100	4	1708
8027	100	KG	4	100	4	1708
8028	70	KG	4	70	4	1709
8029	70	KG	4	70	4	1709
8030	70	KG	4	70	4	1709
8031	70	KG	4	70	5	1709
8032	70	KG	4	70	4	1709
8038	0	KG	5	0	5	1711
8039	0	KG	5	0	5	1711
8040	0	KG	5	0	5	1711
8041	0	KG	5	0	5	1711
8042	0	KG	5	0	5	1711
13936	50	KG	3	\N	\N	3007
13937	50	KG	3	\N	\N	3007
13938	50	KG	3	\N	\N	3007
13939	50	KG	3	\N	\N	3007
13940	50	KG	3	\N	\N	3007
13941	50	KG	3	\N	\N	3008
13942	50	KG	3	\N	\N	3008
13943	50	KG	3	\N	\N	3008
13944	50	KG	3	\N	\N	3008
13945	50	KG	3	\N	\N	3008
13946	50	KG	3	\N	\N	3009
13947	50	KG	3	\N	\N	3009
13948	50	KG	3	\N	\N	3009
11424	20	KG	8	20	8	2441
11425	20	KG	8	20	8	2441
11426	20	KG	8	25	6	2441
11427	20	KG	8	25	6	2441
11428	20	KG	8	25	8	2441
11429	41.5	KG	15	\N	\N	2442
11430	46.25	KG	15	\N	\N	2442
11431	46.75	KG	15	\N	\N	2442
11432	46.75	KG	15	\N	\N	2442
11433	51.25	KG	15	\N	\N	2442
13949	50	KG	3	\N	\N	3009
13950	50	KG	3	\N	\N	3009
13951	0	KG	8	\N	\N	3010
13952	0	KG	8	\N	\N	3010
13953	0	KG	8	\N	\N	3010
13954	0	KG	8	\N	\N	3010
13955	0	KG	8	\N	\N	3010
13956	0	KG	8	\N	\N	3011
13957	0	KG	8	\N	\N	3011
13958	0	KG	8	\N	\N	3011
13959	0	KG	8	\N	\N	3011
13960	0	KG	8	\N	\N	3011
12670	0	KG	8	\N	\N	2721
12671	0	KG	8	\N	\N	2721
12672	0	KG	8	\N	\N	2721
12673	0	KG	8	\N	\N	2721
12674	0	KG	8	\N	\N	2722
12675	0	KG	8	\N	\N	2722
12676	0	KG	8	\N	\N	2722
12677	0	KG	8	\N	\N	2722
12678	0	KG	8	\N	\N	2722
12805	50	KG	3	\N	\N	2748
12806	50	KG	3	\N	\N	2748
12807	50	KG	3	\N	\N	2748
12808	50	KG	3	\N	\N	2748
12809	50	KG	3	\N	\N	2749
12810	50	KG	3	\N	\N	2749
12811	50	KG	3	\N	\N	2749
12812	50	KG	3	\N	\N	2749
12813	50	KG	3	\N	\N	2749
12814	20	KG	5	\N	\N	2750
12815	20	KG	5	\N	\N	2750
12816	20	KG	5	\N	\N	2750
12817	20	KG	5	\N	\N	2750
12818	20	KG	5	\N	\N	2750
11434	0	KG	10	\N	\N	2443
11435	0	KG	10	\N	\N	2443
11436	0	KG	10	\N	\N	2443
11437	0	KG	10	\N	\N	2443
11438	0	KG	10	\N	\N	2443
11439	0	KG	3	\N	\N	2444
11440	0	KG	3	\N	\N	2444
11441	0	KG	3	\N	\N	2444
11442	0	KG	3	\N	\N	2444
11443	0	KG	3	\N	\N	2444
16687	0	KG	0	\N	\N	3662
16688	0	KG	0	\N	\N	3662
16689	0	KG	0	\N	\N	3662
16690	0	KG	0	\N	\N	3662
16691	0	KG	0	\N	\N	3662
16692	0	KG	0	\N	\N	3664
16693	0	KG	0	\N	\N	3664
16694	0	KG	0	\N	\N	3664
16695	0	KG	0	\N	\N	3664
16696	0	KG	0	\N	\N	3664
11444	70	KG	5	\N	\N	2445
11445	70	KG	5	\N	\N	2445
11446	70	KG	5	\N	\N	2445
11447	70	KG	5	\N	\N	2445
11448	70	KG	5	\N	\N	2445
13961	50	KG	3	\N	\N	3012
13962	50	KG	3	\N	\N	3012
13963	50	KG	3	\N	\N	3012
13964	50	KG	3	\N	\N	3012
13965	50	KG	3	\N	\N	3012
16697	0	KG	0	\N	\N	3665
16698	0	KG	0	\N	\N	3665
16699	0	KG	0	\N	\N	3665
16700	0	KG	0	\N	\N	3665
16701	0	KG	0	\N	\N	3665
16702	0	KG	0	\N	\N	3666
16703	0	KG	0	\N	\N	3666
16704	0	KG	0	\N	\N	3666
16705	0	KG	0	\N	\N	3666
16706	0	KG	0	\N	\N	3666
13966	20	KG	5	\N	\N	3013
13967	20	KG	5	\N	\N	3013
13968	20	KG	5	\N	\N	3013
13969	20	KG	5	\N	\N	3013
13970	20	KG	5	\N	\N	3013
16707	0	KG	0	\N	\N	3667
16708	0	KG	0	\N	\N	3667
16709	0	KG	0	\N	\N	3667
16710	0	KG	0	\N	\N	3667
16711	0	KG	0	\N	\N	3667
13971	50	KG	3	\N	\N	3014
13972	50	KG	3	\N	\N	3014
13973	50	KG	3	\N	\N	3014
13974	50	KG	3	\N	\N	3014
13975	50	KG	3	\N	\N	3014
13976	0	KG	8	\N	\N	3015
13977	0	KG	8	\N	\N	3015
12819	0	KG	8	\N	\N	2751
13978	0	KG	8	\N	\N	3015
13979	0	KG	8	\N	\N	3015
13980	0	KG	8	\N	\N	3015
16712	0	KG	0	\N	\N	3668
16713	0	KG	0	\N	\N	3668
16714	0	KG	0	\N	\N	3668
16715	0	KG	0	\N	\N	3668
16716	0	KG	0	\N	\N	3668
16717	0	KG	0	\N	\N	3669
16718	0	KG	0	\N	\N	3669
16719	0	KG	0	\N	\N	3669
16720	0	KG	0	\N	\N	3669
16721	0	KG	0	\N	\N	3669
16722	0	KG	0	\N	\N	3670
16723	0	KG	0	\N	\N	3670
16724	0	KG	0	\N	\N	3670
16725	0	KG	0	\N	\N	3670
16726	0	KG	0	\N	\N	3670
13981	0	KG	8	\N	\N	3016
13982	0	KG	8	\N	\N	3016
13983	0	KG	8	\N	\N	3016
13984	0	KG	8	\N	\N	3016
13985	0	KG	8	\N	\N	3016
12266	12	KG	10	10	10	2632
12267	12	KG	10	7.5	12	2632
12268	12	KG	10	\N	\N	2632
16727	0	KG	0	\N	\N	3671
16728	0	KG	0	\N	\N	3671
16729	0	KG	0	\N	\N	3671
16730	0	KG	0	\N	\N	3671
16731	0	KG	0	\N	\N	3671
16782	0	KG	0	\N	\N	3682
16783	0	KG	0	\N	\N	3682
16784	0	KG	0	\N	\N	3682
16785	0	KG	0	\N	\N	3682
16786	0	KG	0	\N	\N	3682
16787	0	KG	0	\N	\N	3683
16788	0	KG	0	\N	\N	3683
16789	0	KG	0	\N	\N	3683
16790	0	KG	0	\N	\N	3683
16791	0	KG	0	\N	\N	3683
12269	75	KG	6	75	6	2633
12270	75	KG	6	75	6	2633
12271	75	KG	6	75	6	2633
12272	22.5	KG	9	22.5	8	2634
12273	22.5	KG	9	22.5	8	2634
16792	0	KG	0	\N	\N	3684
16793	0	KG	0	\N	\N	3684
16794	0	KG	0	\N	\N	3684
16795	0	KG	0	\N	\N	3684
16796	0	KG	0	\N	\N	3684
12274	22.5	KG	8	22.5	6	2634
12275	7.75	KG	5	7.5	10	2635
12276	7.5	KG	13	5	12	2635
12277	7.5	KG	13	5	12	2635
12278	25	KG	7	25	8	2636
16797	0	KG	0	\N	\N	3685
16798	0	KG	0	\N	\N	3685
16799	0	KG	0	\N	\N	3685
16800	0	KG	0	\N	\N	3685
16801	0	KG	0	\N	\N	3685
16802	0	KG	0	\N	\N	3686
16803	0	KG	0	\N	\N	3686
16804	0	KG	0	\N	\N	3686
16805	0	KG	0	\N	\N	3686
16806	0	KG	0	\N	\N	3686
12279	25	KG	7	25	8	2636
12280	25	KG	7	\N	\N	2636
12281	8.75	KG	12	10	15	2637
12282	8.75	KG	12	10	12	2637
12283	8.75	KG	11	7.5	10	2638
12284	8.75	KG	11	\N	\N	2638
12285	15	KG	8	\N	\N	2639
12286	15	KG	8	\N	\N	2639
11474	57.5	KG	6	57.5	6	2451
11475	67.5	KG	6	67.5	6	2451
11476	67.5	KG	5	67.5	5	2451
11477	72.5	KG	4	72.5	3	2451
11478	67.5	KG	5	67.5	5	2451
11479	67.5	KG	5	67.5	4	2451
11480	20	KG	8	20	10	2452
11481	32.5	KG	8	32.5	8	2452
14198	50	KG	3	50	3	3068
14199	50	KG	3	50	3	3068
11482	32.5	KG	8	32.5	6	2452
11483	32.5	KG	8	32.5	5	2452
11484	27.5	KG	8	27.5	8	2452
11485	10	KG	6	10	6	2453
11486	10	KG	6	10	6	2453
14200	50	KG	3	50	3	3068
14201	50	KG	3	50	3	3068
14202	50	KG	3	50	3	3068
14203	50	KG	3	50	3	3068
14204	50	KG	3	50	3	3069
14205	50	KG	3	50	3	3069
14206	50	KG	3	50	3	3069
14207	50	KG	3	50	3	3069
12679	50	KG	3	\N	\N	2723
12680	50	KG	3	\N	\N	2723
12681	50	KG	3	\N	\N	2723
12682	50	KG	3	\N	\N	2723
12683	50	KG	3	\N	\N	2723
12684	50	KG	3	\N	\N	2724
12685	50	KG	3	\N	\N	2724
12686	50	KG	3	\N	\N	2724
12687	50	KG	3	\N	\N	2724
12688	50	KG	3	\N	\N	2724
12689	50	KG	3	\N	\N	2725
12690	50	KG	3	\N	\N	2725
12691	50	KG	3	\N	\N	2725
12692	50	KG	3	\N	\N	2725
12693	50	KG	3	\N	\N	2725
12694	0	KG	8	\N	\N	2726
12695	0	KG	8	\N	\N	2726
12696	0	KG	8	\N	\N	2726
12697	0	KG	8	\N	\N	2726
12698	0	KG	8	\N	\N	2726
12699	0	KG	8	\N	\N	2727
12700	0	KG	8	\N	\N	2727
12701	0	KG	8	\N	\N	2727
12702	0	KG	8	\N	\N	2727
12703	0	KG	8	\N	\N	2727
12704	50	KG	3	\N	\N	2728
12705	50	KG	3	\N	\N	2728
12706	50	KG	3	\N	\N	2728
12707	50	KG	3	\N	\N	2728
14208	50	KG	3	50	3	3069
14209	50	KG	3	50	3	3070
14210	50	KG	3	50	3	3070
11487	10	KG	6	10	6	2453
14211	50	KG	3	50	3	3070
14212	50	KG	3	50	3	3070
14213	50	KG	3	50	3	3070
14214	50	KG	3	50	3	3070
14215	0	KG	8	0	8	3071
14216	0	KG	8	0	8	3071
11488	10	KG	6	10	6	2453
11489	10	KG	6	10	6	2453
11490	10	KG	6	10	6	2454
11491	7.5	KG	6	7.5	6	2454
11492	7.5	KG	6	7.5	6	2454
12309	50	KG	3	\N	\N	2649
12310	50	KG	3	\N	\N	2649
12311	50	KG	3	\N	\N	2649
12312	50	KG	3	\N	\N	2649
12313	50	KG	3	\N	\N	2649
12314	50	KG	3	\N	\N	2650
12315	50	KG	3	\N	\N	2650
12316	50	KG	3	\N	\N	2650
12317	50	KG	3	\N	\N	2650
12318	50	KG	3	\N	\N	2650
12319	0	KG	8	\N	\N	2651
12320	0	KG	8	\N	\N	2651
12321	0	KG	8	\N	\N	2651
12322	0	KG	8	\N	\N	2651
12323	0	KG	8	\N	\N	2651
12324	0	KG	8	\N	\N	2652
12325	0	KG	8	\N	\N	2652
12326	0	KG	8	\N	\N	2652
12327	0	KG	8	\N	\N	2652
12328	0	KG	8	\N	\N	2652
12329	20	KG	5	\N	\N	2653
12330	20	KG	5	\N	\N	2653
7703	50	KG	3	\N	\N	1644
7704	50	KG	3	\N	\N	1644
7705	50	KG	3	\N	\N	1644
7706	50	KG	3	\N	\N	1644
7707	50	KG	3	\N	\N	1644
7708	0	KG	3	\N	\N	1645
7709	0	KG	3	\N	\N	1645
7710	0	KG	3	\N	\N	1645
7711	0	KG	3	\N	\N	1645
7712	0	KG	3	\N	\N	1645
7713	0	KG	3	\N	\N	1646
7714	0	KG	3	\N	\N	1646
7715	0	KG	3	\N	\N	1646
7716	0	KG	3	\N	\N	1646
7717	0	KG	3	\N	\N	1646
7718	50	KG	3	\N	\N	1647
7719	50	KG	3	\N	\N	1647
7720	50	KG	3	\N	\N	1647
7721	50	KG	3	\N	\N	1647
7722	50	KG	3	\N	\N	1647
12331	20	KG	5	\N	\N	2653
12332	20	KG	5	\N	\N	2653
12333	20	KG	5	\N	\N	2653
12334	50	KG	3	\N	\N	2654
12335	50	KG	3	\N	\N	2654
12336	50	KG	3	\N	\N	2654
12337	50	KG	3	\N	\N	2654
7733	0	KG	3	\N	\N	1650
7734	0	KG	3	\N	\N	1650
7735	0	KG	3	\N	\N	1650
7736	0	KG	3	\N	\N	1650
7737	0	KG	3	\N	\N	1650
7743	50	KG	3	\N	\N	1652
7744	50	KG	3	\N	\N	1652
7745	50	KG	3	\N	\N	1652
7746	50	KG	3	\N	\N	1652
7747	50	KG	3	\N	\N	1652
7748	50	KG	3	\N	\N	1653
7749	50	KG	3	\N	\N	1653
7750	50	KG	3	\N	\N	1653
7751	50	KG	3	\N	\N	1653
7752	50	KG	3	\N	\N	1653
12338	50	KG	3	\N	\N	2654
12339	50	KG	3	\N	\N	2655
12340	50	KG	3	\N	\N	2655
12341	50	KG	3	\N	\N	2655
8194	50	KG	3	\N	\N	1743
8195	50	KG	3	\N	\N	1743
8196	50	KG	3	\N	\N	1743
8197	50	KG	3	\N	\N	1743
8198	50	KG	3	\N	\N	1743
8199	50	KG	3	\N	\N	1744
8200	50	KG	3	\N	\N	1744
8201	50	KG	3	\N	\N	1744
8202	50	KG	3	\N	\N	1744
8203	50	KG	3	\N	\N	1744
8204	50	KG	3	\N	\N	1745
8205	50	KG	3	\N	\N	1745
8206	50	KG	3	\N	\N	1745
8207	50	KG	3	\N	\N	1745
8208	50	KG	3	\N	\N	1745
8224	20	KG	5	\N	\N	1749
8225	20	KG	5	\N	\N	1749
7868	50	KG	3	\N	\N	1677
7869	50	KG	3	\N	\N	1677
7870	50	KG	3	\N	\N	1677
7871	50	KG	3	\N	\N	1677
7872	50	KG	3	\N	\N	1677
7873	50	KG	3	\N	\N	1678
7874	50	KG	3	\N	\N	1678
7875	50	KG	3	\N	\N	1678
7876	50	KG	3	\N	\N	1678
7877	50	KG	3	\N	\N	1678
7878	50	KG	3	\N	\N	1679
7879	50	KG	3	\N	\N	1679
7880	50	KG	3	\N	\N	1679
7881	50	KG	3	\N	\N	1679
7882	50	KG	3	\N	\N	1679
7883	0	KG	3	\N	\N	1680
7884	0	KG	3	\N	\N	1680
7885	0	KG	3	\N	\N	1680
7886	0	KG	3	\N	\N	1680
7887	0	KG	3	\N	\N	1680
7888	0	KG	3	\N	\N	1681
7889	0	KG	3	\N	\N	1681
7890	0	KG	3	\N	\N	1681
7891	0	KG	3	\N	\N	1681
7892	0	KG	3	\N	\N	1681
11512	57.5	KG	7	\N	\N	2459
11513	67.5	KG	7	\N	\N	2459
11514	67.5	KG	6	\N	\N	2459
11515	72.5	KG	4	\N	\N	2459
11516	67.5	KG	6	\N	\N	2459
11517	67.5	KG	5	\N	\N	2459
11518	20.5	KG	3	\N	\N	2460
11519	32.5	KG	9	\N	\N	2460
11520	32.5	KG	8	\N	\N	2460
11521	32.5	KG	8	\N	\N	2460
7903	50	KG	3	\N	\N	1684
7904	50	KG	3	\N	\N	1684
7905	50	KG	3	\N	\N	1684
7906	50	KG	3	\N	\N	1684
7907	50	KG	3	\N	\N	1684
7908	0	KG	3	\N	\N	1685
7909	0	KG	3	\N	\N	1685
7910	0	KG	3	\N	\N	1685
7911	0	KG	3	\N	\N	1685
7912	0	KG	3	\N	\N	1685
11522	27.5	KG	9	\N	\N	2460
11523	10	KG	7	\N	\N	2461
11524	10	KG	7	\N	\N	2461
11525	10	KG	7	\N	\N	2461
11526	10	KG	7	\N	\N	2461
7918	50	KG	3	\N	\N	1687
7919	50	KG	3	\N	\N	1687
7920	50	KG	3	\N	\N	1687
7921	50	KG	3	\N	\N	1687
7922	50	KG	3	\N	\N	1687
11527	10	KG	7	\N	\N	2461
11528	10	KG	7	\N	\N	2462
11529	7.5	KG	7	\N	\N	2462
11530	7.5	KG	7	\N	\N	2462
12342	50	KG	3	\N	\N	2655
7928	50	KG	3	\N	\N	1689
7929	50	KG	3	\N	\N	1689
7930	50	KG	3	\N	\N	1689
7931	50	KG	3	\N	\N	1689
7932	50	KG	3	\N	\N	1689
7933	0	KG	3	\N	\N	1690
7934	0	KG	3	\N	\N	1690
7935	0	KG	3	\N	\N	1690
7936	0	KG	3	\N	\N	1690
7937	0	KG	3	\N	\N	1690
12343	50	KG	3	\N	\N	2655
10273	70	KG	4	70	4	2196
10274	70	KG	4	70	4	2196
10275	70	KG	4	70	4	2196
10276	70	KG	4	70	4	2196
10277	70	KG	4	70	4	2196
10278	40.5	KG	5	40.5	5	2197
10279	40.5	KG	5	40.5	5	2197
10280	40.5	KG	5	40.5	5	2197
10281	40.5	KG	5	40.5	5	2197
10282	40.5	KG	5	40.5	5	2197
10283	0	KG	10	\N	\N	2198
10284	0	KG	10	\N	\N	2198
10285	0	KG	10	\N	\N	2198
10286	0	KG	10	\N	\N	2198
10287	0	KG	10	\N	\N	2198
10288	0	KG	10	\N	\N	2199
10289	0	KG	10	\N	\N	2199
10290	0	KG	10	\N	\N	2199
8226	20	KG	5	\N	\N	1749
8227	20	KG	5	\N	\N	1749
8228	20	KG	5	\N	\N	1749
8229	50	KG	3	\N	\N	1750
8230	50	KG	3	\N	\N	1750
8231	50	KG	3	\N	\N	1750
8232	50	KG	3	\N	\N	1750
8233	50	KG	3	\N	\N	1750
8239	0	KG	3	\N	\N	1752
8240	0	KG	3	\N	\N	1752
8241	0	KG	3	\N	\N	1752
8242	0	KG	3	\N	\N	1752
8243	0	KG	3	\N	\N	1752
8249	50	KG	3	\N	\N	1754
8250	50	KG	3	\N	\N	1754
8251	50	KG	3	\N	\N	1754
8252	50	KG	3	\N	\N	1754
8253	50	KG	3	\N	\N	1754
8254	50	KG	3	\N	\N	1755
8255	50	KG	3	\N	\N	1755
8256	50	KG	3	\N	\N	1755
8257	50	KG	3	\N	\N	1755
8258	50	KG	3	\N	\N	1755
8259	0	KG	3	\N	\N	1756
8260	0	KG	3	\N	\N	1756
8261	0	KG	3	\N	\N	1756
8262	0	KG	3	\N	\N	1756
8263	0	KG	3	\N	\N	1756
8274	50	KG	3	\N	\N	1759
8275	50	KG	3	\N	\N	1759
8276	50	KG	3	\N	\N	1759
8277	50	KG	3	\N	\N	1759
8278	50	KG	3	\N	\N	1759
8279	50	KG	3	\N	\N	1760
8280	50	KG	3	\N	\N	1760
8281	50	KG	3	\N	\N	1760
8282	50	KG	3	\N	\N	1760
8283	50	KG	3	\N	\N	1760
8284	0	KG	3	\N	\N	1761
8285	0	KG	3	\N	\N	1761
8286	0	KG	3	\N	\N	1761
8287	0	KG	3	\N	\N	1761
8288	0	KG	3	\N	\N	1761
8304	50	KG	3	\N	\N	1765
8305	50	KG	3	\N	\N	1765
8306	50	KG	3	\N	\N	1765
8307	50	KG	3	\N	\N	1765
8308	50	KG	3	\N	\N	1765
8309	0	KG	3	\N	\N	1766
8310	0	KG	3	\N	\N	1766
8311	0	KG	3	\N	\N	1766
8312	0	KG	3	\N	\N	1766
8313	0	KG	3	\N	\N	1766
8314	0	KG	3	\N	\N	1767
8315	0	KG	3	\N	\N	1767
8316	0	KG	3	\N	\N	1767
8317	0	KG	3	\N	\N	1767
8318	0	KG	3	\N	\N	1767
8334	0	KG	3	\N	\N	1771
8335	0	KG	3	\N	\N	1771
8336	0	KG	3	\N	\N	1771
8337	0	KG	3	\N	\N	1771
8338	0	KG	3	\N	\N	1771
8339	0	KG	3	\N	\N	1772
8340	0	KG	3	\N	\N	1772
8341	0	KG	3	\N	\N	1772
8342	0	KG	3	\N	\N	1772
8343	0	KG	3	\N	\N	1772
8349	50	KG	3	\N	\N	1774
8350	50	KG	3	\N	\N	1774
8351	50	KG	3	\N	\N	1774
8352	50	KG	3	\N	\N	1774
8353	50	KG	3	\N	\N	1774
8359	0	KG	3	\N	\N	1776
8360	0	KG	3	\N	\N	1776
8361	0	KG	3	\N	\N	1776
8362	0	KG	3	\N	\N	1776
8363	0	KG	3	\N	\N	1776
8364	0	KG	3	\N	\N	1777
8365	0	KG	3	\N	\N	1777
8366	0	KG	3	\N	\N	1777
8367	0	KG	3	\N	\N	1777
8368	0	KG	3	\N	\N	1777
8369	50	KG	3	\N	\N	1778
8370	50	KG	3	\N	\N	1778
8371	50	KG	3	\N	\N	1778
8372	50	KG	3	\N	\N	1778
8373	50	KG	3	\N	\N	1778
11053	40	KG	10	40	10	2353
11054	40	KG	10	40	10	2353
11055	40	KG	10	40	10	2353
11056	40	KG	10	40	10	2353
11057	40	KG	10	40	10	2353
11058	80	KG	5	80	5	2354
11059	85	KG	5	85	5	2354
11060	85	KG	5	86	6	2354
11061	85	KG	5	85	5	2354
11062	85	KG	5	85	5	2354
11063	20	KG	5	20	5	2355
11064	20	KG	5	20	5	2355
11065	20	KG	5	20	5	2355
11066	20	KG	5	20	5	2355
8391	0	KG	3	\N	\N	1783
11067	20	KG	5	20	5	2355
8393	0	KG	3	\N	\N	1783
11068	0	KG	10	0	10	2356
8395	0	KG	3	\N	\N	1783
11069	0	KG	10	0	10	2356
8397	0	KG	3	\N	\N	1783
8398	0	KG	3	\N	\N	1783
11070	0	KG	10	0	10	2356
11071	0	KG	10	0	10	2356
8401	0	KG	3	\N	\N	1785
11072	0	KG	10	0	10	2356
8403	0	KG	3	\N	\N	1785
11073	120	KG	5	\N	\N	2357
8405	0	KG	3	\N	\N	1785
11074	120	KG	5	\N	\N	2357
8407	0	KG	3	\N	\N	1785
8408	0	KG	3	\N	\N	1785
8409	0	KG	3	\N	\N	1786
8410	0	KG	3	\N	\N	1786
8411	0	KG	3	\N	\N	1786
8412	0	KG	3	\N	\N	1786
8413	0	KG	3	\N	\N	1786
8414	0	KG	3	\N	\N	1787
8415	0	KG	3	\N	\N	1787
8416	0	KG	3	\N	\N	1787
8417	0	KG	3	\N	\N	1787
8418	0	KG	3	\N	\N	1787
8419	50	KG	3	\N	\N	1788
8420	50	KG	3	\N	\N	1788
8421	50	KG	3	\N	\N	1788
8422	50	KG	3	\N	\N	1788
8423	50	KG	3	\N	\N	1788
8424	20	KG	5	\N	\N	1789
8425	20	KG	5	\N	\N	1789
8426	20	KG	5	\N	\N	1789
8427	20	KG	5	\N	\N	1789
8428	50	KG	3	\N	\N	1790
8429	20	KG	5	\N	\N	1789
8430	50	KG	3	\N	\N	1790
8431	50	KG	3	\N	\N	1790
11075	120	KG	5	\N	\N	2357
8433	50	KG	3	\N	\N	1790
11076	120	KG	5	\N	\N	2357
8435	50	KG	3	\N	\N	1790
11077	120	KG	5	\N	\N	2357
16732	0	KG	0	\N	\N	3672
8438	50	KG	3	\N	\N	1792
16733	0	KG	0	\N	\N	3672
8440	50	KG	3	\N	\N	1792
8441	50	KG	3	\N	\N	1792
8442	0	KG	3	\N	\N	1793
8443	50	KG	3	\N	\N	1792
8444	0	KG	3	\N	\N	1793
8445	50	KG	3	\N	\N	1792
8446	0	KG	3	\N	\N	1793
8447	0	KG	3	\N	\N	1793
8448	0	KG	3	\N	\N	1793
16734	0	KG	0	\N	\N	3672
16735	0	KG	0	\N	\N	3672
8451	0	KG	3	\N	\N	1795
16736	0	KG	0	\N	\N	3672
8453	0	KG	3	\N	\N	1795
16737	0	KG	0	\N	\N	3673
8455	0	KG	3	\N	\N	1795
8456	0	KG	3	\N	\N	1795
16738	0	KG	0	\N	\N	3673
8458	0	KG	3	\N	\N	1795
8459	0	KG	3	\N	\N	1796
8460	0	KG	3	\N	\N	1796
8461	0	KG	3	\N	\N	1796
8462	0	KG	3	\N	\N	1796
8463	0	KG	3	\N	\N	1796
8464	0	KG	3	\N	\N	1797
8465	0	KG	3	\N	\N	1797
8466	0	KG	3	\N	\N	1797
8467	0	KG	3	\N	\N	1797
8468	0	KG	3	\N	\N	1797
16739	0	KG	0	\N	\N	3673
16740	0	KG	0	\N	\N	3673
16741	0	KG	0	\N	\N	3673
16742	0	KG	0	\N	\N	3674
16743	0	KG	0	\N	\N	3674
16744	0	KG	0	\N	\N	3674
16745	0	KG	0	\N	\N	3674
16746	0	KG	0	\N	\N	3674
16747	0	KG	0	\N	\N	3675
16748	0	KG	0	\N	\N	3675
8479	50	KG	3	\N	\N	1800
16749	0	KG	0	\N	\N	3675
8481	50	KG	3	\N	\N	1800
16750	0	KG	0	\N	\N	3675
8483	50	KG	3	\N	\N	1800
16751	0	KG	0	\N	\N	3675
8485	50	KG	3	\N	\N	1800
16752	0	KG	0	\N	\N	3676
8487	50	KG	3	\N	\N	1800
16753	0	KG	0	\N	\N	3676
8489	0	KG	3	\N	\N	1802
16754	0	KG	0	\N	\N	3676
8491	0	KG	3	\N	\N	1802
16755	0	KG	0	\N	\N	3676
8493	0	KG	3	\N	\N	1802
8495	0	KG	3	\N	\N	1802
8497	0	KG	3	\N	\N	1802
8500	50	KG	3	\N	\N	1805
8502	50	KG	3	\N	\N	1805
8504	50	KG	3	\N	\N	1805
8506	50	KG	3	\N	\N	1805
8508	50	KG	3	\N	\N	1805
8509	0	KG	3	\N	\N	1806
8510	0	KG	3	\N	\N	1806
8511	0	KG	3	\N	\N	1806
8512	0	KG	3	\N	\N	1806
8513	0	KG	3	\N	\N	1806
8514	0	KG	3	\N	\N	1807
8515	0	KG	3	\N	\N	1807
8516	0	KG	3	\N	\N	1807
8517	0	KG	3	\N	\N	1807
8518	0	KG	3	\N	\N	1807
8534	50	KG	3	\N	\N	1811
8535	50	KG	3	\N	\N	1811
8537	50	KG	3	\N	\N	1811
8539	50	KG	3	\N	\N	1811
8542	50	KG	3	\N	\N	1811
16756	0	KG	0	\N	\N	3676
11534	0	KG	12	0	15	2466
11535	0	KG	12	0	12	2466
11536	0	KG	12	0	10	2466
11537	27.5	KG	8	27.5	8	2467
11538	27.5	KG	8	27.5	8	2467
11539	27.5	KG	8	27.5	8	2467
11540	25	KG	8	28	8	2468
11541	25	KG	8	28	8	2468
11542	25	KG	8	28	8	2468
8559	0	KG	3	\N	\N	1816
8560	0	KG	3	\N	\N	1816
8561	0	KG	3	\N	\N	1816
8562	0	KG	3	\N	\N	1816
8563	0	KG	3	\N	\N	1816
8564	0	KG	3	\N	\N	1817
8565	0	KG	3	\N	\N	1817
8567	0	KG	3	\N	\N	1817
8569	0	KG	3	\N	\N	1817
8571	0	KG	3	\N	\N	1817
8499	0	KG	3	\N	\N	1804
8501	0	KG	3	\N	\N	1804
8503	0	KG	3	\N	\N	1804
8505	0	KG	3	\N	\N	1804
8507	0	KG	3	\N	\N	1804
8519	20	KG	5	\N	\N	1808
8520	20	KG	5	\N	\N	1808
8521	20	KG	5	\N	\N	1808
8522	20	KG	5	\N	\N	1808
8523	20	KG	5	\N	\N	1808
8524	50	KG	3	\N	\N	1809
8525	50	KG	3	\N	\N	1809
8526	50	KG	3	\N	\N	1809
8527	50	KG	3	\N	\N	1809
8528	50	KG	3	\N	\N	1809
11543	25	KG	8	25	8	2469
11544	25	KG	8	25	8	2469
11545	25	KG	8	25	6	2469
11546	23.5	KG	8	23.5	8	2470
11547	23.5	KG	8	23.5	8	2470
8536	0	KG	3	\N	\N	1812
8538	0	KG	3	\N	\N	1812
8540	0	KG	3	\N	\N	1812
8541	0	KG	3	\N	\N	1812
8543	0	KG	3	\N	\N	1812
8544	0	KG	3	\N	\N	1813
8546	0	KG	3	\N	\N	1813
8548	0	KG	3	\N	\N	1813
8550	0	KG	3	\N	\N	1813
8551	0	KG	3	\N	\N	1813
11548	23.5	KG	8	23.5	8	2470
11549	28.5	KG	8	28.5	8	2471
11550	28.5	KG	8	28.5	8	2471
14023	50	KG	3	\N	\N	3033
14024	50	KG	3	\N	\N	3033
8574	50	KG	3	\N	\N	1819
8575	50	KG	3	\N	\N	1819
8576	50	KG	3	\N	\N	1819
8577	50	KG	3	\N	\N	1819
8578	50	KG	3	\N	\N	1819
8579	20	KG	5	\N	\N	1820
8580	20	KG	5	\N	\N	1820
8581	20	KG	5	\N	\N	1820
8582	20	KG	5	\N	\N	1820
8583	20	KG	5	\N	\N	1820
8584	0	KG	3	\N	\N	1821
8585	0	KG	3	\N	\N	1821
8586	0	KG	3	\N	\N	1821
8587	0	KG	3	\N	\N	1821
8588	0	KG	3	\N	\N	1821
8589	0	KG	3	\N	\N	1822
8590	0	KG	3	\N	\N	1822
8591	0	KG	3	\N	\N	1822
8592	0	KG	3	\N	\N	1822
8593	0	KG	3	\N	\N	1822
14025	50	KG	3	\N	\N	3033
14026	50	KG	3	\N	\N	3033
14027	50	KG	3	\N	\N	3033
14028	20	KG	5	\N	\N	3034
14029	20	KG	5	\N	\N	3034
14030	20	KG	5	\N	\N	3034
14031	20	KG	5	\N	\N	3034
14032	20	KG	5	\N	\N	3034
14033	20	KG	5	\N	\N	3035
14034	20	KG	5	\N	\N	3035
14035	20	KG	5	\N	\N	3035
14036	20	KG	5	\N	\N	3035
14037	20	KG	5	\N	\N	3035
14038	0	KG	8	\N	\N	3036
14039	0	KG	8	\N	\N	3036
8609	0	KG	3	\N	\N	1826
8610	0	KG	3	\N	\N	1826
8611	0	KG	3	\N	\N	1826
8612	0	KG	3	\N	\N	1826
8613	0	KG	3	\N	\N	1826
8614	0	KG	3	\N	\N	1827
8615	0	KG	3	\N	\N	1827
8616	0	KG	3	\N	\N	1827
8617	0	KG	3	\N	\N	1827
8618	0	KG	3	\N	\N	1827
8619	50	KG	3	\N	\N	1828
8620	50	KG	3	\N	\N	1828
8621	50	KG	3	\N	\N	1828
8622	50	KG	3	\N	\N	1828
8623	50	KG	3	\N	\N	1828
12344	0	KG	8	\N	\N	2656
12345	0	KG	8	\N	\N	2656
12346	0	KG	8	\N	\N	2656
8634	0	KG	3	\N	\N	1831
8635	0	KG	3	\N	\N	1831
8636	0	KG	3	\N	\N	1831
8637	0	KG	3	\N	\N	1831
8638	0	KG	3	\N	\N	1831
8639	0	KG	3	\N	\N	1832
8640	0	KG	3	\N	\N	1832
8641	0	KG	3	\N	\N	1832
8642	0	KG	3	\N	\N	1832
8643	0	KG	3	\N	\N	1832
8644	50	KG	3	\N	\N	1833
8645	50	KG	3	\N	\N	1833
8646	50	KG	3	\N	\N	1833
8647	50	KG	3	\N	\N	1833
8648	50	KG	3	\N	\N	1833
8649	50	KG	3	\N	\N	1834
8650	50	KG	3	\N	\N	1834
8651	50	KG	3	\N	\N	1834
8652	50	KG	3	\N	\N	1834
8653	50	KG	3	\N	\N	1834
11568	57.5	KG	6	57.5	8	2478
11569	77.5	KG	6	77.5	8	2478
11570	87.5	KG	6	87.5	8	2478
11571	92.5	KG	6	92.5	6	2478
11572	92.5	KG	6	92.5	6	2478
11573	0	KG	1	0	1	2479
11574	57.5	KG	9	\N	\N	2480
11575	77.5	KG	9	\N	\N	2480
11576	87.5	KG	9	\N	\N	2480
11577	92.5	KG	7	\N	\N	2480
8664	0	KG	3	\N	\N	1837
8665	0	KG	3	\N	\N	1837
8666	0	KG	3	\N	\N	1837
8667	0	KG	3	\N	\N	1837
8668	0	KG	3	\N	\N	1837
8669	50	KG	3	\N	\N	1838
8670	50	KG	3	\N	\N	1838
8671	50	KG	3	\N	\N	1838
8672	50	KG	3	\N	\N	1838
8673	50	KG	3	\N	\N	1838
8674	20	KG	5	\N	\N	1839
8675	20	KG	5	\N	\N	1839
8676	20	KG	5	\N	\N	1839
8677	20	KG	5	\N	\N	1839
8678	20	KG	5	\N	\N	1839
8679	50	KG	3	\N	\N	1840
8680	50	KG	3	\N	\N	1840
8681	50	KG	3	\N	\N	1840
8682	50	KG	3	\N	\N	1840
8683	50	KG	3	\N	\N	1840
11578	92.5	KG	7	\N	\N	2480
11579	0	KG	2	\N	\N	2481
12347	0	KG	8	\N	\N	2656
12348	0	KG	8	\N	\N	2656
12349	0	KG	8	\N	\N	2657
12350	0	KG	8	\N	\N	2657
12351	0	KG	8	\N	\N	2657
12352	0	KG	8	\N	\N	2657
12353	0	KG	8	\N	\N	2657
12708	50	KG	3	\N	\N	2728
12709	20	KG	5	\N	\N	2729
12710	20	KG	5	\N	\N	2729
12711	20	KG	5	\N	\N	2729
12712	20	KG	5	\N	\N	2729
12713	20	KG	5	\N	\N	2729
12714	50	KG	3	\N	\N	2730
12715	50	KG	3	\N	\N	2730
12716	50	KG	3	\N	\N	2730
12717	50	KG	3	\N	\N	2730
12718	50	KG	3	\N	\N	2730
14040	0	KG	8	\N	\N	3036
14041	0	KG	8	\N	\N	3036
14042	0	KG	8	\N	\N	3036
14043	0	KG	8	\N	\N	3037
14044	0	KG	8	\N	\N	3037
12719	0	KG	8	\N	\N	2731
12720	0	KG	8	\N	\N	2731
12721	0	KG	8	\N	\N	2731
12722	0	KG	8	\N	\N	2731
12723	0	KG	8	\N	\N	2731
14045	0	KG	8	\N	\N	3037
14046	0	KG	8	\N	\N	3037
14047	0	KG	8	\N	\N	3037
14048	50	KG	3	\N	\N	3038
14049	50	KG	3	\N	\N	3038
12724	0	KG	8	\N	\N	2732
12725	0	KG	8	\N	\N	2732
12726	0	KG	8	\N	\N	2732
12727	0	KG	8	\N	\N	2732
12728	0	KG	8	\N	\N	2732
14050	50	KG	3	\N	\N	3038
14051	50	KG	3	\N	\N	3038
14052	50	KG	3	\N	\N	3038
14053	50	KG	3	\N	\N	3039
14054	50	KG	3	\N	\N	3039
14055	50	KG	3	\N	\N	3039
14056	50	KG	3	\N	\N	3039
14057	50	KG	3	\N	\N	3039
14058	50	KG	3	\N	\N	3040
14059	50	KG	3	\N	\N	3040
14060	50	KG	3	\N	\N	3040
14061	50	KG	3	\N	\N	3040
14062	50	KG	3	\N	\N	3040
14063	0	KG	8	\N	\N	3041
14064	0	KG	8	\N	\N	3041
14065	0	KG	8	\N	\N	3041
14066	0	KG	8	\N	\N	3041
14067	0	KG	8	\N	\N	3041
14068	0	KG	8	\N	\N	3042
14069	0	KG	8	\N	\N	3042
12729	50	KG	3	\N	\N	2733
12730	50	KG	3	\N	\N	2733
12731	50	KG	3	\N	\N	2733
12732	50	KG	3	\N	\N	2733
12733	50	KG	3	\N	\N	2733
12734	50	KG	3	\N	\N	2734
12735	50	KG	3	\N	\N	2734
12736	50	KG	3	\N	\N	2734
12737	50	KG	3	\N	\N	2734
12738	50	KG	3	\N	\N	2734
12739	50	KG	3	\N	\N	2735
12740	50	KG	3	\N	\N	2735
12741	50	KG	3	\N	\N	2735
12742	50	KG	3	\N	\N	2735
12743	50	KG	3	\N	\N	2735
8759	0	KG	3	\N	\N	1856
8760	0	KG	3	\N	\N	1856
8761	0	KG	3	\N	\N	1856
8762	0	KG	3	\N	\N	1856
8763	0	KG	3	\N	\N	1856
8764	0	KG	3	\N	\N	1857
8765	0	KG	3	\N	\N	1857
8766	0	KG	3	\N	\N	1857
8767	0	KG	3	\N	\N	1857
8768	0	KG	3	\N	\N	1857
12744	0	KG	8	\N	\N	2736
12745	0	KG	8	\N	\N	2736
12746	0	KG	8	\N	\N	2736
12747	0	KG	8	\N	\N	2736
12748	0	KG	8	\N	\N	2736
12749	0	KG	8	\N	\N	2737
12750	0	KG	8	\N	\N	2737
12751	0	KG	8	\N	\N	2737
12752	0	KG	8	\N	\N	2737
8779	50	KG	3	\N	\N	1860
8780	50	KG	3	\N	\N	1860
8781	50	KG	3	\N	\N	1860
8782	50	KG	3	\N	\N	1860
8783	50	KG	3	\N	\N	1860
8784	0	KG	3	\N	\N	1861
8785	0	KG	3	\N	\N	1861
8786	0	KG	3	\N	\N	1861
8787	0	KG	3	\N	\N	1861
8788	0	KG	3	\N	\N	1861
12354	50	KG	3	\N	\N	2658
12355	50	KG	3	\N	\N	2658
12356	50	KG	3	\N	\N	2658
12357	50	KG	3	\N	\N	2658
12358	50	KG	3	\N	\N	2658
12359	50	KG	3	\N	\N	2659
12360	50	KG	3	\N	\N	2659
12361	50	KG	3	\N	\N	2659
12362	50	KG	3	\N	\N	2659
12363	50	KG	3	\N	\N	2659
8799	50	KG	3	\N	\N	1864
8800	50	KG	3	\N	\N	1864
8801	50	KG	3	\N	\N	1864
8802	50	KG	3	\N	\N	1864
8803	50	KG	3	\N	\N	1864
8804	50	KG	3	\N	\N	1865
8805	50	KG	3	\N	\N	1865
8806	50	KG	3	\N	\N	1865
8807	50	KG	3	\N	\N	1865
8808	50	KG	3	\N	\N	1865
12364	50	KG	3	\N	\N	2660
12365	50	KG	3	\N	\N	2660
12366	50	KG	3	\N	\N	2660
12367	50	KG	3	\N	\N	2660
12368	50	KG	3	\N	\N	2660
8814	0	KG	3	\N	\N	1867
8815	0	KG	3	\N	\N	1867
8816	0	KG	3	\N	\N	1867
8817	0	KG	3	\N	\N	1867
8818	0	KG	3	\N	\N	1867
12369	0	KG	8	\N	\N	2661
12370	0	KG	8	\N	\N	2661
12371	0	KG	8	\N	\N	2661
12372	0	KG	8	\N	\N	2661
12373	0	KG	8	\N	\N	2661
8824	50	KG	3	\N	\N	1869
8825	50	KG	3	\N	\N	1869
8826	50	KG	3	\N	\N	1869
8827	50	KG	3	\N	\N	1869
8828	50	KG	3	\N	\N	1869
8829	50	KG	3	\N	\N	1870
8830	50	KG	3	\N	\N	1870
8831	50	KG	3	\N	\N	1870
8832	50	KG	3	\N	\N	1870
8833	50	KG	3	\N	\N	1870
12374	0	KG	8	\N	\N	2662
12375	0	KG	8	\N	\N	2662
12376	0	KG	8	\N	\N	2662
12377	0	KG	8	\N	\N	2662
12378	0	KG	8	\N	\N	2662
8839	0	KG	3	\N	\N	1872
8840	0	KG	3	\N	\N	1872
8841	0	KG	3	\N	\N	1872
8842	0	KG	3	\N	\N	1872
8843	0	KG	3	\N	\N	1872
8844	50	KG	3	\N	\N	1873
8845	50	KG	3	\N	\N	1873
8846	50	KG	3	\N	\N	1873
8847	50	KG	3	\N	\N	1873
8848	50	KG	3	\N	\N	1873
12379	50	KG	3	\N	\N	2663
12380	50	KG	3	\N	\N	2663
12381	50	KG	3	\N	\N	2663
12382	50	KG	3	\N	\N	2663
12383	50	KG	3	\N	\N	2663
12384	20	KG	5	\N	\N	2664
12385	20	KG	5	\N	\N	2664
12386	20	KG	5	\N	\N	2664
12387	20	KG	5	\N	\N	2664
12388	20	KG	5	\N	\N	2664
8859	0	KG	3	\N	\N	1876
8860	0	KG	3	\N	\N	1876
8861	0	KG	3	\N	\N	1876
8862	0	KG	3	\N	\N	1876
8863	0	KG	3	\N	\N	1876
12389	50	KG	3	\N	\N	2665
12390	50	KG	3	\N	\N	2665
12391	50	KG	3	\N	\N	2665
12392	50	KG	3	\N	\N	2665
12393	50	KG	3	\N	\N	2665
12394	0	KG	8	\N	\N	2666
12395	0	KG	8	\N	\N	2666
12396	0	KG	8	\N	\N	2666
12397	0	KG	8	\N	\N	2666
12398	0	KG	8	\N	\N	2666
8874	20	KG	5	\N	\N	1879
8875	20	KG	5	\N	\N	1879
8876	20	KG	5	\N	\N	1879
8877	20	KG	5	\N	\N	1879
8878	20	KG	5	\N	\N	1879
8879	50	KG	3	\N	\N	1880
8880	50	KG	3	\N	\N	1880
8881	50	KG	3	\N	\N	1880
8882	50	KG	3	\N	\N	1880
8883	50	KG	3	\N	\N	1880
8884	0	KG	3	\N	\N	1881
8885	0	KG	3	\N	\N	1881
8886	0	KG	3	\N	\N	1881
8887	0	KG	3	\N	\N	1881
8888	0	KG	3	\N	\N	1881
8889	0	KG	3	\N	\N	1882
8890	0	KG	3	\N	\N	1882
8891	0	KG	3	\N	\N	1882
8892	0	KG	3	\N	\N	1882
8893	0	KG	3	\N	\N	1882
12399	0	KG	8	\N	\N	2667
12400	0	KG	8	\N	\N	2667
12401	0	KG	8	\N	\N	2667
12402	0	KG	8	\N	\N	2667
12403	0	KG	8	\N	\N	2667
8899	20	KG	5	\N	\N	1884
8900	20	KG	5	\N	\N	1884
8901	20	KG	5	\N	\N	1884
8902	20	KG	5	\N	\N	1884
8903	20	KG	5	\N	\N	1884
8904	50	KG	3	\N	\N	1885
8905	50	KG	3	\N	\N	1885
8906	50	KG	3	\N	\N	1885
8907	50	KG	3	\N	\N	1885
8908	50	KG	3	\N	\N	1885
8909	0	KG	3	\N	\N	1886
8910	0	KG	3	\N	\N	1886
8911	0	KG	3	\N	\N	1886
8912	0	KG	3	\N	\N	1886
8913	0	KG	3	\N	\N	1886
12404	50	KG	3	\N	\N	2668
12405	50	KG	3	\N	\N	2668
12406	50	KG	3	\N	\N	2668
12407	50	KG	3	\N	\N	2668
12408	50	KG	3	\N	\N	2668
8995	40.5	KG	1	40.5	1	1904
8996	40.5	KG	1	40.5	1	1904
8997	40.5	KG	1	40.5	1	1904
8998	40.5	KG	1	40.5	1	1904
8999	40.5	KG	1	40.5	1	1904
9000	20	KG	7	20	7	1905
9001	20	KG	7	20	7	1905
9002	20	KG	7	20	7	1905
9003	20	KG	7	20	7	1905
9004	20	KG	7	20	7	1905
9010	0	KG	8	0	8	1907
9011	0	KG	8	0	8	1907
9012	0	KG	8	0	8	1907
9013	0	KG	8	0	8	1907
9014	0	KG	8	0	8	1907
9015	0	KG	8	0	8	1908
9016	0	KG	8	0	8	1908
9017	0	KG	8	0	6	1908
9018	0	KG	8	0	7	1908
9019	0	KG	8	0	7	1908
10291	0	KG	10	\N	\N	2199
10292	0	KG	10	\N	\N	2199
11581	0	KG	8	\N	\N	2483
11582	0	KG	8	\N	\N	2483
11583	0	KG	8	\N	\N	2483
11584	0	KG	8	\N	\N	2483
11585	0	KG	8	\N	\N	2483
11586	0	KG	8	\N	\N	2484
11587	0	KG	8	\N	\N	2484
11588	0	KG	8	\N	\N	2484
11589	0	KG	8	\N	\N	2484
11590	0	KG	8	\N	\N	2484
11591	0	KG	8	\N	\N	2485
11592	0	KG	8	\N	\N	2485
11593	0	KG	8	\N	\N	2485
11594	0	KG	8	\N	\N	2485
11595	0	KG	8	\N	\N	2485
11596	0	KG	8	\N	\N	2486
11597	0	KG	8	\N	\N	2486
11598	0	KG	8	\N	\N	2486
11599	0	KG	8	\N	\N	2486
11600	0	KG	8	\N	\N	2486
10539	0	KG	8	\N	\N	2250
10540	0	KG	8	\N	\N	2250
10541	0	KG	8	\N	\N	2250
10542	0	KG	8	\N	\N	2250
10543	0	KG	8	\N	\N	2250
10649	40.5	KG	6	40.5	6	2272
10650	45	KG	6	45	6	2272
10651	45	KG	6	45.5	7	2272
10652	45	KG	6	45.5	7	2272
10653	50	KG	7	50	7	2272
10654	20	KG	8	20	8	2273
10655	20	KG	8	20	8	2273
10656	20	KG	8	20	8	2273
10657	20	KG	8	20	8	2273
10658	20	KG	8	20	8	2273
10664	0	KG	9	0	9	2275
10665	0	KG	9	0	9	2275
10666	0	KG	9	0	9	2275
10667	0	KG	9	0	9	2275
10668	0	KG	9	0	9	2275
10669	0	KG	10	0	10	2276
10670	0	KG	10	0	10	2276
10671	0	KG	10	0	10	2276
10672	0	KG	10	0	10	2276
10673	0	KG	10	0	10	2276
11601	0	KG	8	\N	\N	2487
11602	0	KG	8	\N	\N	2487
11603	0	KG	8	\N	\N	2487
11604	0	KG	8	\N	\N	2487
11605	0	KG	8	\N	\N	2487
11606	0	KG	8	\N	\N	2488
11607	0	KG	8	\N	\N	2488
11608	0	KG	8	\N	\N	2488
11609	0	KG	8	\N	\N	2488
11610	0	KG	8	\N	\N	2488
11611	0	KG	8	\N	\N	2489
11612	0	KG	8	\N	\N	2489
11613	0	KG	8	\N	\N	2489
11614	0	KG	8	\N	\N	2489
11615	0	KG	8	\N	\N	2489
11616	0	KG	8	\N	\N	2490
11617	0	KG	8	\N	\N	2490
11618	0	KG	8	\N	\N	2490
11619	0	KG	8	\N	\N	2490
11620	0	KG	8	\N	\N	2490
11621	0	KG	8	\N	\N	2491
11622	0	KG	8	\N	\N	2491
11623	0	KG	8	\N	\N	2491
11624	0	KG	8	\N	\N	2491
11625	0	KG	8	\N	\N	2491
11626	0	KG	8	\N	\N	2492
11627	0	KG	8	\N	\N	2492
11628	0	KG	8	\N	\N	2492
11629	0	KG	8	\N	\N	2492
11630	0	KG	8	\N	\N	2492
11631	0	KG	8	\N	\N	2493
11632	0	KG	8	\N	\N	2493
11633	0	KG	8	\N	\N	2493
11634	0	KG	8	\N	\N	2493
11635	0	KG	8	\N	\N	2493
11636	0	KG	8	\N	\N	2494
10343	50	KG	3	\N	\N	2210
10344	50	KG	3	\N	\N	2210
10345	50	KG	3	\N	\N	2210
10346	50	KG	3	\N	\N	2210
10347	50	KG	3	\N	\N	2210
11637	0	KG	8	\N	\N	2494
11638	0	KG	8	\N	\N	2494
11639	0	KG	8	\N	\N	2494
11640	0	KG	8	\N	\N	2494
11641	0	KG	8	\N	\N	2495
10353	20	KG	5	\N	\N	2212
10354	20	KG	5	\N	\N	2212
10355	20	KG	5	\N	\N	2212
10356	20	KG	5	\N	\N	2212
10357	20	KG	5	\N	\N	2212
11642	0	KG	8	\N	\N	2495
11643	0	KG	8	\N	\N	2495
11644	0	KG	8	\N	\N	2495
11645	0	KG	8	\N	\N	2495
11646	0	KG	8	\N	\N	2496
11647	0	KG	8	\N	\N	2496
11648	0	KG	8	\N	\N	2496
11649	0	KG	8	\N	\N	2496
11650	0	KG	8	\N	\N	2496
11651	0	KG	8	\N	\N	2497
11652	0	KG	8	\N	\N	2497
11653	0	KG	8	\N	\N	2497
11654	0	KG	8	\N	\N	2497
11655	0	KG	8	\N	\N	2497
12409	50	KG	3	\N	\N	2669
12410	50	KG	3	\N	\N	2669
12411	50	KG	3	\N	\N	2669
12412	50	KG	3	\N	\N	2669
12413	50	KG	3	\N	\N	2669
12414	50	KG	3	\N	\N	2670
10378	50	KG	3	\N	\N	2217
10379	50	KG	3	\N	\N	2217
10380	50	KG	3	\N	\N	2217
10381	50	KG	3	\N	\N	2217
10382	50	KG	3	\N	\N	2217
10383	0	KG	8	\N	\N	2218
10384	0	KG	8	\N	\N	2218
10385	0	KG	8	\N	\N	2218
10386	0	KG	8	\N	\N	2218
10387	0	KG	8	\N	\N	2218
10388	0	KG	8	\N	\N	2219
10389	0	KG	8	\N	\N	2219
10390	0	KG	8	\N	\N	2219
10391	0	KG	8	\N	\N	2219
10392	0	KG	8	\N	\N	2219
12415	50	KG	3	\N	\N	2670
12416	50	KG	3	\N	\N	2670
12417	50	KG	3	\N	\N	2670
12418	50	KG	3	\N	\N	2670
12419	0	KG	8	\N	\N	2671
12420	0	KG	8	\N	\N	2671
12421	0	KG	8	\N	\N	2671
12422	0	KG	8	\N	\N	2671
12423	0	KG	8	\N	\N	2671
12424	0	KG	8	\N	\N	2672
12425	0	KG	8	\N	\N	2672
12426	0	KG	8	\N	\N	2672
12427	0	KG	8	\N	\N	2672
12428	0	KG	8	\N	\N	2672
12429	20	KG	5	\N	\N	2673
12430	20	KG	5	\N	\N	2673
12431	20	KG	5	\N	\N	2673
12432	20	KG	5	\N	\N	2673
12433	20	KG	5	\N	\N	2673
12434	50	KG	3	\N	\N	2674
12435	50	KG	3	\N	\N	2674
12436	50	KG	3	\N	\N	2674
12437	50	KG	3	\N	\N	2674
12438	50	KG	3	\N	\N	2674
12439	50	KG	3	\N	\N	2675
12440	50	KG	3	\N	\N	2675
12441	50	KG	3	\N	\N	2675
12442	50	KG	3	\N	\N	2675
12443	50	KG	3	\N	\N	2675
12444	0	KG	8	\N	\N	2676
12445	0	KG	8	\N	\N	2676
12446	0	KG	8	\N	\N	2676
12447	0	KG	8	\N	\N	2676
12448	0	KG	8	\N	\N	2676
12449	0	KG	8	\N	\N	2677
12450	0	KG	8	\N	\N	2677
12451	0	KG	8	\N	\N	2677
12452	0	KG	8	\N	\N	2677
12453	0	KG	8	\N	\N	2677
12753	0	KG	8	\N	\N	2737
12820	0	KG	8	\N	\N	2751
12821	0	KG	8	\N	\N	2751
12822	0	KG	8	\N	\N	2751
12823	0	KG	8	\N	\N	2751
12824	0	KG	8	\N	\N	2752
12825	0	KG	8	\N	\N	2752
12826	0	KG	8	\N	\N	2752
12827	0	KG	8	\N	\N	2752
12828	0	KG	8	\N	\N	2752
12829	20	KG	5	\N	\N	2753
12830	20	KG	5	\N	\N	2753
12831	20	KG	5	\N	\N	2753
12832	20	KG	5	\N	\N	2753
12833	20	KG	5	\N	\N	2753
12834	50	KG	3	\N	\N	2754
12835	50	KG	3	\N	\N	2754
12836	50	KG	3	\N	\N	2754
12837	50	KG	3	\N	\N	2754
12838	50	KG	3	\N	\N	2754
12839	50	KG	3	\N	\N	2755
12840	50	KG	3	\N	\N	2755
10393	75	KG	5	80	5	2220
10394	75	KG	5	75	5	2220
10395	75	KG	5	75	5	2220
10396	75	KG	5	75	5	2220
10397	75	KG	5	75	5	2220
10398	100	KG	5	100	5	2221
10399	100	KG	5	100	5	2221
10400	100	KG	5	100	5	2221
10401	100	KG	5	100	5	2221
10402	100	KG	5	100	5	2221
10403	50	KG	5	50	5	2222
10404	50	KG	7	50	7	2222
10405	50	KG	7	50	5	2222
10406	50	KG	7	50	4	2222
10407	50	KG	7	\N	\N	2222
11200	70	KG	6	70	6	2384
11201	75	KG	6	75	4	2384
11202	75	KG	6	75	3	2384
11203	75	KG	6	70	4	2384
11204	75	KG	6	70	3	2384
10413	0	KG	15	\N	\N	2224
10414	0	KG	15	\N	\N	2224
10415	0	KG	15	\N	\N	2224
10416	0	KG	15	\N	\N	2224
10417	0	KG	15	\N	\N	2224
11656	75	KG	5	75	5	2498
11657	75	KG	5	75	5	2498
11658	75	KG	5	75	5	2498
11659	20	KG	8	22.5	8	2499
11660	20	KG	8	22.5	8	2499
11661	20	KG	8	22.5	7	2499
11662	7.5	KG	12	7.5	15	2500
11663	7.5	KG	12	7.5	12	2500
14070	0	KG	8	\N	\N	3042
14071	0	KG	8	\N	\N	3042
14072	0	KG	8	\N	\N	3042
14073	20	KG	5	\N	\N	3043
14074	20	KG	5	\N	\N	3043
14075	20	KG	5	\N	\N	3043
14076	20	KG	5	\N	\N	3043
11205	100	KG	6	100	6	2385
11206	100	KG	6	100	6	2385
11207	100	KG	6	100	6	2385
11208	100	KG	6	100	6	2385
11209	100	KG	6	100	6	2385
14077	20	KG	5	\N	\N	3043
14078	50	KG	3	\N	\N	3044
14079	50	KG	3	\N	\N	3044
14080	50	KG	3	\N	\N	3044
14081	50	KG	3	\N	\N	3044
11210	50	KG	6	\N	\N	2386
11211	50	KG	8	\N	\N	2386
11212	50	KG	6	\N	\N	2386
11213	50	KG	6	\N	\N	2386
11214	50	KG	6	\N	\N	2386
11215	0	KG	15	0	15	2387
11216	0	KG	15	0	15	2387
11217	0	KG	15	0	15	2387
11218	0	KG	15	0	15	2387
11219	0	KG	15	0	15	2387
11220	0	KG	10	0	10	2388
11221	0	KG	10	0	10	2388
11222	0	KG	10	0	10	2388
11223	0	KG	10	0	10	2388
14082	50	KG	3	\N	\N	3044
14083	50	KG	3	\N	\N	3045
14084	50	KG	3	\N	\N	3045
14085	50	KG	3	\N	\N	3045
14086	50	KG	3	\N	\N	3045
14087	50	KG	3	\N	\N	3045
14088	0	KG	8	\N	\N	3046
14089	0	KG	8	\N	\N	3046
14090	0	KG	8	\N	\N	3046
14091	0	KG	8	\N	\N	3046
14092	0	KG	8	\N	\N	3046
14093	0	KG	8	\N	\N	3047
14094	0	KG	8	\N	\N	3047
16757	0	KG	0	\N	\N	3677
16758	0	KG	0	\N	\N	3677
16759	0	KG	0	\N	\N	3677
16760	0	KG	0	\N	\N	3677
16761	0	KG	0	\N	\N	3677
16762	0	KG	0	\N	\N	3678
16763	0	KG	0	\N	\N	3678
16764	0	KG	0	\N	\N	3678
16765	0	KG	0	\N	\N	3678
16766	0	KG	0	\N	\N	3678
16767	0	KG	0	\N	\N	3679
16768	0	KG	0	\N	\N	3679
16769	0	KG	0	\N	\N	3679
16770	0	KG	0	\N	\N	3679
16771	0	KG	0	\N	\N	3679
16772	0	KG	0	\N	\N	3680
11224	0	KG	10	\N	\N	2388
16773	0	KG	0	\N	\N	3680
16774	0	KG	0	\N	\N	3680
16775	0	KG	0	\N	\N	3680
16776	0	KG	0	\N	\N	3680
10754	50	KG	3	\N	\N	2293
10755	50	KG	3	\N	\N	2293
10756	50	KG	3	\N	\N	2293
10757	50	KG	3	\N	\N	2293
10758	50	KG	3	\N	\N	2293
16777	0	KG	0	\N	\N	3681
16778	0	KG	0	\N	\N	3681
16779	0	KG	0	\N	\N	3681
16780	0	KG	0	\N	\N	3681
16781	0	KG	0	\N	\N	3681
10764	0	KG	8	\N	\N	2295
10765	0	KG	8	\N	\N	2295
10766	0	KG	8	\N	\N	2295
10767	0	KG	8	\N	\N	2295
10768	0	KG	8	\N	\N	2295
16807	0	KG	0	\N	\N	3687
11664	7.5	KG	12	7.5	12	2500
12454	50	KG	3	\N	\N	2678
11665	42.5	KG	12	42.5	12	2501
11666	42.5	KG	12	42.5	12	2501
11667	42.5	KG	12	42.5	12	2501
11668	25	KG	8	24.5	6	2502
11669	25	KG	8	21	8	2502
11670	25	KG	8	21	6	2502
11671	8.75	KG	12	\N	\N	2503
11672	8.75	KG	12	\N	\N	2503
11673	6.25	KG	10	8.75	10	2504
11674	6.25	KG	10	8.75	10	2504
11675	15	KG	8	\N	\N	2505
11676	15	KG	8	\N	\N	2505
14095	0	KG	8	\N	\N	3047
14096	0	KG	8	\N	\N	3047
14097	0	KG	8	\N	\N	3047
14217	0	KG	8	0	8	3071
14218	0	KG	8	0	8	3071
14219	0	KG	8	0	8	3071
14220	0	KG	8	0	8	3072
14221	0	KG	8	0	8	3072
14222	0	KG	8	0	8	3072
14223	0	KG	8	0	8	3072
14224	0	KG	8	0	8	3072
14225	50	KG	4	\N	\N	3073
14226	50	KG	4	\N	\N	3073
14227	50	KG	4	\N	\N	3073
14228	50	KG	4	\N	\N	3073
14229	50	KG	4	\N	\N	3073
14230	50	KG	4	\N	\N	3073
14231	50	KG	4	\N	\N	3074
14232	50	KG	4	\N	\N	3074
9478	50	KG	3	\N	\N	2015
9479	50	KG	3	\N	\N	2015
9480	50	KG	3	\N	\N	2015
9481	50	KG	3	\N	\N	2015
9482	50	KG	3	\N	\N	2015
14233	50	KG	4	\N	\N	3074
12455	50	KG	3	\N	\N	2678
12456	50	KG	3	\N	\N	2678
12457	50	KG	3	\N	\N	2678
12458	50	KG	3	\N	\N	2678
12459	50	KG	3	\N	\N	2679
12460	50	KG	3	\N	\N	2679
12461	50	KG	3	\N	\N	2679
12462	50	KG	3	\N	\N	2679
12463	50	KG	3	\N	\N	2679
12464	20	KG	5	\N	\N	2680
12465	20	KG	5	\N	\N	2680
12466	20	KG	5	\N	\N	2680
12467	20	KG	5	\N	\N	2680
9498	0	KG	3	\N	\N	2019
9499	0	KG	3	\N	\N	2019
9500	0	KG	3	\N	\N	2019
9501	0	KG	3	\N	\N	2019
9502	0	KG	3	\N	\N	2019
9503	50	KG	3	\N	\N	2020
9504	50	KG	3	\N	\N	2020
9505	50	KG	3	\N	\N	2020
9506	50	KG	3	\N	\N	2020
9507	50	KG	3	\N	\N	2020
9508	20	KG	5	\N	\N	2021
9509	20	KG	5	\N	\N	2021
9510	20	KG	5	\N	\N	2021
9511	20	KG	5	\N	\N	2021
9512	20	KG	5	\N	\N	2021
12468	20	KG	5	\N	\N	2680
12469	0	KG	8	\N	\N	2681
12470	0	KG	8	\N	\N	2681
12471	0	KG	8	\N	\N	2681
12472	0	KG	8	\N	\N	2681
12473	0	KG	8	\N	\N	2681
12474	0	KG	8	\N	\N	2682
12475	0	KG	8	\N	\N	2682
12476	0	KG	8	\N	\N	2682
12477	0	KG	8	\N	\N	2682
12478	0	KG	8	\N	\N	2682
12479	50	KG	3	\N	\N	2683
12480	50	KG	3	\N	\N	2683
12481	50	KG	3	\N	\N	2683
12482	50	KG	3	\N	\N	2683
12483	50	KG	3	\N	\N	2683
12484	20	KG	5	\N	\N	2684
12485	20	KG	5	\N	\N	2684
12486	20	KG	5	\N	\N	2684
12487	20	KG	5	\N	\N	2684
9533	50	KG	3	\N	\N	2026
9534	50	KG	3	\N	\N	2026
9535	50	KG	3	\N	\N	2026
9536	50	KG	3	\N	\N	2026
9537	50	KG	3	\N	\N	2026
9538	50	KG	3	\N	\N	2027
9539	50	KG	3	\N	\N	2027
9540	50	KG	3	\N	\N	2027
9541	50	KG	3	\N	\N	2027
9542	50	KG	3	\N	\N	2027
12488	20	KG	5	\N	\N	2684
12489	50	KG	3	\N	\N	2685
12490	50	KG	3	\N	\N	2685
12491	50	KG	3	\N	\N	2685
12492	50	KG	3	\N	\N	2685
12493	50	KG	3	\N	\N	2685
12494	0	KG	8	\N	\N	2686
12495	0	KG	8	\N	\N	2686
12496	0	KG	8	\N	\N	2686
12497	0	KG	8	\N	\N	2686
9553	20	KG	5	\N	\N	2030
9554	20	KG	5	\N	\N	2030
9555	20	KG	5	\N	\N	2030
9556	20	KG	5	\N	\N	2030
9557	20	KG	5	\N	\N	2030
9558	50	KG	3	\N	\N	2031
9559	50	KG	3	\N	\N	2031
9560	50	KG	3	\N	\N	2031
9561	50	KG	3	\N	\N	2031
9562	50	KG	3	\N	\N	2031
12498	0	KG	8	\N	\N	2686
12499	0	KG	8	\N	\N	2687
9568	0	KG	3	\N	\N	2033
9569	0	KG	3	\N	\N	2033
9570	0	KG	3	\N	\N	2033
9571	0	KG	3	\N	\N	2033
9572	0	KG	3	\N	\N	2033
9573	0	KG	3	\N	\N	2034
9574	0	KG	3	\N	\N	2034
9575	0	KG	3	\N	\N	2034
9576	0	KG	3	\N	\N	2034
9577	0	KG	3	\N	\N	2034
9578	20	KG	5	\N	\N	2035
9579	20	KG	5	\N	\N	2035
9580	20	KG	5	\N	\N	2035
9581	20	KG	5	\N	\N	2035
9582	20	KG	5	\N	\N	2035
9583	50	KG	3	\N	\N	2036
9584	50	KG	3	\N	\N	2036
9585	50	KG	3	\N	\N	2036
9586	50	KG	3	\N	\N	2036
9587	50	KG	3	\N	\N	2036
9588	20	KG	5	\N	\N	2037
9589	20	KG	5	\N	\N	2037
9590	20	KG	5	\N	\N	2037
9591	20	KG	5	\N	\N	2037
9592	20	KG	5	\N	\N	2037
9593	0	KG	3	\N	\N	2038
9594	0	KG	3	\N	\N	2038
9595	0	KG	3	\N	\N	2038
9596	0	KG	3	\N	\N	2038
9597	0	KG	3	\N	\N	2038
12500	0	KG	8	\N	\N	2687
12501	0	KG	8	\N	\N	2687
12502	0	KG	8	\N	\N	2687
12503	0	KG	8	\N	\N	2687
12504	50	KG	3	\N	\N	2688
12505	50	KG	3	\N	\N	2688
12506	50	KG	3	\N	\N	2688
12507	50	KG	3	\N	\N	2688
12508	50	KG	3	\N	\N	2688
12509	50	KG	3	\N	\N	2689
12510	50	KG	3	\N	\N	2689
12511	50	KG	3	\N	\N	2689
12512	50	KG	3	\N	\N	2689
12513	50	KG	3	\N	\N	2689
12514	50	KG	3	\N	\N	2690
12515	50	KG	3	\N	\N	2690
12516	50	KG	3	\N	\N	2690
12517	50	KG	3	\N	\N	2690
12518	50	KG	3	\N	\N	2690
12519	0	KG	8	\N	\N	2691
12520	0	KG	8	\N	\N	2691
12521	0	KG	8	\N	\N	2691
12522	0	KG	8	\N	\N	2691
12523	0	KG	8	\N	\N	2691
12524	0	KG	8	\N	\N	2692
9623	0	KG	3	\N	\N	2044
9624	0	KG	3	\N	\N	2044
9625	0	KG	3	\N	\N	2044
9626	0	KG	3	\N	\N	2044
9627	0	KG	3	\N	\N	2044
9628	50	KG	3	\N	\N	2045
9629	50	KG	3	\N	\N	2045
9630	50	KG	3	\N	\N	2045
9631	50	KG	3	\N	\N	2045
9632	50	KG	3	\N	\N	2045
9633	20	KG	5	\N	\N	2046
9634	20	KG	5	\N	\N	2046
9635	20	KG	5	\N	\N	2046
9636	20	KG	5	\N	\N	2046
9637	20	KG	5	\N	\N	2046
9638	50	KG	3	\N	\N	2047
9639	50	KG	3	\N	\N	2047
9640	50	KG	3	\N	\N	2047
9641	50	KG	3	\N	\N	2047
9642	50	KG	3	\N	\N	2047
9643	0	KG	3	\N	\N	2048
9644	0	KG	3	\N	\N	2048
9645	0	KG	3	\N	\N	2048
9646	0	KG	3	\N	\N	2048
9647	0	KG	3	\N	\N	2048
9648	0	KG	3	\N	\N	2049
9649	0	KG	3	\N	\N	2049
9650	0	KG	3	\N	\N	2049
9651	0	KG	3	\N	\N	2049
9652	0	KG	3	\N	\N	2049
12525	0	KG	8	\N	\N	2692
12526	0	KG	8	\N	\N	2692
12527	0	KG	8	\N	\N	2692
12528	0	KG	8	\N	\N	2692
12754	50	KG	3	\N	\N	2738
9658	50	KG	3	\N	\N	2051
9659	50	KG	3	\N	\N	2051
9660	50	KG	3	\N	\N	2051
9661	50	KG	3	\N	\N	2051
9662	50	KG	3	\N	\N	2051
9663	50	KG	3	\N	\N	2052
9664	50	KG	3	\N	\N	2052
9665	50	KG	3	\N	\N	2052
9666	50	KG	3	\N	\N	2052
9667	50	KG	3	\N	\N	2052
9668	0	KG	3	\N	\N	2053
9669	0	KG	3	\N	\N	2053
9670	0	KG	3	\N	\N	2053
9671	0	KG	3	\N	\N	2053
9672	0	KG	3	\N	\N	2053
9673	0	KG	3	\N	\N	2054
9674	0	KG	3	\N	\N	2054
9675	0	KG	3	\N	\N	2054
9676	0	KG	3	\N	\N	2054
9677	0	KG	3	\N	\N	2054
9678	50	KG	3	\N	\N	2055
9679	50	KG	3	\N	\N	2055
9680	50	KG	3	\N	\N	2055
9681	50	KG	3	\N	\N	2055
9682	50	KG	3	\N	\N	2055
9683	20	KG	5	\N	\N	2056
9684	20	KG	5	\N	\N	2056
9685	20	KG	5	\N	\N	2056
9686	20	KG	5	\N	\N	2056
9687	20	KG	5	\N	\N	2056
12755	50	KG	3	\N	\N	2738
12756	50	KG	3	\N	\N	2738
12757	50	KG	3	\N	\N	2738
12758	50	KG	3	\N	\N	2738
12759	20	KG	5	\N	\N	2739
9693	0	KG	3	\N	\N	2058
9694	0	KG	3	\N	\N	2058
9695	0	KG	3	\N	\N	2058
9696	0	KG	3	\N	\N	2058
9697	0	KG	3	\N	\N	2058
9698	0	KG	3	\N	\N	2059
9699	0	KG	3	\N	\N	2059
9700	0	KG	3	\N	\N	2059
9701	0	KG	3	\N	\N	2059
9702	0	KG	3	\N	\N	2059
12760	20	KG	5	\N	\N	2739
12761	20	KG	5	\N	\N	2739
12762	20	KG	5	\N	\N	2739
9708	20	KG	5	\N	\N	2061
9709	20	KG	5	\N	\N	2061
9710	20	KG	5	\N	\N	2061
9711	20	KG	5	\N	\N	2061
9712	20	KG	5	\N	\N	2061
9713	20	KG	5	\N	\N	2062
9714	20	KG	5	\N	\N	2062
9715	20	KG	5	\N	\N	2062
9716	20	KG	5	\N	\N	2062
9717	20	KG	5	\N	\N	2062
9718	0	KG	3	\N	\N	2063
9719	0	KG	3	\N	\N	2063
9720	0	KG	3	\N	\N	2063
9721	0	KG	3	\N	\N	2063
9722	0	KG	3	\N	\N	2063
9723	0	KG	3	\N	\N	2064
9724	0	KG	3	\N	\N	2064
9725	0	KG	3	\N	\N	2064
9726	0	KG	3	\N	\N	2064
9727	0	KG	3	\N	\N	2064
9728	50	KG	3	\N	\N	2065
9729	50	KG	3	\N	\N	2065
9730	50	KG	3	\N	\N	2065
9731	50	KG	3	\N	\N	2065
9732	50	KG	3	\N	\N	2065
9738	50	KG	3	\N	\N	2067
9739	50	KG	3	\N	\N	2067
9740	50	KG	3	\N	\N	2067
9741	50	KG	3	\N	\N	2067
9742	50	KG	3	\N	\N	2067
9743	0	KG	3	\N	\N	2068
9744	0	KG	3	\N	\N	2068
9745	0	KG	3	\N	\N	2068
9746	0	KG	3	\N	\N	2068
9747	0	KG	3	\N	\N	2068
9748	0	KG	3	\N	\N	2069
9749	0	KG	3	\N	\N	2069
9750	0	KG	3	\N	\N	2069
9751	0	KG	3	\N	\N	2069
9752	0	KG	3	\N	\N	2069
9753	20	KG	5	\N	\N	2070
9754	20	KG	5	\N	\N	2070
9755	20	KG	5	\N	\N	2070
9756	20	KG	5	\N	\N	2070
9757	20	KG	5	\N	\N	2070
9763	20	KG	5	\N	\N	2072
9764	20	KG	5	\N	\N	2072
9765	20	KG	5	\N	\N	2072
9766	20	KG	5	\N	\N	2072
9767	20	KG	5	\N	\N	2072
9768	0	KG	3	\N	\N	2073
9769	0	KG	3	\N	\N	2073
9770	0	KG	3	\N	\N	2073
9771	0	KG	3	\N	\N	2073
9772	0	KG	3	\N	\N	2073
9773	0	KG	3	\N	\N	2074
9774	0	KG	3	\N	\N	2074
9775	0	KG	3	\N	\N	2074
9776	0	KG	3	\N	\N	2074
9777	0	KG	3	\N	\N	2074
9783	50	KG	3	\N	\N	2076
9784	50	KG	3	\N	\N	2076
9785	50	KG	3	\N	\N	2076
9786	50	KG	3	\N	\N	2076
9787	50	KG	3	\N	\N	2076
9788	50	KG	3	\N	\N	2077
9789	50	KG	3	\N	\N	2077
9790	50	KG	3	\N	\N	2077
9791	50	KG	3	\N	\N	2077
9792	50	KG	3	\N	\N	2077
9793	0	KG	3	\N	\N	2078
9794	0	KG	3	\N	\N	2078
9795	0	KG	3	\N	\N	2078
9796	0	KG	3	\N	\N	2078
9797	0	KG	3	\N	\N	2078
9798	0	KG	3	\N	\N	2079
9799	0	KG	3	\N	\N	2079
9800	0	KG	3	\N	\N	2079
9801	0	KG	3	\N	\N	2079
9802	0	KG	3	\N	\N	2079
9803	50	KG	3	\N	\N	2080
9804	50	KG	3	\N	\N	2080
9805	50	KG	3	\N	\N	2080
9806	50	KG	3	\N	\N	2080
9807	50	KG	3	\N	\N	2080
9808	20	KG	5	\N	\N	2081
9809	20	KG	5	\N	\N	2081
9810	20	KG	5	\N	\N	2081
9811	20	KG	5	\N	\N	2081
9812	20	KG	5	\N	\N	2081
9813	50	KG	3	\N	\N	2082
9814	50	KG	3	\N	\N	2082
9815	50	KG	3	\N	\N	2082
9816	50	KG	3	\N	\N	2082
9817	50	KG	3	\N	\N	2082
9818	0	KG	3	\N	\N	2083
9819	0	KG	3	\N	\N	2083
9820	0	KG	3	\N	\N	2083
9821	0	KG	3	\N	\N	2083
9822	0	KG	3	\N	\N	2083
11707	75	KG	5	75	8	2517
11708	75	KG	5	80	5	2517
11709	75	KG	5	80	5	2517
11710	20	KG	12	20	12	2518
11711	20	KG	12	20	12	2518
11712	20	KG	12	20	12	2518
11713	35	KG	10	35	12	2519
11714	35	KG	10	35	12	2519
11715	35	KG	10	35	12	2519
11716	0	KG	20	0	20	2520
11717	0	KG	20	0	20	2520
9838	50	KG	3	\N	\N	2087
9839	50	KG	3	\N	\N	2087
9840	50	KG	3	\N	\N	2087
9841	50	KG	3	\N	\N	2087
11718	0	KG	20	0	20	2520
11719	0	KG	20	0	20	2520
11720	0	KG	10	0	10	2521
11721	0	KG	10	0	10	2521
11722	0	KG	10	0	10	2521
11723	0	KG	10	0	10	2521
11724	75	KG	9	\N	\N	2522
11725	80	KG	6	\N	\N	2522
11726	80	KG	6	\N	\N	2522
11727	20	KG	13	\N	\N	2523
11728	20	KG	13	\N	\N	2523
11729	20	KG	13	\N	\N	2523
11730	35	KG	13	\N	\N	2524
11731	35	KG	13	\N	\N	2524
11732	35	KG	13	\N	\N	2524
11733	0	KG	8	\N	\N	2525
11734	0	KG	8	\N	\N	2525
9842	50	KG	3	\N	\N	2087
11735	0	KG	8	\N	\N	2525
11736	0	KG	8	\N	\N	2525
11737	0	KG	11	\N	\N	2526
11738	0	KG	11	\N	\N	2526
11739	0	KG	11	\N	\N	2526
11740	0	KG	11	\N	\N	2526
12529	50	KG	3	\N	\N	2693
12530	50	KG	3	\N	\N	2693
12531	50	KG	3	\N	\N	2693
12532	50	KG	3	\N	\N	2693
9853	50	KG	3	\N	\N	2090
9854	50	KG	3	\N	\N	2090
9855	50	KG	3	\N	\N	2090
9856	50	KG	3	\N	\N	2090
9857	50	KG	3	\N	\N	2090
9858	50	KG	3	\N	\N	2091
9859	50	KG	3	\N	\N	2091
9860	50	KG	3	\N	\N	2091
9861	50	KG	3	\N	\N	2091
9862	50	KG	3	\N	\N	2091
9863	50	KG	3	\N	\N	2092
9864	50	KG	3	\N	\N	2092
9865	50	KG	3	\N	\N	2092
9866	50	KG	3	\N	\N	2092
9867	50	KG	3	\N	\N	2092
9868	0	KG	3	\N	\N	2093
9869	0	KG	3	\N	\N	2093
9870	0	KG	3	\N	\N	2093
9871	0	KG	3	\N	\N	2093
9872	0	KG	3	\N	\N	2093
9873	0	KG	3	\N	\N	2094
9874	0	KG	3	\N	\N	2094
9875	0	KG	3	\N	\N	2094
9876	0	KG	3	\N	\N	2094
9877	0	KG	3	\N	\N	2094
9884	20	LB	5	20	5	2097
9885	20	LB	5	20	5	2097
9886	20	LB	5	20	5	2097
9887	20	LB	5	20	5	2098
9888	20	LB	5	20	5	2098
9889	20	LB	5	20	5	2098
9890	20.5	LB	15	\N	\N	2099
9891	20.5	LB	15	\N	\N	2099
9892	20.5	LB	15	\N	\N	2099
9893	20.5	LB	15	\N	\N	2100
9894	20.5	LB	15	\N	\N	2100
9895	20.5	LB	15	\N	\N	2100
12533	50	KG	3	\N	\N	2693
12534	50	KG	3	\N	\N	2694
12535	50	KG	3	\N	\N	2694
12536	50	KG	3	\N	\N	2694
12537	50	KG	3	\N	\N	2694
12538	50	KG	3	\N	\N	2694
12539	50	KG	3	\N	\N	2695
12540	50	KG	3	\N	\N	2695
12541	50	KG	3	\N	\N	2695
12542	50	KG	3	\N	\N	2695
9906	20	KG	5	\N	\N	2103
9907	20	KG	5	\N	\N	2103
9908	20	KG	5	\N	\N	2103
9909	20	KG	5	\N	\N	2103
9910	20	KG	5	\N	\N	2103
9911	0	KG	3	\N	\N	2104
9912	0	KG	3	\N	\N	2104
9913	0	KG	3	\N	\N	2104
9914	0	KG	3	\N	\N	2104
9915	0	KG	3	\N	\N	2104
9916	0	KG	3	\N	\N	2105
9917	0	KG	3	\N	\N	2105
9918	0	KG	3	\N	\N	2105
9919	0	KG	3	\N	\N	2105
9920	0	KG	3	\N	\N	2105
12543	50	KG	3	\N	\N	2695
12544	0	KG	8	\N	\N	2696
12545	0	KG	8	\N	\N	2696
12546	0	KG	8	\N	\N	2696
12547	0	KG	8	\N	\N	2696
12548	0	KG	8	\N	\N	2696
12549	0	KG	8	\N	\N	2697
12550	0	KG	8	\N	\N	2697
12551	0	KG	8	\N	\N	2697
12552	0	KG	8	\N	\N	2697
12553	0	KG	8	\N	\N	2697
12554	20	KG	5	\N	\N	2698
12555	20	KG	5	\N	\N	2698
12556	20	KG	5	\N	\N	2698
12557	20	KG	5	\N	\N	2698
9936	0	KG	3	\N	\N	2109
9937	0	KG	3	\N	\N	2109
9938	0	KG	3	\N	\N	2109
9939	0	KG	3	\N	\N	2109
9940	0	KG	3	\N	\N	2109
9941	0	KG	3	\N	\N	2110
9942	0	KG	3	\N	\N	2110
9943	0	KG	3	\N	\N	2110
9944	0	KG	3	\N	\N	2110
9945	0	KG	3	\N	\N	2110
12558	20	KG	5	\N	\N	2698
12559	20	KG	5	\N	\N	2699
12560	20	KG	5	\N	\N	2699
12561	20	KG	5	\N	\N	2699
12562	20	KG	5	\N	\N	2699
9951	50	KG	3	\N	\N	2112
9952	50	KG	3	\N	\N	2112
9953	50	KG	3	\N	\N	2112
9954	50	KG	3	\N	\N	2112
9955	50	KG	3	\N	\N	2112
9956	50	KG	3	\N	\N	2113
9957	50	KG	3	\N	\N	2113
9958	50	KG	3	\N	\N	2113
9959	50	KG	3	\N	\N	2113
9960	50	KG	3	\N	\N	2113
9961	0	KG	3	\N	\N	2114
9962	0	KG	3	\N	\N	2114
9963	0	KG	3	\N	\N	2114
9964	0	KG	3	\N	\N	2114
9965	0	KG	3	\N	\N	2114
9966	0	KG	3	\N	\N	2115
9967	0	KG	3	\N	\N	2115
9968	0	KG	3	\N	\N	2115
9969	0	KG	3	\N	\N	2115
9970	0	KG	3	\N	\N	2115
9971	50	KG	3	\N	\N	2116
9972	50	KG	3	\N	\N	2116
9973	50	KG	3	\N	\N	2116
9974	50	KG	3	\N	\N	2116
9975	50	KG	3	\N	\N	2116
12563	20	KG	5	\N	\N	2699
12564	50	KG	3	\N	\N	2700
12565	50	KG	3	\N	\N	2700
12566	50	KG	3	\N	\N	2700
12567	50	KG	3	\N	\N	2700
12568	50	KG	3	\N	\N	2700
12569	0	KG	8	\N	\N	2701
12570	0	KG	8	\N	\N	2701
12571	0	KG	8	\N	\N	2701
12572	0	KG	8	\N	\N	2701
9986	0	KG	3	\N	\N	2119
9987	0	KG	3	\N	\N	2119
9988	0	KG	3	\N	\N	2119
9989	0	KG	3	\N	\N	2119
9990	0	KG	3	\N	\N	2119
9991	0	KG	3	\N	\N	2120
9992	0	KG	3	\N	\N	2120
9993	0	KG	3	\N	\N	2120
9994	0	KG	3	\N	\N	2120
9995	0	KG	3	\N	\N	2120
9996	20	KG	5	\N	\N	2121
9997	20	KG	5	\N	\N	2121
9998	20	KG	5	\N	\N	2121
9999	20	KG	5	\N	\N	2121
10000	20	KG	5	\N	\N	2121
12573	0	KG	8	\N	\N	2701
12574	0	KG	8	\N	\N	2702
12575	0	KG	8	\N	\N	2702
12576	0	KG	8	\N	\N	2702
12577	0	KG	8	\N	\N	2702
12578	0	KG	8	\N	\N	2702
12579	50	KG	3	\N	\N	2703
12580	50	KG	3	\N	\N	2703
12581	50	KG	3	\N	\N	2703
12582	50	KG	3	\N	\N	2703
10011	0	KG	3	\N	\N	2124
10012	0	KG	3	\N	\N	2124
10013	0	KG	3	\N	\N	2124
10014	0	KG	3	\N	\N	2124
10015	0	KG	3	\N	\N	2124
10016	0	KG	3	\N	\N	2125
10017	0	KG	3	\N	\N	2125
10018	0	KG	3	\N	\N	2125
10019	0	KG	3	\N	\N	2125
10020	0	KG	3	\N	\N	2125
12583	50	KG	3	\N	\N	2703
12584	20	KG	5	\N	\N	2704
12585	20	KG	5	\N	\N	2704
12586	20	KG	5	\N	\N	2704
12587	20	KG	5	\N	\N	2704
10026	50	KG	3	\N	\N	2127
10027	50	KG	3	\N	\N	2127
10028	50	KG	3	\N	\N	2127
10029	50	KG	3	\N	\N	2127
10030	50	KG	3	\N	\N	2127
10031	50	KG	3	\N	\N	2128
10032	50	KG	3	\N	\N	2128
10033	50	KG	3	\N	\N	2128
10034	50	KG	3	\N	\N	2128
10035	50	KG	3	\N	\N	2128
10036	0	KG	3	\N	\N	2129
10037	0	KG	3	\N	\N	2129
10038	0	KG	3	\N	\N	2129
10039	0	KG	3	\N	\N	2129
10040	0	KG	3	\N	\N	2129
10041	0	KG	3	\N	\N	2130
10042	0	KG	3	\N	\N	2130
10043	0	KG	3	\N	\N	2130
10044	0	KG	3	\N	\N	2130
10045	0	KG	3	\N	\N	2130
10046	20	KG	5	\N	\N	2131
10047	20	KG	5	\N	\N	2131
10048	20	KG	5	\N	\N	2131
10049	20	KG	5	\N	\N	2131
10050	20	KG	5	\N	\N	2131
12588	20	KG	5	\N	\N	2704
12589	50	KG	3	\N	\N	2705
12590	50	KG	3	\N	\N	2705
12591	50	KG	3	\N	\N	2705
12592	50	KG	3	\N	\N	2705
12593	50	KG	3	\N	\N	2705
12594	0	KG	8	\N	\N	2706
12595	0	KG	8	\N	\N	2706
12596	0	KG	8	\N	\N	2706
12597	0	KG	8	\N	\N	2706
10061	0	KG	3	\N	\N	2134
10062	0	KG	3	\N	\N	2134
10063	0	KG	3	\N	\N	2134
10064	0	KG	3	\N	\N	2134
10065	0	KG	3	\N	\N	2134
10066	0	KG	3	\N	\N	2135
10067	0	KG	3	\N	\N	2135
10068	0	KG	3	\N	\N	2135
10069	0	KG	3	\N	\N	2135
10070	0	KG	3	\N	\N	2135
12598	0	KG	8	\N	\N	2706
12599	0	KG	8	\N	\N	2707
12600	0	KG	8	\N	\N	2707
12601	0	KG	8	\N	\N	2707
12602	0	KG	8	\N	\N	2707
12603	0	KG	8	\N	\N	2707
12763	20	KG	5	\N	\N	2739
12764	20	KG	5	\N	\N	2740
12765	20	KG	5	\N	\N	2740
12766	20	KG	5	\N	\N	2740
12767	20	KG	5	\N	\N	2740
12768	20	KG	5	\N	\N	2740
12769	0	KG	8	\N	\N	2741
12770	0	KG	8	\N	\N	2741
12771	0	KG	8	\N	\N	2741
12772	0	KG	8	\N	\N	2741
12773	0	KG	8	\N	\N	2741
12774	0	KG	8	\N	\N	2742
12775	0	KG	8	\N	\N	2742
12776	0	KG	8	\N	\N	2742
12777	0	KG	8	\N	\N	2742
12778	0	KG	8	\N	\N	2742
12779	50	KG	3	\N	\N	2743
12780	50	KG	3	\N	\N	2743
12781	50	KG	3	\N	\N	2743
12782	50	KG	3	\N	\N	2743
12783	50	KG	3	\N	\N	2743
12784	20	KG	5	\N	\N	2744
12785	20	KG	5	\N	\N	2744
12786	20	KG	5	\N	\N	2744
12787	20	KG	5	\N	\N	2744
12788	20	KG	5	\N	\N	2744
12789	50	KG	3	\N	\N	2745
12790	50	KG	3	\N	\N	2745
12791	50	KG	3	\N	\N	2745
12792	50	KG	3	\N	\N	2745
12793	50	KG	3	\N	\N	2745
12794	0	KG	8	\N	\N	2746
12795	0	KG	8	\N	\N	2746
12796	0	KG	8	\N	\N	2746
12797	0	KG	8	\N	\N	2746
12798	0	KG	8	\N	\N	2746
12799	0	KG	8	\N	\N	2747
12800	0	KG	8	\N	\N	2747
12801	0	KG	8	\N	\N	2747
12802	0	KG	8	\N	\N	2747
12803	0	KG	8	\N	\N	2747
12804	50	KG	3	\N	\N	2748
12604	20	KG	5	\N	\N	2708
12605	20	KG	5	\N	\N	2708
12606	20	KG	5	\N	\N	2708
12607	20	KG	5	\N	\N	2708
12608	20	KG	5	\N	\N	2708
12609	50	KG	3	\N	\N	2709
12610	50	KG	3	\N	\N	2709
12611	50	KG	3	\N	\N	2709
12612	50	KG	3	\N	\N	2709
12613	50	KG	3	\N	\N	2709
12614	50	KG	3	\N	\N	2710
12615	50	KG	3	\N	\N	2710
12616	50	KG	3	\N	\N	2710
12617	50	KG	3	\N	\N	2710
12618	50	KG	3	\N	\N	2710
10449	50	KG	3	\N	\N	2232
10450	50	KG	3	\N	\N	2232
10451	50	KG	3	\N	\N	2232
10452	50	KG	3	\N	\N	2232
10453	50	KG	3	\N	\N	2232
12619	0	KG	8	\N	\N	2711
12620	0	KG	8	\N	\N	2711
12621	0	KG	8	\N	\N	2711
12622	0	KG	8	\N	\N	2711
12623	0	KG	8	\N	\N	2711
10459	0	KG	8	\N	\N	2234
10460	0	KG	8	\N	\N	2234
10461	0	KG	8	\N	\N	2234
10462	0	KG	8	\N	\N	2234
10463	0	KG	8	\N	\N	2234
10464	0	KG	8	\N	\N	2235
10465	0	KG	8	\N	\N	2235
10466	0	KG	8	\N	\N	2235
10467	0	KG	8	\N	\N	2235
10468	0	KG	8	\N	\N	2235
10469	50	KG	3	\N	\N	2236
10470	50	KG	3	\N	\N	2236
10471	50	KG	3	\N	\N	2236
10472	50	KG	3	\N	\N	2236
10473	50	KG	3	\N	\N	2236
10474	20	KG	5	\N	\N	2237
10475	20	KG	5	\N	\N	2237
10476	20	KG	5	\N	\N	2237
10477	20	KG	5	\N	\N	2237
10478	20	KG	5	\N	\N	2237
10479	50	KG	3	\N	\N	2238
10480	50	KG	3	\N	\N	2238
10481	50	KG	3	\N	\N	2238
10482	50	KG	3	\N	\N	2238
10483	50	KG	3	\N	\N	2238
10484	0	KG	8	\N	\N	2239
10485	0	KG	8	\N	\N	2239
10486	0	KG	8	\N	\N	2239
10487	0	KG	8	\N	\N	2239
10488	0	KG	8	\N	\N	2239
10489	0	KG	8	\N	\N	2240
10490	0	KG	8	\N	\N	2240
10491	0	KG	8	\N	\N	2240
10492	0	KG	8	\N	\N	2240
10493	0	KG	8	\N	\N	2240
12624	0	KG	8	\N	\N	2712
12625	0	KG	8	\N	\N	2712
12626	0	KG	8	\N	\N	2712
12627	0	KG	8	\N	\N	2712
12628	0	KG	8	\N	\N	2712
10499	20	KG	5	\N	\N	2242
10500	20	KG	5	\N	\N	2242
10501	20	KG	5	\N	\N	2242
12629	50	KG	3	\N	\N	2713
12630	50	KG	3	\N	\N	2713
12631	50	KG	3	\N	\N	2713
12632	50	KG	3	\N	\N	2713
12633	50	KG	3	\N	\N	2713
12634	20	KG	5	\N	\N	2714
12635	20	KG	5	\N	\N	2714
12636	20	KG	5	\N	\N	2714
12637	20	KG	5	\N	\N	2714
12638	20	KG	5	\N	\N	2714
12639	20	KG	5	\N	\N	2715
12640	20	KG	5	\N	\N	2715
12641	20	KG	5	\N	\N	2715
12642	20	KG	5	\N	\N	2715
12643	20	KG	5	\N	\N	2715
12644	0	KG	8	\N	\N	2716
12645	0	KG	8	\N	\N	2716
12646	0	KG	8	\N	\N	2716
12647	0	KG	8	\N	\N	2716
12648	0	KG	8	\N	\N	2716
12649	0	KG	8	\N	\N	2717
12650	0	KG	8	\N	\N	2717
12651	0	KG	8	\N	\N	2717
12652	0	KG	8	\N	\N	2717
12653	0	KG	8	\N	\N	2717
12654	50	KG	3	\N	\N	2718
12655	50	KG	3	\N	\N	2718
12656	50	KG	3	\N	\N	2718
12657	50	KG	3	\N	\N	2718
12658	50	KG	3	\N	\N	2718
12659	50	KG	3	\N	\N	2719
12660	50	KG	3	\N	\N	2719
12661	50	KG	3	\N	\N	2719
10502	20	KG	5	\N	\N	2242
10503	20	KG	5	\N	\N	2242
10504	50	KG	3	\N	\N	2243
10505	50	KG	3	\N	\N	2243
10506	50	KG	3	\N	\N	2243
10507	50	KG	3	\N	\N	2243
10508	50	KG	3	\N	\N	2243
10509	0	KG	8	\N	\N	2244
10510	0	KG	8	\N	\N	2244
10511	0	KG	8	\N	\N	2244
10512	0	KG	8	\N	\N	2244
10513	0	KG	8	\N	\N	2244
12662	50	KG	3	\N	\N	2719
12663	50	KG	3	\N	\N	2719
12664	50	KG	3	\N	\N	2720
12665	50	KG	3	\N	\N	2720
12666	50	KG	3	\N	\N	2720
10519	20	KG	5	\N	\N	2246
10520	20	KG	5	\N	\N	2246
10521	20	KG	5	\N	\N	2246
10522	20	KG	5	\N	\N	2246
10523	20	KG	5	\N	\N	2246
10524	50	KG	3	\N	\N	2247
10525	50	KG	3	\N	\N	2247
10526	50	KG	3	\N	\N	2247
10527	50	KG	3	\N	\N	2247
10528	50	KG	3	\N	\N	2247
10529	50	KG	3	\N	\N	2248
10530	50	KG	3	\N	\N	2248
10531	50	KG	3	\N	\N	2248
10532	50	KG	3	\N	\N	2248
10533	50	KG	3	\N	\N	2248
12667	50	KG	3	\N	\N	2720
12668	50	KG	3	\N	\N	2720
12669	0	KG	8	\N	\N	2721
10774	50	KG	3	\N	\N	2297
10775	50	KG	3	\N	\N	2297
10776	50	KG	3	\N	\N	2297
10777	50	KG	3	\N	\N	2297
10778	50	KG	3	\N	\N	2297
10779	50	KG	3	\N	\N	2298
10780	50	KG	3	\N	\N	2298
10781	50	KG	3	\N	\N	2298
10782	50	KG	3	\N	\N	2298
10783	50	KG	3	\N	\N	2298
10784	50	KG	3	\N	\N	2299
10785	50	KG	3	\N	\N	2299
10786	50	KG	3	\N	\N	2299
10787	50	KG	3	\N	\N	2299
10788	50	KG	3	\N	\N	2299
10789	0	KG	8	\N	\N	2300
10790	0	KG	8	\N	\N	2300
10791	0	KG	8	\N	\N	2300
10792	0	KG	8	\N	\N	2300
10793	0	KG	8	\N	\N	2300
10799	50	KG	3	\N	\N	2302
10800	50	KG	3	\N	\N	2302
10801	50	KG	3	\N	\N	2302
10802	50	KG	3	\N	\N	2302
10803	50	KG	3	\N	\N	2302
10804	50	KG	3	\N	\N	2303
10805	50	KG	3	\N	\N	2303
10806	50	KG	3	\N	\N	2303
10807	50	KG	3	\N	\N	2303
10808	50	KG	3	\N	\N	2303
10809	50	KG	3	\N	\N	2304
10810	50	KG	3	\N	\N	2304
10811	50	KG	3	\N	\N	2304
10812	50	KG	3	\N	\N	2304
10813	50	KG	3	\N	\N	2304
10819	0	KG	8	\N	\N	2306
10820	0	KG	8	\N	\N	2306
10821	0	KG	8	\N	\N	2306
10822	0	KG	8	\N	\N	2306
10823	0	KG	8	\N	\N	2306
10824	20	KG	5	\N	\N	2307
10825	20	KG	5	\N	\N	2307
10826	20	KG	5	\N	\N	2307
10827	20	KG	5	\N	\N	2307
10828	20	KG	5	\N	\N	2307
10839	0	KG	8	\N	\N	2310
10840	0	KG	8	\N	\N	2310
10841	0	KG	8	\N	\N	2310
10842	0	KG	8	\N	\N	2310
10843	0	KG	8	\N	\N	2310
10844	0	KG	8	\N	\N	2311
10845	0	KG	8	\N	\N	2311
10846	0	KG	8	\N	\N	2311
10847	0	KG	8	\N	\N	2311
10848	0	KG	8	\N	\N	2311
10849	50	KG	3	\N	\N	2312
10850	50	KG	3	\N	\N	2312
10851	50	KG	3	\N	\N	2312
10852	50	KG	3	\N	\N	2312
10853	50	KG	3	\N	\N	2312
10859	50	KG	3	\N	\N	2314
10860	50	KG	3	\N	\N	2314
10861	50	KG	3	\N	\N	2314
10862	50	KG	3	\N	\N	2314
10863	50	KG	3	\N	\N	2314
10869	0	KG	8	\N	\N	2316
10870	0	KG	8	\N	\N	2316
10871	0	KG	8	\N	\N	2316
10872	0	KG	8	\N	\N	2316
10873	0	KG	8	\N	\N	2316
12841	50	KG	3	\N	\N	2755
12842	50	KG	3	\N	\N	2755
12843	50	KG	3	\N	\N	2755
12844	0	KG	8	\N	\N	2756
12845	0	KG	8	\N	\N	2756
12846	0	KG	8	\N	\N	2756
12847	0	KG	8	\N	\N	2756
12848	0	KG	8	\N	\N	2756
12849	0	KG	8	\N	\N	2757
12850	0	KG	8	\N	\N	2757
12851	0	KG	8	\N	\N	2757
12852	0	KG	8	\N	\N	2757
12853	0	KG	8	\N	\N	2757
12854	50	KG	3	\N	\N	2758
12855	50	KG	3	\N	\N	2758
12856	50	KG	3	\N	\N	2758
12857	50	KG	3	\N	\N	2758
12858	50	KG	3	\N	\N	2758
12859	50	KG	3	\N	\N	2759
12860	50	KG	3	\N	\N	2759
12861	50	KG	3	\N	\N	2759
12862	50	KG	3	\N	\N	2759
12863	50	KG	3	\N	\N	2759
12864	20	KG	5	\N	\N	2760
12865	20	KG	5	\N	\N	2760
12866	20	KG	5	\N	\N	2760
12867	20	KG	5	\N	\N	2760
12868	20	KG	5	\N	\N	2760
12869	0	KG	8	\N	\N	2761
12870	0	KG	8	\N	\N	2761
12871	0	KG	8	\N	\N	2761
12872	0	KG	8	\N	\N	2761
12873	0	KG	8	\N	\N	2761
12874	0	KG	8	\N	\N	2762
12875	0	KG	8	\N	\N	2762
12876	0	KG	8	\N	\N	2762
12877	0	KG	8	\N	\N	2762
12878	0	KG	8	\N	\N	2762
16808	0	KG	0	\N	\N	3687
16809	0	KG	0	\N	\N	3687
16810	0	KG	0	\N	\N	3687
16811	0	KG	0	\N	\N	3687
16812	0	KG	0	\N	\N	3689
16813	0	KG	0	\N	\N	3689
16814	0	KG	0	\N	\N	3689
16815	0	KG	0	\N	\N	3689
16816	0	KG	0	\N	\N	3689
16817	0	KG	0	\N	\N	3690
16818	0	KG	0	\N	\N	3690
16819	0	KG	0	\N	\N	3690
16820	0	KG	0	\N	\N	3690
16821	0	KG	0	\N	\N	3690
16822	0	KG	0	\N	\N	3691
16823	0	KG	0	\N	\N	3691
16824	0	KG	0	\N	\N	3691
16825	0	KG	0	\N	\N	3691
16826	0	KG	0	\N	\N	3691
18447	0	KG	0	17	2	4120
18448	0	KG	0	17	2	4120
18449	0	KG	0	17	2	4120
18450	0	KG	0	17	2	4120
18451	0	KG	0	17	2	4120
12904	20	KG	5	\N	\N	2768
12905	20	KG	5	\N	\N	2768
12906	20	KG	5	\N	\N	2768
12907	20	KG	5	\N	\N	2768
12908	20	KG	5	\N	\N	2768
12909	20	KG	5	\N	\N	2769
12910	20	KG	5	\N	\N	2769
12911	20	KG	5	\N	\N	2769
12912	20	KG	5	\N	\N	2769
12913	20	KG	5	\N	\N	2769
12914	50	KG	3	\N	\N	2770
12915	50	KG	3	\N	\N	2770
12916	50	KG	3	\N	\N	2770
12917	50	KG	3	\N	\N	2770
12918	50	KG	3	\N	\N	2770
12919	0	KG	8	\N	\N	2771
12920	0	KG	8	\N	\N	2771
12921	0	KG	8	\N	\N	2771
12922	0	KG	8	\N	\N	2771
12923	0	KG	8	\N	\N	2771
12924	0	KG	8	\N	\N	2772
12925	0	KG	8	\N	\N	2772
12926	0	KG	8	\N	\N	2772
12927	0	KG	8	\N	\N	2772
12928	0	KG	8	\N	\N	2772
12929	50	KG	3	\N	\N	2773
12930	50	KG	3	\N	\N	2773
12931	50	KG	3	\N	\N	2773
12932	50	KG	3	\N	\N	2773
12933	50	KG	3	\N	\N	2773
12934	20	KG	5	\N	\N	2774
12935	20	KG	5	\N	\N	2774
12936	20	KG	5	\N	\N	2774
12937	20	KG	5	\N	\N	2774
12938	20	KG	5	\N	\N	2774
12939	50	KG	3	\N	\N	2775
12940	50	KG	3	\N	\N	2775
12941	50	KG	3	\N	\N	2775
12942	50	KG	3	\N	\N	2775
12943	50	KG	3	\N	\N	2775
12944	0	KG	8	\N	\N	2776
12945	0	KG	8	\N	\N	2776
12946	0	KG	8	\N	\N	2776
12947	0	KG	8	\N	\N	2776
12948	0	KG	8	\N	\N	2776
12949	0	KG	8	\N	\N	2777
12950	0	KG	8	\N	\N	2777
12951	0	KG	8	\N	\N	2777
12952	0	KG	8	\N	\N	2777
12953	0	KG	8	\N	\N	2777
12954	20	KG	5	\N	\N	2778
12955	20	KG	5	\N	\N	2778
12956	20	KG	5	\N	\N	2778
12957	20	KG	5	\N	\N	2778
12958	20	KG	5	\N	\N	2778
12959	50	KG	3	\N	\N	2779
12960	50	KG	3	\N	\N	2779
12961	50	KG	3	\N	\N	2779
12962	50	KG	3	\N	\N	2779
12963	50	KG	3	\N	\N	2779
12964	50	KG	3	\N	\N	2780
12965	50	KG	3	\N	\N	2780
12966	50	KG	3	\N	\N	2780
12967	50	KG	3	\N	\N	2780
12968	50	KG	3	\N	\N	2780
12969	0	KG	8	\N	\N	2781
12970	0	KG	8	\N	\N	2781
12971	0	KG	8	\N	\N	2781
12972	0	KG	8	\N	\N	2781
12973	0	KG	8	\N	\N	2781
12974	0	KG	8	\N	\N	2782
12975	0	KG	8	\N	\N	2782
12976	0	KG	8	\N	\N	2782
12977	0	KG	8	\N	\N	2782
12978	0	KG	8	\N	\N	2782
12979	20	KG	5	\N	\N	2783
12980	20	KG	5	\N	\N	2783
12981	20	KG	5	\N	\N	2783
12982	20	KG	5	\N	\N	2783
12983	20	KG	5	\N	\N	2783
12984	20	KG	5	\N	\N	2784
12985	20	KG	5	\N	\N	2784
12986	20	KG	5	\N	\N	2784
12987	20	KG	5	\N	\N	2784
12988	20	KG	5	\N	\N	2784
12989	20	KG	5	\N	\N	2785
12990	20	KG	5	\N	\N	2785
12991	20	KG	5	\N	\N	2785
12992	20	KG	5	\N	\N	2785
12993	20	KG	5	\N	\N	2785
12994	0	KG	8	\N	\N	2786
12995	0	KG	8	\N	\N	2786
12996	0	KG	8	\N	\N	2786
12997	0	KG	8	\N	\N	2786
12998	0	KG	8	\N	\N	2786
12999	0	KG	8	\N	\N	2787
13000	0	KG	8	\N	\N	2787
13001	0	KG	8	\N	\N	2787
13002	0	KG	8	\N	\N	2787
13003	0	KG	8	\N	\N	2787
13004	50	KG	3	\N	\N	2788
13005	50	KG	3	\N	\N	2788
13006	50	KG	3	\N	\N	2788
13007	50	KG	3	\N	\N	2788
13008	50	KG	3	\N	\N	2788
13009	50	KG	3	\N	\N	2789
13010	50	KG	3	\N	\N	2789
13011	50	KG	3	\N	\N	2789
13012	50	KG	3	\N	\N	2789
13013	50	KG	3	\N	\N	2789
13014	50	KG	3	\N	\N	2790
13015	50	KG	3	\N	\N	2790
13016	50	KG	3	\N	\N	2790
13017	50	KG	3	\N	\N	2790
13018	50	KG	3	\N	\N	2790
13019	0	KG	8	\N	\N	2791
13020	0	KG	8	\N	\N	2791
13021	0	KG	8	\N	\N	2791
13022	0	KG	8	\N	\N	2791
13023	0	KG	8	\N	\N	2791
13024	0	KG	8	\N	\N	2792
13025	0	KG	8	\N	\N	2792
13026	0	KG	8	\N	\N	2792
13027	0	KG	8	\N	\N	2792
13028	0	KG	8	\N	\N	2792
13029	20	KG	5	\N	\N	2793
13030	20	KG	5	\N	\N	2793
13031	20	KG	5	\N	\N	2793
13032	20	KG	5	\N	\N	2793
13033	20	KG	5	\N	\N	2793
13034	50	KG	3	\N	\N	2794
13035	50	KG	3	\N	\N	2794
13036	50	KG	3	\N	\N	2794
13037	50	KG	3	\N	\N	2794
13038	50	KG	3	\N	\N	2794
13039	50	KG	3	\N	\N	2795
13040	50	KG	3	\N	\N	2795
13041	50	KG	3	\N	\N	2795
13042	50	KG	3	\N	\N	2795
13043	50	KG	3	\N	\N	2795
13044	0	KG	8	\N	\N	2796
13045	0	KG	8	\N	\N	2796
13046	0	KG	8	\N	\N	2796
13047	0	KG	8	\N	\N	2796
13048	0	KG	8	\N	\N	2796
13049	0	KG	8	\N	\N	2797
13050	0	KG	8	\N	\N	2797
13051	0	KG	8	\N	\N	2797
13052	0	KG	8	\N	\N	2797
13053	0	KG	8	\N	\N	2797
13054	20	KG	5	\N	\N	2798
13055	20	KG	5	\N	\N	2798
13056	20	KG	5	\N	\N	2798
13057	20	KG	5	\N	\N	2798
13058	20	KG	5	\N	\N	2798
13059	20	KG	5	\N	\N	2799
13060	20	KG	5	\N	\N	2799
13061	20	KG	5	\N	\N	2799
13062	20	KG	5	\N	\N	2799
13063	20	KG	5	\N	\N	2799
13064	50	KG	3	\N	\N	2800
13065	50	KG	3	\N	\N	2800
13066	50	KG	3	\N	\N	2800
13067	50	KG	3	\N	\N	2800
13068	50	KG	3	\N	\N	2800
13069	0	KG	8	\N	\N	2801
13070	0	KG	8	\N	\N	2801
13071	0	KG	8	\N	\N	2801
13072	0	KG	8	\N	\N	2801
13073	0	KG	8	\N	\N	2801
13074	0	KG	8	\N	\N	2802
13075	0	KG	8	\N	\N	2802
13076	0	KG	8	\N	\N	2802
13077	0	KG	8	\N	\N	2802
13078	0	KG	8	\N	\N	2802
13079	50	KG	3	\N	\N	2803
13080	50	KG	3	\N	\N	2803
13081	50	KG	3	\N	\N	2803
13082	50	KG	3	\N	\N	2803
13083	50	KG	3	\N	\N	2803
13084	50	KG	3	\N	\N	2804
13085	50	KG	3	\N	\N	2804
13086	50	KG	3	\N	\N	2804
13087	50	KG	3	\N	\N	2804
13088	50	KG	3	\N	\N	2804
13089	50	KG	3	\N	\N	2805
13090	50	KG	3	\N	\N	2805
13091	50	KG	3	\N	\N	2805
13092	50	KG	3	\N	\N	2805
13093	50	KG	3	\N	\N	2805
13094	0	KG	8	\N	\N	2806
13095	0	KG	8	\N	\N	2806
13096	0	KG	8	\N	\N	2806
13097	0	KG	8	\N	\N	2806
13098	0	KG	8	\N	\N	2806
13099	0	KG	8	\N	\N	2807
13100	0	KG	8	\N	\N	2807
13101	0	KG	8	\N	\N	2807
13102	0	KG	8	\N	\N	2807
13103	0	KG	8	\N	\N	2807
13106	20	KG	5	\N	\N	2810
13107	20	KG	5	\N	\N	2810
13108	20	KG	5	\N	\N	2810
13109	20	KG	5	\N	\N	2810
13110	20	KG	5	\N	\N	2810
13111	50	KG	3	\N	\N	2811
13112	50	KG	3	\N	\N	2811
13113	50	KG	3	\N	\N	2811
13114	50	KG	3	\N	\N	2811
13115	50	KG	3	\N	\N	2811
13116	50	KG	3	\N	\N	2812
13117	50	KG	3	\N	\N	2812
13118	50	KG	3	\N	\N	2812
13119	50	KG	3	\N	\N	2812
13120	50	KG	3	\N	\N	2812
13121	0	KG	8	\N	\N	2813
13122	0	KG	8	\N	\N	2813
13123	0	KG	8	\N	\N	2813
13124	0	KG	8	\N	\N	2813
13125	0	KG	8	\N	\N	2813
13126	0	KG	8	\N	\N	2814
13127	0	KG	8	\N	\N	2814
13128	0	KG	8	\N	\N	2814
13129	0	KG	8	\N	\N	2814
13130	0	KG	8	\N	\N	2814
13131	50	KG	3	\N	\N	2815
13132	50	KG	3	\N	\N	2815
13133	50	KG	3	\N	\N	2815
13134	50	KG	3	\N	\N	2815
13135	50	KG	3	\N	\N	2815
13136	20	KG	5	\N	\N	2816
13137	20	KG	5	\N	\N	2816
13138	20	KG	5	\N	\N	2816
13139	20	KG	5	\N	\N	2816
13140	20	KG	5	\N	\N	2816
13141	50	KG	3	\N	\N	2817
13142	50	KG	3	\N	\N	2817
13143	50	KG	3	\N	\N	2817
13144	50	KG	3	\N	\N	2817
13145	50	KG	3	\N	\N	2817
13146	0	KG	8	\N	\N	2818
13147	0	KG	8	\N	\N	2818
13148	0	KG	8	\N	\N	2818
13149	0	KG	8	\N	\N	2818
13150	0	KG	8	\N	\N	2818
13151	0	KG	8	\N	\N	2819
13152	0	KG	8	\N	\N	2819
13153	0	KG	8	\N	\N	2819
13154	0	KG	8	\N	\N	2819
13155	0	KG	8	\N	\N	2819
13156	50	KG	3	\N	\N	2820
13157	50	KG	3	\N	\N	2820
13158	50	KG	3	\N	\N	2820
13159	50	KG	3	\N	\N	2820
13160	50	KG	3	\N	\N	2820
13161	50	KG	3	\N	\N	2821
13162	50	KG	3	\N	\N	2821
13163	50	KG	3	\N	\N	2821
13164	50	KG	3	\N	\N	2821
13165	50	KG	3	\N	\N	2821
13166	50	KG	3	\N	\N	2822
13167	50	KG	3	\N	\N	2822
13168	50	KG	3	\N	\N	2822
13169	50	KG	3	\N	\N	2822
13170	50	KG	3	\N	\N	2822
13171	0	KG	8	\N	\N	2823
13172	0	KG	8	\N	\N	2823
13173	0	KG	8	\N	\N	2823
13174	0	KG	8	\N	\N	2823
13175	0	KG	8	\N	\N	2823
13176	0	KG	8	\N	\N	2824
13177	0	KG	8	\N	\N	2824
13178	0	KG	8	\N	\N	2824
13179	0	KG	8	\N	\N	2824
13180	0	KG	8	\N	\N	2824
13181	95	LB	8	\N	\N	2825
13182	115	LB	8	\N	\N	2825
13183	135	LB	6	\N	\N	2825
13184	135	LB	6	\N	\N	2825
13185	46	KG	10	46	10	2826
13186	46	KG	10	46	10	2826
13187	46	KG	10	46	6	2826
13188	0	KG	16	0	16	2827
13189	0	KG	13	0	10	2827
13190	0	KG	11	0	14	2827
13191	27.5	KG	9	30	8	2828
13192	27.5	KG	9	30	8	2828
13193	27.5	KG	9	30	8	2828
13194	28	KG	9	25	8	2829
13195	28	KG	9	25	8	2829
13196	28	KG	9	25	8	2829
13197	23.5	KG	9	23.5	8	2830
13198	23.5	KG	9	23.5	8	2830
13199	23.5	KG	9	20	8	2830
13200	42.5	KG	10	42.5	10	2831
13201	42.5	KG	10	42.5	10	2831
13202	42.5	KG	10	42.5	10	2831
18452	0	KG	0	18	3	4121
18453	0	KG	0	18	3	4121
18454	0	KG	0	18	3	4121
18455	0	KG	0	18	3	4121
18456	0	KG	0	18	3	4121
18457	0	KG	0	16	3	4122
18458	0	KG	0	16	3	4122
18459	0	KG	0	16	3	4122
18460	0	KG	0	16	3	4122
18461	0	KG	0	16	3	4122
18462	0	KG	0	0	15	4123
18463	0	KG	0	0	15	4123
18464	0	KG	0	0	15	4123
18465	0	KG	0	0	15	4123
14148	50	KG	3	\N	\N	3058
14149	50	KG	3	\N	\N	3058
14150	50	KG	3	\N	\N	3058
14151	50	KG	3	\N	\N	3058
14152	50	KG	3	\N	\N	3058
14153	20	KG	5	\N	\N	3059
14154	20	KG	5	\N	\N	3059
14155	20	KG	5	\N	\N	3059
14156	20	KG	5	\N	\N	3059
14157	20	KG	5	\N	\N	3059
14158	50	KG	3	\N	\N	3060
14159	50	KG	3	\N	\N	3060
13240	0	KG	10	0	20	2844
13241	0	KG	10	0	16	2844
13242	0	KG	10	0	10	2844
13243	0	KG	10	0	10	2844
13244	0	KG	20	0	20	2845
13245	0	KG	20	0	20	2845
13246	0	KG	20	\N	\N	2845
18466	0	KG	0	0	15	4123
18467	0	KG	0	0	14	4124
18468	0	KG	0	0	14	4124
18469	0	KG	0	0	14	4124
18470	0	KG	0	0	14	4124
18471	0	KG	0	0	14	4124
18472	17	KG	3	\N	\N	4125
13247	0	KG	20	\N	\N	2845
13248	10	KG	12	5	12	2846
13249	10	KG	12	7.5	12	2846
13250	10	KG	12	7.5	12	2846
13251	10	KG	12	\N	\N	2847
13252	10	KG	12	\N	\N	2847
13253	10	KG	12	\N	\N	2847
13254	10	KG	12	\N	\N	2848
13255	10	KG	12	\N	\N	2848
13256	10	KG	12	\N	\N	2848
13257	10	KG	10	\N	\N	2849
13258	10	KG	10	\N	\N	2849
13259	10	KG	10	\N	\N	2849
13260	0	KG	8	\N	\N	2850
13261	0	KG	17	\N	\N	2850
13262	0	KG	11	\N	\N	2850
13263	0	KG	11	\N	\N	2850
13264	0	KG	8	\N	\N	2851
13265	0	KG	8	\N	\N	2851
13266	0	KG	20	\N	\N	2851
13267	0	KG	20	\N	\N	2851
13268	10	KG	12	\N	\N	2852
13269	10	KG	12	\N	\N	2852
13270	10	KG	12	\N	\N	2852
13271	10	KG	12	\N	\N	2853
13272	10	KG	12	\N	\N	2853
13273	10	KG	12	\N	\N	2853
13274	10	KG	12	\N	\N	2854
13275	10	KG	12	\N	\N	2854
13276	10	KG	12	\N	\N	2854
13277	10	KG	10	\N	\N	2855
13278	10	KG	10	\N	\N	2855
13279	10	KG	10	\N	\N	2855
13280	50	KG	3	\N	\N	2856
13281	50	KG	3	\N	\N	2856
13282	50	KG	3	\N	\N	2856
13283	50	KG	3	\N	\N	2856
13284	50	KG	3	\N	\N	2856
13285	50	KG	3	\N	\N	2857
13286	50	KG	3	\N	\N	2857
13287	50	KG	3	\N	\N	2857
13288	50	KG	3	\N	\N	2857
13289	50	KG	3	\N	\N	2857
13290	50	KG	3	\N	\N	2858
13291	50	KG	3	\N	\N	2858
13292	50	KG	3	\N	\N	2858
13293	50	KG	3	\N	\N	2858
13294	50	KG	3	\N	\N	2858
13295	0	KG	8	\N	\N	2859
13296	0	KG	8	\N	\N	2859
13297	0	KG	8	\N	\N	2859
13298	0	KG	8	\N	\N	2859
13299	0	KG	8	\N	\N	2859
13300	0	KG	8	\N	\N	2860
13301	0	KG	8	\N	\N	2860
13302	0	KG	8	\N	\N	2860
13303	0	KG	8	\N	\N	2860
13304	0	KG	8	\N	\N	2860
13305	50	KG	3	\N	\N	2861
13306	50	KG	3	\N	\N	2861
13307	50	KG	3	\N	\N	2861
13308	50	KG	3	\N	\N	2861
13309	50	KG	3	\N	\N	2861
13310	20	KG	5	\N	\N	2862
13311	20	KG	5	\N	\N	2862
13312	20	KG	5	\N	\N	2862
13313	20	KG	5	\N	\N	2862
13314	20	KG	5	\N	\N	2862
13315	20	KG	5	\N	\N	2863
13316	20	KG	5	\N	\N	2863
13317	20	KG	5	\N	\N	2863
13318	20	KG	5	\N	\N	2863
13319	20	KG	5	\N	\N	2863
13320	0	KG	8	\N	\N	2864
13321	0	KG	8	\N	\N	2864
13322	0	KG	8	\N	\N	2864
13323	0	KG	8	\N	\N	2864
13324	0	KG	8	\N	\N	2864
13325	0	KG	8	\N	\N	2865
13326	0	KG	8	\N	\N	2865
13327	0	KG	8	\N	\N	2865
13328	0	KG	8	\N	\N	2865
13329	0	KG	8	\N	\N	2865
13330	50	KG	3	\N	\N	2866
13331	50	KG	3	\N	\N	2866
13332	50	KG	3	\N	\N	2866
13333	50	KG	3	\N	\N	2866
13334	50	KG	3	\N	\N	2866
13335	50	KG	3	\N	\N	2867
13336	50	KG	3	\N	\N	2867
13337	50	KG	3	\N	\N	2867
13338	50	KG	3	\N	\N	2867
13339	50	KG	3	\N	\N	2867
13340	50	KG	3	\N	\N	2868
13341	50	KG	3	\N	\N	2868
13342	50	KG	3	\N	\N	2868
13343	50	KG	3	\N	\N	2868
13344	50	KG	3	\N	\N	2868
13345	0	KG	8	\N	\N	2869
13346	0	KG	8	\N	\N	2869
13347	0	KG	8	\N	\N	2869
13348	0	KG	8	\N	\N	2869
13349	0	KG	8	\N	\N	2869
13350	0	KG	8	\N	\N	2870
13351	0	KG	8	\N	\N	2870
13352	0	KG	8	\N	\N	2870
13353	0	KG	8	\N	\N	2870
13354	0	KG	8	\N	\N	2870
13355	50	KG	3	\N	\N	2871
13356	50	KG	3	\N	\N	2871
13357	50	KG	3	\N	\N	2871
13358	50	KG	3	\N	\N	2871
13359	50	KG	3	\N	\N	2871
13360	20	KG	5	\N	\N	2872
13361	20	KG	5	\N	\N	2872
13362	20	KG	5	\N	\N	2872
13363	20	KG	5	\N	\N	2872
13364	20	KG	5	\N	\N	2872
13365	50	KG	3	\N	\N	2873
13366	50	KG	3	\N	\N	2873
13367	50	KG	3	\N	\N	2873
13368	50	KG	3	\N	\N	2873
13369	50	KG	3	\N	\N	2873
13370	0	KG	8	\N	\N	2874
13371	0	KG	8	\N	\N	2874
13372	0	KG	8	\N	\N	2874
13373	0	KG	8	\N	\N	2874
13374	0	KG	8	\N	\N	2874
13375	0	KG	8	\N	\N	2875
13376	0	KG	8	\N	\N	2875
13377	0	KG	8	\N	\N	2875
13378	0	KG	8	\N	\N	2875
13379	0	KG	8	\N	\N	2875
13380	50	KG	3	\N	\N	2876
13381	50	KG	3	\N	\N	2876
13382	50	KG	3	\N	\N	2876
13383	50	KG	3	\N	\N	2876
13384	50	KG	3	\N	\N	2876
13385	50	KG	3	\N	\N	2877
13386	50	KG	3	\N	\N	2877
13387	50	KG	3	\N	\N	2877
13388	50	KG	3	\N	\N	2877
13389	50	KG	3	\N	\N	2877
13390	20	KG	5	\N	\N	2878
13391	20	KG	5	\N	\N	2878
13392	20	KG	5	\N	\N	2878
13393	20	KG	5	\N	\N	2878
13394	20	KG	5	\N	\N	2878
13395	0	KG	8	\N	\N	2879
13396	0	KG	8	\N	\N	2879
13397	0	KG	8	\N	\N	2879
13398	0	KG	8	\N	\N	2879
13399	0	KG	8	\N	\N	2879
13400	0	KG	8	\N	\N	2880
13401	0	KG	8	\N	\N	2880
13402	0	KG	8	\N	\N	2880
13403	0	KG	8	\N	\N	2880
13404	0	KG	8	\N	\N	2880
18473	17	KG	3	\N	\N	4125
18474	17	KG	3	\N	\N	4125
18475	17	KG	3	\N	\N	4125
18476	17	KG	3	\N	\N	4125
18477	19.25	KG	3	\N	\N	4126
18478	19.25	KG	3	\N	\N	4126
18479	19.25	KG	3	\N	\N	4126
18480	19.25	KG	3	\N	\N	4126
18481	19.25	KG	3	\N	\N	4126
18482	17.25	KG	3	\N	\N	4127
18483	17.25	KG	3	\N	\N	4127
18484	17.25	KG	3	\N	\N	4127
18485	17.25	KG	3	\N	\N	4127
18486	17.25	KG	3	\N	\N	4127
18487	0	KG	16	\N	\N	4128
18488	0	KG	16	\N	\N	4128
18489	0	KG	16	\N	\N	4128
18490	0	KG	16	\N	\N	4128
13430	90	KG	5	90	5	2886
13431	90	KG	5	90	5	2886
13432	90	KG	5	90	5	2886
13433	90	KG	5	90	5	2886
13434	90	KG	5	90	5	2886
13435	120	KG	5	120	5	2887
13436	120	KG	5	120	2	2887
13437	120	KG	5	120	5	2887
13438	20	KG	8	20	8	2888
13439	20	KG	8	20	8	2888
13440	20	KG	8	20	8	2888
13441	20	KG	8	20	8	2888
13442	20	KG	8	20	8	2888
13443	0	KG	20	\N	\N	2889
13444	0	KG	20	\N	\N	2889
13445	0	KG	20	\N	\N	2889
13446	0	KG	20	\N	\N	2889
13447	0	KG	20	\N	\N	2889
13466	50	KG	3	\N	\N	2894
13467	50	KG	3	\N	\N	2894
13468	50	KG	3	\N	\N	2894
13469	50	KG	3	\N	\N	2894
13470	50	KG	3	\N	\N	2894
13471	50	KG	3	\N	\N	2895
13472	50	KG	3	\N	\N	2895
13473	50	KG	3	\N	\N	2895
13474	50	KG	3	\N	\N	2895
13475	50	KG	3	\N	\N	2895
13476	20	KG	5	\N	\N	2896
13477	20	KG	5	\N	\N	2896
13478	20	KG	5	\N	\N	2896
13479	20	KG	5	\N	\N	2896
13480	20	KG	5	\N	\N	2896
13481	0	KG	8	\N	\N	2897
13482	0	KG	8	\N	\N	2897
13483	0	KG	8	\N	\N	2897
13484	0	KG	8	\N	\N	2897
13485	0	KG	8	\N	\N	2897
13486	0	KG	8	\N	\N	2898
13487	0	KG	8	\N	\N	2898
13488	0	KG	8	\N	\N	2898
13489	0	KG	8	\N	\N	2898
13490	0	KG	8	\N	\N	2898
13491	50	KG	3	\N	\N	2899
13492	50	KG	3	\N	\N	2899
13493	50	KG	3	\N	\N	2899
13494	50	KG	3	\N	\N	2899
13495	50	KG	3	\N	\N	2899
13496	50	KG	3	\N	\N	2900
13497	50	KG	3	\N	\N	2900
13498	50	KG	3	\N	\N	2900
13499	50	KG	3	\N	\N	2900
13500	50	KG	3	\N	\N	2900
13501	50	KG	3	\N	\N	2901
13502	50	KG	3	\N	\N	2901
13503	50	KG	3	\N	\N	2901
13504	50	KG	3	\N	\N	2901
13505	50	KG	3	\N	\N	2901
13506	0	KG	8	\N	\N	2902
13507	0	KG	8	\N	\N	2902
13508	0	KG	8	\N	\N	2902
13509	0	KG	8	\N	\N	2902
13510	0	KG	8	\N	\N	2902
13511	0	KG	8	\N	\N	2903
13512	0	KG	8	\N	\N	2903
13513	0	KG	8	\N	\N	2903
13514	0	KG	8	\N	\N	2903
13515	0	KG	8	\N	\N	2903
13516	0	KG	1	\N	\N	2904
13517	0	KG	1	\N	\N	2905
13518	0	KG	1	\N	\N	2906
13519	0	KG	1	\N	\N	2907
13520	75	KG	7	75	7	2908
13521	75	KG	7	75	6	2908
13522	75	KG	7	75	5	2908
13523	7.5	KG	15	7.5	15	2909
13524	7.5	KG	12	7.5	12	2909
13525	7.5	KG	12	7	10	2909
13526	22.5	KG	9	22.5	9	2910
13527	22.5	KG	9	22	8	2910
13528	22.5	KG	8	22	7	2910
13529	25	KG	9	25	9	2911
13530	25	KG	9	25	7	2911
13531	25	KG	7	25	5	2911
13532	10	KG	10	10	10	2912
13533	10	KG	10	10	10	2912
13534	10	KG	10	\N	\N	2912
13535	8.75	KG	11	9	8	2913
13536	8.75	KG	11	9	8	2913
13537	12	KG	10	13	10	2914
13538	12	KG	10	13	10	2914
13539	0	KG	12	\N	\N	2915
13540	0	KG	12	\N	\N	2915
13541	15	KG	8	\N	\N	2916
13542	15	KG	8	\N	\N	2916
18491	0	KG	16	\N	\N	4128
18492	0	KG	15	\N	\N	4129
18493	0	KG	15	\N	\N	4129
18494	0	KG	15	\N	\N	4129
18495	0	KG	15	\N	\N	4129
18496	0	KG	15	\N	\N	4129
13566	50	KG	3	\N	\N	2926
13567	50	KG	3	\N	\N	2926
13568	50	KG	3	\N	\N	2926
13569	50	KG	3	\N	\N	2926
13570	50	KG	3	\N	\N	2926
13571	50	KG	3	\N	\N	2927
13572	50	KG	3	\N	\N	2927
13573	50	KG	3	\N	\N	2927
13574	50	KG	3	\N	\N	2927
13575	50	KG	3	\N	\N	2927
13576	50	KG	3	\N	\N	2928
13577	50	KG	3	\N	\N	2928
13578	50	KG	3	\N	\N	2928
13579	50	KG	3	\N	\N	2928
13580	50	KG	3	\N	\N	2928
13581	0	KG	8	\N	\N	2929
13582	0	KG	8	\N	\N	2929
13583	0	KG	8	\N	\N	2929
13584	0	KG	8	\N	\N	2929
13585	0	KG	8	\N	\N	2929
13586	0	KG	8	\N	\N	2930
13587	0	KG	8	\N	\N	2930
13588	0	KG	8	\N	\N	2930
13589	0	KG	8	\N	\N	2930
13590	0	KG	8	\N	\N	2930
13591	50	KG	3	\N	\N	2931
13592	50	KG	3	\N	\N	2931
13593	50	KG	3	\N	\N	2931
13594	50	KG	3	\N	\N	2931
13595	50	KG	3	\N	\N	2931
13596	20	KG	5	\N	\N	2932
13597	20	KG	5	\N	\N	2932
13598	20	KG	5	\N	\N	2932
13599	20	KG	5	\N	\N	2932
13600	20	KG	5	\N	\N	2932
13601	50	KG	3	\N	\N	2933
13602	50	KG	3	\N	\N	2933
13603	50	KG	3	\N	\N	2933
13604	50	KG	3	\N	\N	2933
13605	50	KG	3	\N	\N	2933
13606	0	KG	8	\N	\N	2934
13607	0	KG	8	\N	\N	2934
13608	0	KG	8	\N	\N	2934
13609	0	KG	8	\N	\N	2934
13610	0	KG	8	\N	\N	2934
13611	0	KG	8	\N	\N	2935
13612	0	KG	8	\N	\N	2935
13613	0	KG	8	\N	\N	2935
13614	0	KG	8	\N	\N	2935
13615	0	KG	8	\N	\N	2935
13616	20	KG	5	\N	\N	2936
13617	20	KG	5	\N	\N	2936
13618	20	KG	5	\N	\N	2936
13619	20	KG	5	\N	\N	2936
13620	20	KG	5	\N	\N	2936
13621	50	KG	3	\N	\N	2937
13622	50	KG	3	\N	\N	2937
13623	50	KG	3	\N	\N	2937
13624	50	KG	3	\N	\N	2937
13625	50	KG	3	\N	\N	2937
13626	50	KG	3	\N	\N	2938
13627	50	KG	3	\N	\N	2938
13628	50	KG	3	\N	\N	2938
13629	50	KG	3	\N	\N	2938
13630	50	KG	3	\N	\N	2938
13631	0	KG	8	\N	\N	2939
13632	0	KG	8	\N	\N	2939
13633	0	KG	8	\N	\N	2939
13634	0	KG	8	\N	\N	2939
13635	0	KG	8	\N	\N	2939
13636	0	KG	8	\N	\N	2940
13637	0	KG	8	\N	\N	2940
13638	0	KG	8	\N	\N	2940
13639	0	KG	8	\N	\N	2940
13640	0	KG	8	\N	\N	2940
13641	50	KG	3	\N	\N	2941
13642	50	KG	3	\N	\N	2941
13643	50	KG	3	\N	\N	2941
13644	50	KG	3	\N	\N	2941
13645	50	KG	3	\N	\N	2941
13646	20	KG	5	\N	\N	2942
13647	20	KG	5	\N	\N	2942
13648	20	KG	5	\N	\N	2942
13649	20	KG	5	\N	\N	2942
13650	20	KG	5	\N	\N	2942
13651	50	KG	3	\N	\N	2943
13652	50	KG	3	\N	\N	2943
13653	50	KG	3	\N	\N	2943
13654	50	KG	3	\N	\N	2943
13655	50	KG	3	\N	\N	2943
13656	0	KG	8	\N	\N	2944
13657	0	KG	8	\N	\N	2944
13658	0	KG	8	\N	\N	2944
13659	0	KG	8	\N	\N	2944
13660	0	KG	8	\N	\N	2944
13661	0	KG	8	\N	\N	2945
13662	0	KG	8	\N	\N	2945
13663	0	KG	8	\N	\N	2945
13664	0	KG	8	\N	\N	2945
13665	0	KG	8	\N	\N	2945
13666	50	KG	3	\N	\N	2946
13667	50	KG	3	\N	\N	2946
13668	50	KG	3	\N	\N	2946
13669	50	KG	3	\N	\N	2946
13670	50	KG	3	\N	\N	2946
13671	50	KG	3	\N	\N	2947
13672	50	KG	3	\N	\N	2947
13673	50	KG	3	\N	\N	2947
13674	50	KG	3	\N	\N	2947
13675	50	KG	3	\N	\N	2947
13676	50	KG	3	\N	\N	2948
13677	50	KG	3	\N	\N	2948
13678	50	KG	3	\N	\N	2948
13679	50	KG	3	\N	\N	2948
13680	50	KG	3	\N	\N	2948
13681	0	KG	8	\N	\N	2949
13682	0	KG	8	\N	\N	2949
13683	0	KG	8	\N	\N	2949
13684	0	KG	8	\N	\N	2949
13685	0	KG	8	\N	\N	2949
13686	0	KG	8	\N	\N	2950
13687	0	KG	8	\N	\N	2950
13688	0	KG	8	\N	\N	2950
13689	0	KG	8	\N	\N	2950
13690	0	KG	8	\N	\N	2950
13691	50	KG	3	\N	\N	2951
13692	50	KG	3	\N	\N	2951
13693	50	KG	3	\N	\N	2951
13694	50	KG	3	\N	\N	2951
13695	50	KG	3	\N	\N	2951
13696	50	KG	3	\N	\N	2952
13697	50	KG	3	\N	\N	2952
13698	50	KG	3	\N	\N	2952
13699	50	KG	3	\N	\N	2952
13700	50	KG	3	\N	\N	2952
13701	50	KG	3	\N	\N	2953
13702	50	KG	3	\N	\N	2953
13703	50	KG	3	\N	\N	2953
13704	50	KG	3	\N	\N	2953
13705	50	KG	3	\N	\N	2953
13706	0	KG	8	\N	\N	2954
13707	0	KG	8	\N	\N	2954
13708	0	KG	8	\N	\N	2954
13709	0	KG	8	\N	\N	2954
13710	0	KG	8	\N	\N	2954
13711	0	KG	8	\N	\N	2955
13712	0	KG	8	\N	\N	2955
13713	0	KG	8	\N	\N	2955
13714	0	KG	8	\N	\N	2955
13715	0	KG	8	\N	\N	2955
13716	0	KG	17	0	17	2956
13717	0	KG	13	0	13	2956
13718	0	KG	15	0	15	2956
13719	30	KG	9	30	9	2957
13720	30	KG	9	30	9	2957
13721	30	KG	9	30	9	2957
13722	28	KG	8	20	12	2958
13723	28	KG	8	20	12	2958
13724	28	KG	8	20	12	2958
13725	46	KG	11	46	11	2959
13726	46	KG	11	46	10	2959
13727	46	KG	10	46	8	2959
13728	23.5	KG	9	20	10	2960
13729	23.5	KG	9	20	10	2960
13730	23.5	KG	9	\N	\N	2960
13731	28.5	KG	9	\N	\N	2961
13732	28.5	KG	9	\N	\N	2961
13750	50	KG	3	\N	\N	2968
13751	50	KG	3	\N	\N	2968
13752	50	KG	3	\N	\N	2968
13753	50	KG	3	\N	\N	2968
13754	50	KG	3	\N	\N	2968
13755	50	KG	3	\N	\N	2969
13756	50	KG	3	\N	\N	2969
13757	50	KG	3	\N	\N	2969
13758	50	KG	3	\N	\N	2969
13759	50	KG	3	\N	\N	2969
13760	50	KG	3	\N	\N	2970
13761	50	KG	3	\N	\N	2970
13762	50	KG	3	\N	\N	2970
13763	50	KG	3	\N	\N	2970
13764	50	KG	3	\N	\N	2970
13765	0	KG	8	\N	\N	2971
13766	0	KG	8	\N	\N	2971
13767	0	KG	8	\N	\N	2971
13768	0	KG	8	\N	\N	2971
13769	0	KG	8	\N	\N	2971
13770	0	KG	8	\N	\N	2972
13771	0	KG	8	\N	\N	2972
13772	0	KG	8	\N	\N	2972
13773	0	KG	8	\N	\N	2972
13774	0	KG	8	\N	\N	2972
18497	0	KG	0	\N	\N	4130
18498	0	KG	0	\N	\N	4130
18499	0	KG	0	\N	\N	4130
18500	0	KG	0	\N	\N	4130
18501	0	KG	0	\N	\N	4130
18502	0	KG	0	\N	\N	4131
18503	0	KG	0	\N	\N	4131
18504	0	KG	0	\N	\N	4131
18505	0	KG	0	\N	\N	4131
18506	0	KG	0	\N	\N	4131
18507	0	KG	0	\N	\N	4132
18508	0	KG	0	\N	\N	4132
18509	0	KG	0	\N	\N	4132
18510	0	KG	0	\N	\N	4132
18511	0	KG	0	\N	\N	4132
18512	0	KG	0	\N	\N	4133
18513	0	KG	0	\N	\N	4133
18514	0	KG	0	\N	\N	4133
18515	0	KG	0	\N	\N	4133
18516	0	KG	0	\N	\N	4133
18517	0	KG	0	\N	\N	4134
18518	0	KG	0	\N	\N	4134
18519	0	KG	0	\N	\N	4134
14160	50	KG	3	\N	\N	3060
14161	50	KG	3	\N	\N	3060
14162	50	KG	3	\N	\N	3060
14163	0	KG	8	\N	\N	3061
14164	0	KG	8	\N	\N	3061
14165	0	KG	8	\N	\N	3061
14166	0	KG	8	\N	\N	3061
14167	0	KG	8	\N	\N	3061
14168	0	KG	8	\N	\N	3062
14169	0	KG	8	\N	\N	3062
14170	0	KG	8	\N	\N	3062
14171	0	KG	8	\N	\N	3062
14172	0	KG	8	\N	\N	3062
14173	50	KG	3	\N	\N	3063
14174	50	KG	3	\N	\N	3063
14175	50	KG	3	\N	\N	3063
14176	50	KG	3	\N	\N	3063
14177	50	KG	3	\N	\N	3063
14178	20	KG	5	\N	\N	3064
14179	20	KG	5	\N	\N	3064
14180	20	KG	5	\N	\N	3064
14181	20	KG	5	\N	\N	3064
14182	20	KG	5	\N	\N	3064
14183	50	KG	3	\N	\N	3065
14184	50	KG	3	\N	\N	3065
13895	40	KG	15	40	15	2997
13896	40	KG	10	40	10	2997
13897	40	KG	10	40	10	2997
13898	40	KG	10	40	10	2997
13899	40	KG	10	40	10	2997
13900	20	KG	12	20	12	2998
13901	20	KG	12	20	12	2998
13902	20	KG	12	20	12	2998
13903	20	KG	12	20	12	2998
13904	20	KG	12	20	12	2998
13905	0	KG	25	0	25	2999
13906	0	KG	25	0	25	2999
13907	0	KG	25	0	25	3000
13908	0	KG	25	0	25	3000
13909	0	KG	10	0	10	3001
13910	0	KG	10	0	10	3001
13911	0	KG	10	0	10	3001
13912	0	KG	10	0	10	3001
13913	0	KG	10	0	10	3001
18520	0	KG	0	\N	\N	4134
18521	0	KG	0	\N	\N	4134
18522	0	KG	0	\N	\N	4135
16415	120	KG	8	\N	\N	3608
16416	120	KG	8	\N	\N	3608
16417	120	KG	8	\N	\N	3608
16418	100	KG	6	\N	\N	3609
16419	100	KG	6	\N	\N	3609
16420	100	KG	6	\N	\N	3609
16421	100	KG	6	\N	\N	3609
16422	100	KG	6	\N	\N	3609
16423	20	KG	10	\N	\N	3610
16424	20	KG	10	\N	\N	3610
16425	20	KG	10	\N	\N	3610
16426	20	KG	10	\N	\N	3610
16427	20	KG	10	\N	\N	3610
14185	50	KG	3	\N	\N	3065
14186	50	KG	3	\N	\N	3065
14187	50	KG	3	\N	\N	3065
14188	0	KG	8	\N	\N	3066
14189	0	KG	8	\N	\N	3066
14190	0	KG	8	\N	\N	3066
14191	0	KG	8	\N	\N	3066
14192	0	KG	8	\N	\N	3066
14193	0	KG	8	\N	\N	3067
14194	0	KG	8	\N	\N	3067
14195	0	KG	8	\N	\N	3067
14196	0	KG	8	\N	\N	3067
14197	0	KG	8	\N	\N	3067
14234	50	KG	4	\N	\N	3074
14235	50	KG	4	\N	\N	3074
14236	50	KG	4	\N	\N	3075
14237	50	KG	4	\N	\N	3075
14238	50	KG	4	\N	\N	3075
14239	50	KG	4	\N	\N	3075
14240	50	KG	4	\N	\N	3075
14241	50	KG	4	\N	\N	3075
14242	0	KG	9	\N	\N	3076
14243	0	KG	9	\N	\N	3076
14244	0	KG	9	\N	\N	3076
14245	0	KG	9	\N	\N	3076
14246	0	KG	9	\N	\N	3076
14247	0	KG	9	\N	\N	3077
14248	0	KG	9	\N	\N	3077
14249	0	KG	9	\N	\N	3077
14250	0	KG	9	\N	\N	3077
14251	0	KG	9	\N	\N	3077
14252	50	KG	3	\N	\N	3078
14253	50	KG	3	\N	\N	3078
14254	50	KG	3	\N	\N	3078
14255	50	KG	3	\N	\N	3078
14256	50	KG	3	\N	\N	3078
14257	20	KG	5	\N	\N	3079
14258	20	KG	5	\N	\N	3079
14259	20	KG	5	\N	\N	3079
14260	20	KG	5	\N	\N	3079
14261	20	KG	5	\N	\N	3079
14262	50	KG	3	\N	\N	3080
14263	50	KG	3	\N	\N	3080
14264	50	KG	3	\N	\N	3080
14265	50	KG	3	\N	\N	3080
14266	50	KG	3	\N	\N	3080
14267	0	KG	8	\N	\N	3081
14268	0	KG	8	\N	\N	3081
14269	0	KG	8	\N	\N	3081
14270	0	KG	8	\N	\N	3081
14271	0	KG	8	\N	\N	3081
14272	0	KG	8	\N	\N	3082
14273	0	KG	8	\N	\N	3082
14274	0	KG	8	\N	\N	3082
14275	0	KG	8	\N	\N	3082
14276	0	KG	8	\N	\N	3082
14277	50	KG	3	\N	\N	3083
14278	50	KG	3	\N	\N	3083
14279	50	KG	3	\N	\N	3083
14280	50	KG	3	\N	\N	3083
14281	50	KG	3	\N	\N	3083
14282	20	KG	5	\N	\N	3084
14283	20	KG	5	\N	\N	3084
14284	20	KG	5	\N	\N	3084
14285	20	KG	5	\N	\N	3084
14286	20	KG	5	\N	\N	3084
14287	50	KG	3	\N	\N	3085
14288	50	KG	3	\N	\N	3085
14289	50	KG	3	\N	\N	3085
14290	50	KG	3	\N	\N	3085
14291	50	KG	3	\N	\N	3085
14292	0	KG	8	\N	\N	3086
14293	0	KG	8	\N	\N	3086
14294	0	KG	8	\N	\N	3086
14295	0	KG	8	\N	\N	3086
14296	0	KG	8	\N	\N	3086
14297	0	KG	8	\N	\N	3087
14298	0	KG	8	\N	\N	3087
14299	0	KG	8	\N	\N	3087
14300	0	KG	8	\N	\N	3087
14301	0	KG	8	\N	\N	3087
14302	50	KG	3	\N	\N	3088
14303	50	KG	3	\N	\N	3088
14304	50	KG	3	\N	\N	3088
14305	50	KG	3	\N	\N	3088
14306	50	KG	3	\N	\N	3088
14307	50	KG	3	\N	\N	3089
14308	50	KG	3	\N	\N	3089
14309	50	KG	3	\N	\N	3089
14310	50	KG	3	\N	\N	3089
14311	50	KG	3	\N	\N	3089
14312	20	KG	5	\N	\N	3090
14313	20	KG	5	\N	\N	3090
14314	20	KG	5	\N	\N	3090
14315	20	KG	5	\N	\N	3090
14316	20	KG	5	\N	\N	3090
14317	0	KG	8	\N	\N	3091
14318	0	KG	8	\N	\N	3091
14319	0	KG	8	\N	\N	3091
14320	0	KG	8	\N	\N	3091
14321	0	KG	8	\N	\N	3091
14322	0	KG	8	\N	\N	3092
14323	0	KG	8	\N	\N	3092
14324	0	KG	8	\N	\N	3092
14325	0	KG	8	\N	\N	3092
14326	0	KG	8	\N	\N	3092
14327	20	KG	5	\N	\N	3093
14328	20	KG	5	\N	\N	3093
14329	20	KG	5	\N	\N	3093
14330	20	KG	5	\N	\N	3093
14331	20	KG	5	\N	\N	3093
14332	50	KG	3	\N	\N	3094
14333	50	KG	3	\N	\N	3094
14334	50	KG	3	\N	\N	3094
14335	50	KG	3	\N	\N	3094
14336	50	KG	3	\N	\N	3094
14337	50	KG	3	\N	\N	3095
14338	50	KG	3	\N	\N	3095
14339	50	KG	3	\N	\N	3095
14340	50	KG	3	\N	\N	3095
14341	50	KG	3	\N	\N	3095
14342	0	KG	8	\N	\N	3096
14343	0	KG	8	\N	\N	3096
14344	0	KG	8	\N	\N	3096
14345	0	KG	8	\N	\N	3096
14346	0	KG	8	\N	\N	3096
14347	0	KG	8	\N	\N	3097
14348	0	KG	8	\N	\N	3097
14349	0	KG	8	\N	\N	3097
14350	0	KG	8	\N	\N	3097
14351	0	KG	8	\N	\N	3097
18523	0	KG	0	\N	\N	4135
18524	0	KG	0	\N	\N	4135
18525	0	KG	0	\N	\N	4135
18526	0	KG	0	\N	\N	4135
18527	0	KG	0	\N	\N	4136
18528	0	KG	0	\N	\N	4136
18529	0	KG	0	\N	\N	4136
18530	0	KG	0	\N	\N	4136
18531	0	KG	0	\N	\N	4136
18532	0	KG	0	\N	\N	4137
18533	0	KG	0	\N	\N	4137
18534	0	KG	0	\N	\N	4137
18535	0	KG	0	\N	\N	4137
18536	0	KG	0	\N	\N	4137
18537	0	KG	0	\N	\N	4138
18538	0	KG	0	\N	\N	4138
18539	0	KG	0	\N	\N	4138
18540	0	KG	0	\N	\N	4138
18541	0	KG	0	\N	\N	4138
18542	0	KG	0	\N	\N	4139
18543	0	KG	0	\N	\N	4139
18544	0	KG	0	\N	\N	4139
18545	0	KG	0	\N	\N	4139
18546	0	KG	0	\N	\N	4139
18547	0	KG	0	\N	\N	4140
18548	0	KG	0	\N	\N	4140
18549	0	KG	0	\N	\N	4140
18550	0	KG	0	\N	\N	4140
18551	0	KG	0	\N	\N	4140
18572	0	KG	0	\N	\N	4145
18573	0	KG	0	\N	\N	4145
18574	0	KG	0	\N	\N	4145
18575	0	KG	0	\N	\N	4145
18576	0	KG	0	\N	\N	4145
18577	0	KG	0	\N	\N	4146
18578	0	KG	0	\N	\N	4146
18579	0	KG	0	\N	\N	4146
18580	0	KG	0	\N	\N	4146
18581	0	KG	0	\N	\N	4146
18582	0	KG	0	\N	\N	4147
18583	0	KG	0	\N	\N	4147
18584	0	KG	0	\N	\N	4147
18585	0	KG	0	\N	\N	4147
18586	0	KG	0	\N	\N	4147
18587	0	KG	0	\N	\N	4148
18588	0	KG	0	\N	\N	4148
18589	0	KG	0	\N	\N	4148
18590	0	KG	0	\N	\N	4148
18591	0	KG	0	\N	\N	4148
18592	0	KG	0	\N	\N	4149
18593	0	KG	0	\N	\N	4149
18594	0	KG	0	\N	\N	4149
18595	0	KG	0	\N	\N	4149
18596	0	KG	0	\N	\N	4149
18597	0	KG	0	\N	\N	4150
18598	0	KG	0	\N	\N	4150
18599	0	KG	0	\N	\N	4150
18600	0	KG	0	\N	\N	4150
18601	0	KG	0	\N	\N	4150
14448	90	KG	5	100	4	3120
14449	90	KG	5	100	4	3120
14450	90	KG	5	100	4	3120
14451	90	KG	5	100	4	3120
14452	90	KG	5	100	4	3120
14453	120	KG	6	120	6	3121
14454	120	KG	4	120	4	3121
14455	120	KG	6	120	6	3121
14456	20	KG	9	20	9	3122
14457	20	KG	9	20	9	3122
14458	20	KG	9	20	9	3122
14459	20	KG	9	20	9	3122
14460	20	KG	9	20	9	3122
18552	0	KG	0	\N	\N	4141
18553	0	KG	0	\N	\N	4141
18554	0	KG	0	\N	\N	4141
18555	0	KG	0	\N	\N	4141
18556	0	KG	0	\N	\N	4141
18557	0	KG	0	\N	\N	4142
18558	0	KG	0	\N	\N	4142
18559	0	KG	0	\N	\N	4142
18560	0	KG	0	\N	\N	4142
18561	0	KG	0	\N	\N	4142
18562	0	KG	0	\N	\N	4143
18563	0	KG	0	\N	\N	4143
18564	0	KG	0	\N	\N	4143
18565	0	KG	0	\N	\N	4143
18566	0	KG	0	\N	\N	4143
18567	0	KG	0	\N	\N	4144
18568	0	KG	0	\N	\N	4144
18569	0	KG	0	\N	\N	4144
18570	0	KG	0	\N	\N	4144
18571	0	KG	0	\N	\N	4144
14701	0	KG	0	\N	\N	3172
14702	0	KG	0	\N	\N	3172
14703	0	KG	0	\N	\N	3172
14704	0	KG	0	\N	\N	3172
14705	0	KG	0	\N	\N	3172
14706	0	KG	0	\N	\N	3173
14707	0	KG	0	\N	\N	3173
14708	0	KG	0	\N	\N	3173
14709	0	KG	0	\N	\N	3173
14710	0	KG	0	\N	\N	3173
14711	0	KG	0	\N	\N	3174
14712	0	KG	0	\N	\N	3174
14713	0	KG	0	\N	\N	3174
14714	0	KG	0	\N	\N	3174
14715	0	KG	0	\N	\N	3174
14716	0	KG	0	\N	\N	3175
14717	0	KG	0	\N	\N	3175
14718	0	KG	0	\N	\N	3175
14719	0	KG	0	\N	\N	3175
14720	0	KG	0	\N	\N	3175
14721	0	KG	0	\N	\N	3176
14722	0	KG	0	\N	\N	3176
14723	0	KG	0	\N	\N	3176
14724	0	KG	0	\N	\N	3176
14725	0	KG	0	\N	\N	3176
14726	0	KG	0	\N	\N	3177
14727	0	KG	0	\N	\N	3177
14728	0	KG	0	\N	\N	3177
14729	0	KG	0	\N	\N	3177
14730	0	KG	0	\N	\N	3177
14731	0	KG	0	\N	\N	3178
14732	0	KG	0	\N	\N	3178
14733	0	KG	0	\N	\N	3178
14734	0	KG	0	\N	\N	3178
16633	0	KG	0	3	1	3652
16634	0	KG	0	3	1	3652
16635	0	KG	0	3	1	3652
16636	0	KG	0	3	1	3652
16637	0	KG	0	3	1	3652
16638	0	KG	0	3	1	3653
16639	0	KG	0	3	1	3653
16640	0	KG	0	3	1	3653
16641	0	KG	0	3	1	3653
16642	0	KG	0	3	1	3653
16643	0	KG	0	3	1	3653
16644	0	KG	0	3	4	3654
16645	0	KG	0	3	4	3654
16646	0	KG	0	3	4	3654
16647	0	KG	0	3	4	3654
16648	0	KG	0	3	4	3654
16649	0	KG	0	0	7	3655
16650	0	KG	0	0	9	3655
16651	0	KG	0	0	12	3655
16652	0	KG	0	0	14	3655
16653	0	KG	0	0	14	3655
16654	0	KG	0	0	14	3655
16655	0	KG	0	0	16	3656
16656	0	KG	0	0	13	3656
16657	0	KG	0	0	15	3656
16658	0	KG	0	0	17	3656
16659	0	KG	0	0	23	3656
14735	0	KG	0	\N	\N	3178
14736	0	KG	0	\N	\N	3179
14737	0	KG	0	\N	\N	3179
14738	0	KG	0	\N	\N	3179
14739	0	KG	0	\N	\N	3179
14740	0	KG	0	\N	\N	3179
14741	0	KG	0	\N	\N	3180
14742	0	KG	0	\N	\N	3180
14743	0	KG	0	\N	\N	3180
14744	0	KG	0	\N	\N	3180
14745	0	KG	0	\N	\N	3180
14746	0	KG	0	\N	\N	3181
14747	0	KG	0	\N	\N	3181
14748	0	KG	0	\N	\N	3181
14749	0	KG	0	\N	\N	3181
14750	0	KG	0	\N	\N	3181
14751	0	KG	0	\N	\N	3182
14752	0	KG	0	\N	\N	3182
14753	0	KG	0	\N	\N	3182
14754	0	KG	0	\N	\N	3182
14755	0	KG	0	\N	\N	3182
14756	0	KG	0	\N	\N	3183
14757	0	KG	0	\N	\N	3183
14758	0	KG	0	\N	\N	3183
14759	0	KG	0	\N	\N	3183
14760	0	KG	0	\N	\N	3183
14761	0	KG	0	\N	\N	3184
14762	0	KG	0	\N	\N	3184
14763	0	KG	0	\N	\N	3184
14764	0	KG	0	\N	\N	3184
14765	0	KG	0	\N	\N	3184
14766	0	KG	0	\N	\N	3185
14767	0	KG	0	\N	\N	3185
14768	0	KG	0	\N	\N	3185
14769	0	KG	0	\N	\N	3185
14770	0	KG	0	\N	\N	3185
14771	0	KG	0	\N	\N	3186
14772	0	KG	0	\N	\N	3186
14773	0	KG	0	\N	\N	3186
14774	0	KG	0	\N	\N	3186
14775	0	KG	0	\N	\N	3186
14776	0	KG	0	\N	\N	3187
14777	0	KG	0	\N	\N	3187
14778	0	KG	0	\N	\N	3187
14779	0	KG	0	\N	\N	3187
14780	0	KG	0	\N	\N	3187
14781	0	KG	0	\N	\N	3188
14782	0	KG	0	\N	\N	3188
14783	0	KG	0	\N	\N	3188
14784	0	KG	0	\N	\N	3188
14785	0	KG	0	\N	\N	3188
14786	0	KG	0	\N	\N	3189
14787	0	KG	0	\N	\N	3189
14788	0	KG	0	\N	\N	3189
14789	0	KG	0	\N	\N	3189
14790	0	KG	0	\N	\N	3189
14791	0	KG	0	\N	\N	3190
14792	0	KG	0	\N	\N	3190
14793	0	KG	0	\N	\N	3190
14794	0	KG	0	\N	\N	3190
14795	0	KG	0	\N	\N	3190
14796	0	KG	0	\N	\N	3191
14797	0	KG	0	\N	\N	3191
14798	0	KG	0	\N	\N	3191
14799	0	KG	0	\N	\N	3191
14800	0	KG	0	\N	\N	3191
14801	70	KG	7	70	7	3192
14802	75	KG	5	75	5	3192
14803	75	KG	5	75	5	3192
14804	75	KG	5	75	4	3192
14805	75	KG	5	75	5	3192
14806	50	KG	6	50	6	3193
14807	50	KG	8	50	8	3193
14808	50	KG	6	50	6	3193
14809	50	KG	6	50	6	3193
14810	50	KG	6	50	6	3193
14811	0	KG	0	35	5	3194
14812	0	KG	0	35	5	3194
14813	0	KG	0	35	5	3194
14814	0	KG	0	35	4	3194
14815	0	KG	0	35	4	3194
16952	0	KG	0	3	1	3717
16953	0	KG	0	3	1	3717
16954	0	KG	0	3	1	3717
16955	0	KG	0	3	1	3717
16956	0	KG	0	3	1	3717
16957	0	KG	0	9.75	1	3718
16958	0	KG	0	9.75	1	3718
16959	0	KG	0	9.75	1	3718
16960	0	KG	0	9.75	1	3718
16961	0	KG	0	9.75	1	3718
16962	0	KG	0	3	5	3719
16963	0	KG	0	3	5	3719
16964	0	KG	0	3	5	3719
16965	0	KG	0	3	5	3719
16966	0	KG	0	3	5	3719
16967	0	KG	0	0	13	3720
16968	0	KG	0	0	13	3720
16969	0	KG	0	0	13	3720
16970	0	KG	0	0	13	3720
16971	0	KG	0	0	13	3720
16972	0	KG	0	0	8	3721
16973	0	KG	0	0	8	3721
16974	0	KG	0	0	8	3721
16975	0	KG	0	0	8	3721
16976	0	KG	0	0	8	3721
18602	0	KG	0	\N	\N	4151
18603	0	KG	0	\N	\N	4151
18604	0	KG	0	\N	\N	4151
14862	75	KG	8	70	8	3205
14863	75	KG	6	75	4	3205
14864	75	KG	6	70	7	3205
14865	7.5	KG	16	5	12	3206
14866	7.5	KG	13	5	12	3206
14867	7.5	KG	11	5	12	3206
14868	0	KG	0	50	10	3207
14869	0	KG	0	50	8	3207
14870	0	KG	0	50	8	3207
14871	25	KG	10	25	8	3208
14872	25	KG	9	20	8	3208
14873	25	KG	7	\N	\N	3208
14874	10	KG	11	\N	\N	3209
14875	10	KG	11	\N	\N	3209
14876	10	KG	10	\N	\N	3209
14877	8.75	KG	10	\N	\N	3210
14878	8.75	KG	10	\N	\N	3210
14879	13	KG	11	\N	\N	3211
14880	13	KG	11	\N	\N	3211
14881	0	KG	12	\N	\N	3212
14882	0	KG	12	\N	\N	3212
14883	15	KG	8	15	10	3213
14884	15	KG	8	15	10	3213
14885	22.5	KG	10	\N	\N	3214
14886	22.5	KG	9	\N	\N	3214
14887	22.5	KG	8	\N	\N	3214
14888	75	KG	7	\N	\N	3215
14889	75	KG	5	\N	\N	3215
14890	75	KG	5	\N	\N	3215
14891	7.5	KG	15	\N	\N	3216
14892	7.5	KG	12	\N	\N	3216
14893	7.5	KG	10	\N	\N	3216
14894	25	KG	10	\N	\N	3217
14895	25	KG	9	\N	\N	3217
14896	25	KG	7	\N	\N	3217
14897	10	KG	11	\N	\N	3218
14898	10	KG	11	\N	\N	3218
14899	10	KG	10	\N	\N	3218
14900	8.75	KG	10	\N	\N	3219
14901	8.75	KG	10	\N	\N	3219
14902	13	KG	11	\N	\N	3220
14903	13	KG	11	\N	\N	3220
14904	0	KG	12	\N	\N	3221
14905	0	KG	12	\N	\N	3221
14906	15	KG	11	\N	\N	3222
14907	15	KG	11	\N	\N	3222
18605	0	KG	0	\N	\N	4151
18606	0	KG	0	\N	\N	4151
18607	0	KG	0	\N	\N	4152
18608	0	KG	0	\N	\N	4152
18609	0	KG	0	\N	\N	4152
18610	0	KG	0	\N	\N	4152
18611	0	KG	0	\N	\N	4152
18612	0	KG	0	\N	\N	4153
18613	0	KG	0	\N	\N	4153
18614	0	KG	0	\N	\N	4153
18615	0	KG	0	\N	\N	4153
18616	0	KG	0	\N	\N	4153
18617	0	KG	0	\N	\N	4154
18618	0	KG	0	\N	\N	4154
18619	0	KG	0	\N	\N	4154
18620	0	KG	0	\N	\N	4154
18621	0	KG	0	\N	\N	4154
18622	0	KG	0	\N	\N	4155
18623	0	KG	0	\N	\N	4155
18624	0	KG	0	\N	\N	4155
18625	0	KG	0	\N	\N	4155
18626	0	KG	0	\N	\N	4155
15002	0	KG	18	0	15	3249
15003	0	KG	14	0	12	3249
15004	0	KG	16	0	8	3249
15005	30	KG	10	30	10	3250
15006	30	KG	10	30	10	3250
15007	30	KG	10	30	10	3250
15008	28	KG	8	25	12	3251
15009	28	KG	8	25	12	3251
15010	28	KG	8	25	12	3251
15011	46	KG	12	46	10	3252
15012	46	KG	10	46	9	3252
15013	46	KG	9	46	6	3252
15014	23.5	KG	8	20	12	3253
15015	23.5	KG	8	20	10	3253
15016	23.5	KG	8	20.5	8	3253
15017	28.5	KG	9	\N	\N	3254
15018	28.5	KG	9	\N	\N	3254
15019	0	KG	17	\N	\N	3255
15020	0	KG	13	\N	\N	3255
15021	0	KG	15	\N	\N	3255
15022	30	KG	11	\N	\N	3256
15023	30	KG	11	\N	\N	3256
15024	30	KG	11	\N	\N	3256
15025	28	KG	7	\N	\N	3257
15026	28	KG	7	\N	\N	3257
15027	28	KG	7	\N	\N	3257
15028	46	KG	11	\N	\N	3258
15029	46	KG	9	\N	\N	3258
15030	46	KG	8	\N	\N	3258
15031	23.5	KG	7	\N	\N	3259
15032	23.5	KG	7	\N	\N	3259
15033	23.5	KG	7	\N	\N	3259
15034	28.5	KG	9	\N	\N	3260
15035	28.5	KG	9	\N	\N	3260
15036	62.5	KG	8	\N	\N	3261
15037	0	KG	0	\N	\N	3262
15038	62.5	KG	8	\N	\N	3263
15039	0	KG	0	\N	\N	3264
15041	0	KG	0	\N	\N	3266
15042	0	KG	0	\N	\N	3266
15043	0	KG	0	\N	\N	3266
15044	0	KG	0	\N	\N	3266
15045	0	KG	0	\N	\N	3266
15046	0	KG	0	\N	\N	3267
15047	0	KG	0	\N	\N	3267
15048	0	KG	0	\N	\N	3267
15049	0	KG	0	\N	\N	3267
15050	0	KG	0	\N	\N	3267
15051	0	KG	0	\N	\N	3268
15052	0	KG	0	\N	\N	3268
15053	0	KG	0	\N	\N	3268
15054	0	KG	0	\N	\N	3268
15055	0	KG	0	\N	\N	3268
15056	0	KG	0	\N	\N	3269
15057	0	KG	0	\N	\N	3269
15058	0	KG	0	\N	\N	3269
15059	0	KG	0	\N	\N	3269
15060	0	KG	0	\N	\N	3269
15061	0	KG	0	\N	\N	3270
15062	0	KG	0	\N	\N	3270
15063	0	KG	0	\N	\N	3270
15064	0	KG	0	\N	\N	3270
15065	0	KG	0	\N	\N	3270
15066	0	KG	0	\N	\N	3271
15067	0	KG	0	\N	\N	3271
15068	0	KG	0	\N	\N	3271
15069	0	KG	0	\N	\N	3271
15070	0	KG	0	\N	\N	3271
15071	0	KG	0	\N	\N	3272
15072	0	KG	0	\N	\N	3272
15073	0	KG	0	\N	\N	3272
15074	0	KG	0	\N	\N	3272
15075	0	KG	0	\N	\N	3272
15076	0	KG	0	\N	\N	3273
15077	0	KG	0	\N	\N	3273
15078	0	KG	0	\N	\N	3273
15079	0	KG	0	\N	\N	3273
15080	0	KG	0	\N	\N	3273
15081	0	KG	0	\N	\N	3274
15082	0	KG	0	\N	\N	3274
15083	0	KG	0	\N	\N	3274
15084	0	KG	0	\N	\N	3274
15085	0	KG	0	\N	\N	3274
15086	0	KG	0	\N	\N	3275
15087	0	KG	0	\N	\N	3275
15088	0	KG	0	\N	\N	3275
15089	0	KG	0	\N	\N	3275
15090	0	KG	0	\N	\N	3275
15091	0	KG	0	\N	\N	3276
15092	0	KG	0	\N	\N	3276
15093	0	KG	0	\N	\N	3276
15094	0	KG	0	\N	\N	3276
15095	0	KG	0	\N	\N	3276
15096	0	KG	0	\N	\N	3277
15097	0	KG	0	\N	\N	3277
15098	0	KG	0	\N	\N	3277
15099	0	KG	0	\N	\N	3277
15100	0	KG	0	\N	\N	3277
15101	0	KG	0	\N	\N	3278
15102	0	KG	0	\N	\N	3278
15103	0	KG	0	\N	\N	3278
15104	0	KG	0	\N	\N	3278
15105	0	KG	0	\N	\N	3278
15106	0	KG	0	\N	\N	3279
15107	0	KG	0	\N	\N	3279
15108	0	KG	0	\N	\N	3279
15109	0	KG	0	\N	\N	3279
15110	0	KG	0	\N	\N	3279
15111	0	KG	0	\N	\N	3280
15112	0	KG	0	\N	\N	3280
15113	0	KG	0	\N	\N	3280
15114	0	KG	0	\N	\N	3280
15115	0	KG	0	\N	\N	3280
15116	70	KG	5	70	5	3281
15117	70	KG	5	70	5	3281
15118	70	KG	5	70	5	3281
15119	70	KG	5	70	5	3281
15120	70	KG	5	70	5	3281
15121	30	KG	8	30	8	3282
15122	30	KG	8	30	8	3282
15123	30	KG	8	30	8	3282
15124	30	KG	8	30	8	3282
15125	30	KG	8	30	8	3282
15126	41.5	KG	7	50.5	5	3283
15127	46.25	KG	7	50	7	3283
15128	46.75	KG	7	50.75	7	3283
15129	46.75	KG	7	50.75	7	3283
15130	50	KG	8	50	8	3283
15264	20	KG	10	20	10	3317
15265	20	KG	10	20	10	3317
15266	20	KG	10	20	10	3317
15267	20	KG	10	20	10	3317
15268	20	KG	10	20	10	3317
15269	120	KG	7	120	7	3318
15270	120	KG	7	120	7	3318
15271	120	KG	7	120	7	3318
15272	100	KG	5	100	5	3319
15273	100	KG	5	100	5	3319
15274	100	KG	5	100	5	3319
15275	100	KG	5	100	5	3319
15276	100	KG	5	100	5	3319
16453	0	KG	0	\N	\N	3616
16454	0	KG	0	\N	\N	3616
16455	0	KG	0	\N	\N	3616
16456	0	KG	0	\N	\N	3616
16457	0	KG	0	\N	\N	3616
16458	70	KG	5	\N	\N	3617
16459	70	KG	5	\N	\N	3617
16460	70	KG	5	\N	\N	3617
16461	70	KG	5	\N	\N	3617
16462	70	KG	5	\N	\N	3617
16463	30	KG	8	\N	\N	3618
16464	30	KG	8	\N	\N	3618
16465	30	KG	8	\N	\N	3618
16466	30	KG	8	\N	\N	3618
16467	30	KG	8	\N	\N	3618
16468	35	KG	5	\N	\N	3619
16469	35	KG	5	\N	\N	3619
16470	35	KG	5	\N	\N	3619
16471	35	KG	5	\N	\N	3619
16472	35	KG	5	\N	\N	3619
16473	50	KG	5	\N	\N	3620
16474	50	KG	5	\N	\N	3620
16475	50	KG	5	\N	\N	3620
16476	50	KG	5	\N	\N	3620
16477	50	KG	5	\N	\N	3620
16478	75	KG	5	\N	\N	3621
16479	75	KG	5	\N	\N	3621
16480	75	KG	5	\N	\N	3621
16481	75	KG	5	\N	\N	3621
16482	75	KG	5	\N	\N	3621
\.


--
-- Data for Name: ExcerciseSetGroup; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."ExcerciseSetGroup" (excercise_set_group_id, excercise_name, workout_id, excercise_set_group_state, failure_reason) FROM stdin;
1708	Barbell Straight Leg Deadlift (Romanian)	264	NORMAL_OPERATION	\N
3007	Cable Bar Incline Bench Press	489	NORMAL_OPERATION	\N
3008	Weighted Pull-up	489	NORMAL_OPERATION	\N
3009	Barbell Lying Rear Delt Row	489	NORMAL_OPERATION	\N
3010	Incline Leg-Hip Raise	489	NORMAL_OPERATION	\N
3011	Incline Twisting Sit-up	489	NORMAL_OPERATION	\N
3012	Cable Bar Squat	490	NORMAL_OPERATION	\N
3013	Cable Curl	490	NORMAL_OPERATION	\N
3014	Cable Incline Bench Press	490	NORMAL_OPERATION	\N
3015	V-up	490	NORMAL_OPERATION	\N
2466	Pull-up	391	NORMAL_OPERATION	TOO_DIFFICULT
2467	Cable One Arm Seated Row	391	NORMAL_OPERATION	\N
2468	Cable Rear Delt Row	391	NORMAL_OPERATION	\N
2469	Barbell Curl	391	REPLACEMENT_TEMPORARILY	TOO_DIFFICULT
2470	Cable Straight Back Seated Row	391	NORMAL_OPERATION	\N
3016	Twisting Sit-up	490	NORMAL_OPERATION	\N
4151	Cable Step-up	706	NORMAL_OPERATION	\N
4152	Dumbbell Prone External Rotation	706	NORMAL_OPERATION	\N
4153	Cable Wide Grip Seated Row	706	NORMAL_OPERATION	\N
4154	Weighted Incline Straight Leg Raise	706	NORMAL_OPERATION	\N
4155	Weighted Side Crunch	706	NORMAL_OPERATION	\N
2471	Cable Pulldown	391	NORMAL_OPERATION	\N
2517	Barbell Squat	404	NORMAL_OPERATION	\N
2518	Seated Leg Raise	404	NORMAL_OPERATION	\N
2519	Cable Lying Leg Curl	404	NORMAL_OPERATION	\N
2520	Lying Leg-Hip Raise	404	NORMAL_OPERATION	\N
2521	Incline Sit-up	404	NORMAL_OPERATION	\N
2522	Barbell Squat	405	NORMAL_OPERATION	\N
2523	Seated Leg Raise	405	NORMAL_OPERATION	\N
2524	Cable Lying Leg Curl	405	NORMAL_OPERATION	\N
1644	Barbell Wide Grip Upright Row	265	NORMAL_OPERATION	\N
1645	Dumbbell Push Sit-up	265	NORMAL_OPERATION	\N
1646	Incline Leg-Hip Raise	265	NORMAL_OPERATION	\N
1647	Barbell Full Squat	266	NORMAL_OPERATION	\N
1650	V-up	266	NORMAL_OPERATION	\N
1652	Barbell Decline Bench Press	267	NORMAL_OPERATION	\N
1653	Barbell Rear Delt Row	267	NORMAL_OPERATION	\N
2525	Lying Leg-Hip Raise	405	NORMAL_OPERATION	\N
2526	Incline Sit-up	405	NORMAL_OPERATION	\N
1677	Cable Standing Low Row	270	NORMAL_OPERATION	\N
1678	Cable Chest Press	270	NORMAL_OPERATION	\N
1679	Cable Upright Row	270	NORMAL_OPERATION	\N
1680	Incline Twisting Sit-up	270	NORMAL_OPERATION	\N
1681	Jack-knife Sit-up	270	NORMAL_OPERATION	\N
1684	Cable One Arm Seated High Row	271	NORMAL_OPERATION	\N
1685	Incline Twisting Sit-up	271	NORMAL_OPERATION	\N
1687	Barbell Bench Press	272	NORMAL_OPERATION	\N
1689	Barbell Squat	272	NORMAL_OPERATION	\N
1690	Dumbbell Push Sit-up	272	NORMAL_OPERATION	\N
1707	Barbell Bench Press	264	NORMAL_OPERATION	\N
1709	Barbell Rear Delt Row	264	NORMAL_OPERATION	\N
1711	Crunch Up	264	REPLACEMENT_PERMANANTLY	\N
2678	Dumbbell Squat	434	NORMAL_OPERATION	\N
2679	Weighted Push-up	434	NORMAL_OPERATION	\N
2680	Dumbbell Shrug	434	NORMAL_OPERATION	\N
2681	Incline Leg-Hip Raise	434	NORMAL_OPERATION	\N
2682	Jack-knife Sit-up	434	NORMAL_OPERATION	\N
2683	Dumbbell One Arm Upright Row	435	NORMAL_OPERATION	\N
2684	Dumbbell Curl	435	NORMAL_OPERATION	\N
2685	Dumbbell Squat	435	NORMAL_OPERATION	\N
2686	Suspended Hanging Leg Hip Raise	435	NORMAL_OPERATION	\N
2687	Suspended Jack-knife Pike	435	NORMAL_OPERATION	\N
2688	Weighted Push-up	436	NORMAL_OPERATION	\N
2689	Dumbbell Straight Leg Deadlift (Romanian)	436	NORMAL_OPERATION	\N
2690	Dumbbell Reclined Shoulder Press	436	NORMAL_OPERATION	\N
2691	Suspended Jack-knife Pike	436	NORMAL_OPERATION	\N
2692	Suspended Hanging Leg Hip Raise	436	NORMAL_OPERATION	\N
2738	Sled Standing Chest Dip	446	NORMAL_OPERATION	\N
2739	Dumbbell Shrug	446	NORMAL_OPERATION	\N
2740	Lever Extended Arm Lateral Raise	446	NORMAL_OPERATION	\N
2741	Lying Leg-Hip Raise	446	NORMAL_OPERATION	\N
2742	Suspended Jack-knife	446	NORMAL_OPERATION	\N
2743	Cable Bent-over Leg Curl	447	NORMAL_OPERATION	\N
2744	Cable Seated Curl	447	NORMAL_OPERATION	\N
2745	Sled Standing Chest Dip	447	NORMAL_OPERATION	\N
2746	Sit-up	447	NORMAL_OPERATION	\N
2747	Hanging Leg-Hip Raise	447	NORMAL_OPERATION	\N
2748	Cable Kneeling Row	448	NORMAL_OPERATION	\N
2749	Barbell Upright Row	448	NORMAL_OPERATION	\N
2750	Lever Alternating Lying Leg Curl	448	NORMAL_OPERATION	\N
2751	Hanging Leg-Hip Raise	448	NORMAL_OPERATION	\N
2752	Suspended Jack-knife	448	NORMAL_OPERATION	\N
2753	Cable Lying Triceps Extension	449	NORMAL_OPERATION	\N
2754	Weighted Push-up	449	NORMAL_OPERATION	\N
2755	Cable Chin-up	449	NORMAL_OPERATION	\N
2756	Incline Twisting Sit-up	449	NORMAL_OPERATION	\N
2757	Sit-up	449	NORMAL_OPERATION	\N
2758	Barbell Upright Row	450	NORMAL_OPERATION	\N
2759	Dumbbell Front Squat	450	NORMAL_OPERATION	\N
2760	Lever Curl	450	NORMAL_OPERATION	\N
2761	Incline Sit-up	450	NORMAL_OPERATION	\N
2762	Hanging Leg-Hip Raise	450	NORMAL_OPERATION	\N
2810	Weighted Glute-Ham Raise	461	NORMAL_OPERATION	\N
2811	Barbell Decline Bench Press	461	NORMAL_OPERATION	\N
2812	Barbell Close Grip Bent-over Row	461	NORMAL_OPERATION	\N
2813	Hanging Straight Leg-Hip Raise	461	NORMAL_OPERATION	\N
2814	Incline Sit-up	461	NORMAL_OPERATION	\N
2815	Dumbbell Shoulder Press	462	NORMAL_OPERATION	\N
1743	Cable One Arm Pulldown	280	NORMAL_OPERATION	\N
1744	Cable Bar Incline Bench Press	280	NORMAL_OPERATION	\N
1745	Cable Shoulder Press	280	NORMAL_OPERATION	\N
1749	Cable Bar Curl	281	NORMAL_OPERATION	\N
1752	Jack-knife Sit-up	281	NORMAL_OPERATION	\N
1754	Barbell Shoulder Press	282	NORMAL_OPERATION	\N
1755	Cable Step-up	282	NORMAL_OPERATION	\N
1756	Lying Leg-Hip Raise	282	NORMAL_OPERATION	\N
2384	Barbell Bench Press	371	NORMAL_OPERATION	TOO_DIFFICULT
1759	Cable Standing Row	283	NORMAL_OPERATION	\N
1760	Cable Bench Press	283	NORMAL_OPERATION	\N
1761	Lying Leg-Hip Raise	283	NORMAL_OPERATION	\N
2385	Barbell Sumo Deadlift	371	NORMAL_OPERATION	\N
2386	Barbell Military Press	371	NORMAL_OPERATION	\N
1765	Dumbbell Arnold Press	284	NORMAL_OPERATION	\N
1766	Incline Leg-Hip Raise	284	NORMAL_OPERATION	\N
1767	V-up	284	NORMAL_OPERATION	\N
2387	Crunch Up	371	NORMAL_OPERATION	\N
2388	Side Bridge	371	NORMAL_OPERATION	\N
1771	Incline Leg-Hip Raise	285	NORMAL_OPERATION	\N
1772	V-up	285	NORMAL_OPERATION	\N
1774	Dumbbell Raise	286	NORMAL_OPERATION	\N
1776	Incline Leg-Hip Raise	286	NORMAL_OPERATION	\N
1777	Jack-knife Sit-up	286	NORMAL_OPERATION	\N
1778	Dumbbell Front Squat	287	NORMAL_OPERATION	\N
2478	Barbell Deadlift	395	NORMAL_OPERATION	\N
2479	Sit-up	395	NORMAL_OPERATION	\N
1783	Jack-knife Sit-up	287	NORMAL_OPERATION	\N
2480	Barbell Deadlift	398	NORMAL_OPERATION	\N
1785	Incline Leg-Hip Raise	287	NORMAL_OPERATION	\N
1786	Incline Leg-Hip Raise	288	NORMAL_OPERATION	\N
1787	Jack-knife Sit-up	288	NORMAL_OPERATION	\N
1788	Dumbbell One Arm Shoulder Press	289	NORMAL_OPERATION	\N
1789	Dumbbell Triceps Extension	289	NORMAL_OPERATION	\N
1790	Dumbbell Reclined Shoulder Press	290	NORMAL_OPERATION	\N
2481	Sit-up	398	NORMAL_OPERATION	\N
1792	Dumbbell Front Squat	290	NORMAL_OPERATION	\N
1793	V-up	289	NORMAL_OPERATION	\N
1795	Incline Leg-Hip Raise	289	NORMAL_OPERATION	\N
1796	Incline Leg-Hip Raise	290	NORMAL_OPERATION	\N
1797	Jack-knife Sit-up	290	NORMAL_OPERATION	\N
1800	Dumbbell One Arm Upright Row	291	NORMAL_OPERATION	\N
1802	V-up	291	NORMAL_OPERATION	\N
1804	Incline Leg-Hip Raise	291	NORMAL_OPERATION	\N
1808	Dumbbell Triceps Extension	293	NORMAL_OPERATION	\N
1809	Dumbbell Front Squat	293	NORMAL_OPERATION	\N
1812	V-up	293	NORMAL_OPERATION	\N
1813	Incline Leg-Hip Raise	293	NORMAL_OPERATION	\N
1819	Dumbbell Upright Row	295	NORMAL_OPERATION	\N
1820	Dumbbell Curl	295	NORMAL_OPERATION	\N
1821	Jack-knife Sit-up	295	NORMAL_OPERATION	\N
1822	V-up	295	NORMAL_OPERATION	\N
1826	Jack-knife Sit-up	296	NORMAL_OPERATION	\N
1827	V-up	296	NORMAL_OPERATION	\N
1828	Dumbbell Reclined Shoulder Press	297	NORMAL_OPERATION	\N
1831	Jack-knife Sit-up	297	NORMAL_OPERATION	\N
1832	V-up	297	NORMAL_OPERATION	\N
1805	Dumbbell Reclined Shoulder Press	292	NORMAL_OPERATION	\N
1806	Jack-knife Sit-up	292	NORMAL_OPERATION	\N
1807	Incline Leg-Hip Raise	292	NORMAL_OPERATION	\N
1811	Dumbbell Squat	294	NORMAL_OPERATION	\N
3058	Dumbbell One Arm Upright Row	497	NORMAL_OPERATION	\N
3059	Dumbbell Reclined Triceps Extension	497	NORMAL_OPERATION	\N
1816	Jack-knife Sit-up	294	NORMAL_OPERATION	\N
1817	V-up	294	NORMAL_OPERATION	\N
1833	Cable Bent-over Leg Curl	298	NORMAL_OPERATION	\N
1834	Cable Incline Chest Press	298	NORMAL_OPERATION	\N
3060	Dumbbell Step-up	497	NORMAL_OPERATION	\N
3061	Incline Leg-Hip Raise	497	NORMAL_OPERATION	\N
1837	Jack-knife Sit-up	298	NORMAL_OPERATION	\N
1838	Cable Rear Delt Row	299	NORMAL_OPERATION	\N
1839	Barbell Curl	299	NORMAL_OPERATION	\N
1840	Cable Bent-over Leg Curl	299	NORMAL_OPERATION	\N
3062	V-up	497	NORMAL_OPERATION	\N
3063	Barbell Incline Bench Press	498	NORMAL_OPERATION	\N
3064	Dumbbell Shrug	498	NORMAL_OPERATION	\N
3065	Dumbbell Upright Row	498	NORMAL_OPERATION	\N
3066	Incline Leg-Hip Raise	498	NORMAL_OPERATION	\N
3067	Twisting Sit-up	498	NORMAL_OPERATION	\N
3078	Lever Incline Bench Press	500	NORMAL_OPERATION	\N
3079	Smith Shrug	500	NORMAL_OPERATION	\N
3080	Lever Reclined Parallel Grip Shoulder Press	500	NORMAL_OPERATION	\N
3081	Incline Sit-up	500	NORMAL_OPERATION	\N
1750	Cable Straight Leg Deadlift (Romanian)	281	NORMAL_OPERATION	\N
3082	Hanging Straight Leg-Hip Raise	500	NORMAL_OPERATION	\N
3083	Dumbbell Squat	501	NORMAL_OPERATION	\N
3084	Cable Incline Triceps Extension	501	NORMAL_OPERATION	\N
3085	Lever Parallel Grip Incline Chest Press	501	NORMAL_OPERATION	\N
3086	Jack-knife Sit-up	501	NORMAL_OPERATION	\N
3087	V-up	501	NORMAL_OPERATION	\N
3088	Cable One Arm Pulldown	502	NORMAL_OPERATION	\N
3089	Dumbbell Upright Row	502	NORMAL_OPERATION	\N
3090	Lever Alternating Bent-over Leg Curl	502	NORMAL_OPERATION	\N
3091	Jack-knife Sit-up	502	NORMAL_OPERATION	\N
3092	Incline Sit-up	502	NORMAL_OPERATION	\N
3093	Cable Triceps Extension	503	NORMAL_OPERATION	\N
3094	Lever Decline Bench Press	503	NORMAL_OPERATION	\N
3095	Cable Twisting Seated Row	503	NORMAL_OPERATION	\N
2441	Barbell Triceps Extension	380	NORMAL_OPERATION	\N
1856	Incline Leg-Hip Raise	302	NORMAL_OPERATION	\N
1857	Jack-knife Sit-up	302	NORMAL_OPERATION	\N
2442	Barbell Good-morning	380	NORMAL_OPERATION	\N
2443	Lying Leg-Hip Raise	380	NORMAL_OPERATION	\N
1860	Dumbbell Decline Bench Press	303	NORMAL_OPERATION	\N
1861	Jack-knife Sit-up	303	NORMAL_OPERATION	\N
2444	Twisting Sit-up	380	NORMAL_OPERATION	\N
2445	Barbell Bent-over Row	380	NORMAL_OPERATION	\N
1864	Dumbbell Arnold Press	304	NORMAL_OPERATION	\N
1865	Dumbbell Front Squat	304	NORMAL_OPERATION	\N
1867	Incline Sit-up	304	NORMAL_OPERATION	\N
1869	Dumbbell Shoulder Press	305	NORMAL_OPERATION	\N
1870	Dumbbell Squat	305	NORMAL_OPERATION	\N
1872	V-up	305	NORMAL_OPERATION	\N
1873	Cable Pulldown	306	NORMAL_OPERATION	\N
1876	Incline Sit-up	306	NORMAL_OPERATION	\N
3033	Dumbbell Front Squat	493	NORMAL_OPERATION	\N
1879	Dumbbell Reclined Triceps Extension	307	NORMAL_OPERATION	\N
1881	Jack-knife Sit-up	307	NORMAL_OPERATION	\N
1882	Incline Twisting Sit-up	307	NORMAL_OPERATION	\N
1884	Cable Seated Lateral Raise	308	NORMAL_OPERATION	\N
1885	Cable Squat	308	NORMAL_OPERATION	\N
1886	Incline Leg-Hip Raise	308	NORMAL_OPERATION	\N
1904	Barbell Good-morning	268	NORMAL_OPERATION	\N
1905	Barbell Triceps Extension	268	NORMAL_OPERATION	\N
1907	Lying Leg-Hip Raise	268	NORMAL_OPERATION	\N
1908	Incline Twisting Sit-up	268	NORMAL_OPERATION	\N
1880	Dumbbell Straight Leg Deadlift (Romanian)	307	NORMAL_OPERATION	\N
3034	Cable Bar Pushdown	493	NORMAL_OPERATION	\N
2632	Dumbbell One Arm Lateral Raise	403	NORMAL_OPERATION	\N
2633	Barbell Bench Press	403	NORMAL_OPERATION	\N
2634	Dumbbell Incline Bench Press	403	NORMAL_OPERATION	\N
2635	Cable One Arm Lateral Raise	403	NORMAL_OPERATION	TOO_DIFFICULT
2636	Cable Triceps Extension	403	NORMAL_OPERATION	\N
2637	Cable Decline Fly	403	REPLACEMENT_TEMPORARILY	\N
2638	Cable Incline Fly	403	NORMAL_OPERATION	\N
2639	Dumbbell Shoulder Press	403	NORMAL_OPERATION	\N
3035	Smith Bent Knee Good-morning	493	NORMAL_OPERATION	\N
3036	Hanging Straight Leg-Hip Raise	493	NORMAL_OPERATION	\N
3037	Incline Leg-Hip Raise	493	NORMAL_OPERATION	\N
3038	Cable Chest Press	494	NORMAL_OPERATION	\N
3039	Dumbbell Rear Delt Row	494	NORMAL_OPERATION	\N
3040	Cable Step-up	494	NORMAL_OPERATION	\N
3041	Leg-Hip Raise (on stability ball)	494	NORMAL_OPERATION	\N
2693	Cable Parallel Grip Pulldown	437	NORMAL_OPERATION	\N
2694	Barbell Incline Bench Press	437	NORMAL_OPERATION	\N
2695	Dumbbell Seated Upright Row	437	NORMAL_OPERATION	\N
2696	Lying Leg-Hip Raise	437	NORMAL_OPERATION	\N
2697	Jack-knife Sit-up	437	NORMAL_OPERATION	\N
2698	Barbell Glute-Ham Raise	438	NORMAL_OPERATION	\N
2699	Cable Incline Triceps Extension	438	NORMAL_OPERATION	\N
2700	Cable Pulldown	438	NORMAL_OPERATION	\N
2701	Sit-up	438	NORMAL_OPERATION	\N
2702	Twisting Sit-up	438	NORMAL_OPERATION	\N
2703	Barbell Decline Bench Press	439	NORMAL_OPERATION	\N
2704	Cable Seated Lateral Raise	439	NORMAL_OPERATION	\N
2705	Cable Bent-over Leg Curl	439	NORMAL_OPERATION	\N
2706	Lying Leg-Hip Raise	439	NORMAL_OPERATION	\N
2707	Incline Leg-Hip Raise	439	NORMAL_OPERATION	\N
2768	Weighted Glute-Ham Raise	452	NORMAL_OPERATION	\N
2769	Cable Alternating Curl	452	NORMAL_OPERATION	\N
2770	Weighted Push-up	452	NORMAL_OPERATION	\N
2771	Jack-knife Sit-up	452	NORMAL_OPERATION	\N
2772	Incline Leg-Hip Raise	452	NORMAL_OPERATION	\N
2773	Cable Straight Leg Deadlift (Romanian)	453	NORMAL_OPERATION	\N
2774	Cable Lateral Raise	453	NORMAL_OPERATION	\N
2775	Barbell Full Squat	453	NORMAL_OPERATION	\N
2776	Incline Leg-Hip Raise	453	NORMAL_OPERATION	\N
2777	Jack-knife Sit-up	453	NORMAL_OPERATION	\N
2778	Cable Bar Curl	454	NORMAL_OPERATION	\N
2779	Cable Chest Press	454	NORMAL_OPERATION	\N
2780	Cable Pulldown	454	NORMAL_OPERATION	\N
2781	Incline Leg-Hip Raise	454	NORMAL_OPERATION	\N
2782	Jack-knife Sit-up	454	NORMAL_OPERATION	\N
2783	Cable One Arm Lateral Raise	455	NORMAL_OPERATION	\N
2784	Barbell Good-morning	455	NORMAL_OPERATION	\N
2785	Cable Bar Curl	455	NORMAL_OPERATION	\N
2786	Incline Leg-Hip Raise	455	NORMAL_OPERATION	\N
2787	V-up	455	NORMAL_OPERATION	\N
2788	Weighted Push-up	456	NORMAL_OPERATION	\N
2789	Cable Standing Row	456	NORMAL_OPERATION	\N
2790	Cable Standing Shoulder Press	456	NORMAL_OPERATION	\N
2791	Jack-knife Sit-up	456	NORMAL_OPERATION	\N
2792	Incline Leg-Hip Raise	456	NORMAL_OPERATION	\N
2816	Barbell Curl	462	NORMAL_OPERATION	\N
2817	Dumbbell Step-up	462	NORMAL_OPERATION	\N
2818	Lying Leg-Hip Raise	462	NORMAL_OPERATION	\N
2819	Suspended Jack-knife	462	NORMAL_OPERATION	\N
2820	Dumbbell Incline Bench Press	463	NORMAL_OPERATION	\N
2821	Weighted Chin-up	463	NORMAL_OPERATION	\N
2822	Dumbbell Reclined Shoulder Press	463	NORMAL_OPERATION	\N
2823	Hanging Straight Leg-Hip Raise	463	NORMAL_OPERATION	\N
2026	Dumbbell Straight Leg Deadlift (Romanian)	342	NORMAL_OPERATION	\N
2127	Dumbbell Straight Leg Deadlift (Romanian)	363	NORMAL_OPERATION	\N
2353	Dumbbell Incline Bench Press	367	REPLACEMENT_PERMANANTLY	\N
2354	Barbell Squat	367	REPLACEMENT_PERMANANTLY	\N
2015	Dumbbell Step-up	340	NORMAL_OPERATION	\N
2355	Dumbbell Lateral Raise	367	REPLACEMENT_PERMANANTLY	\N
2356	Crunch	367	NORMAL_OPERATION	\N
2451	Barbell Bench Press	372	NORMAL_OPERATION	\N
2019	Incline Leg-Hip Raise	340	NORMAL_OPERATION	\N
2020	Dumbbell Seated Upright Row	341	NORMAL_OPERATION	\N
2021	Dumbbell Incline Curl	341	NORMAL_OPERATION	\N
2357	Barbell Deadlift	367	NORMAL_OPERATION	INSUFFICIENT_TIME
3042	Incline Leg-Hip Raise	494	NORMAL_OPERATION	\N
3043	Cable Curl	495	NORMAL_OPERATION	\N
3044	Cable Alternating Seated High Row	495	NORMAL_OPERATION	\N
2027	Dumbbell Rear Delt Row	342	NORMAL_OPERATION	\N
2452	Barbell Shoulder Press	372	NORMAL_OPERATION	\N
3045	Cable Decline Chest Press	495	NORMAL_OPERATION	\N
2030	Dumbbell Curl	343	NORMAL_OPERATION	\N
2031	Dumbbell Squat	343	NORMAL_OPERATION	\N
3046	Hanging Leg-Hip Raise	495	NORMAL_OPERATION	\N
2033	Incline Leg-Hip Raise	343	NORMAL_OPERATION	\N
2034	Lying Leg-Hip Raise	343	NORMAL_OPERATION	\N
2035	Dumbbell Shrug	344	NORMAL_OPERATION	\N
2036	Dumbbell Upright Row	344	NORMAL_OPERATION	\N
2037	Dumbbell Reclined Triceps Extension	344	NORMAL_OPERATION	\N
2038	Incline Twisting Sit-up	344	NORMAL_OPERATION	\N
2453	Cable Standing Fly	372	NORMAL_OPERATION	\N
2454	Cable Triceps Extension	372	NORMAL_OPERATION	\N
2044	Incline Sit-up	345	NORMAL_OPERATION	\N
2045	Dumbbell One Arm Upright Row	346	NORMAL_OPERATION	\N
2046	Dumbbell Incline Curl	346	NORMAL_OPERATION	\N
2047	Dumbbell Step-up	346	NORMAL_OPERATION	\N
2048	Lying Leg-Hip Raise	346	NORMAL_OPERATION	\N
2049	Incline Sit-up	346	NORMAL_OPERATION	\N
2051	Cable Bar Incline Bench Press	347	NORMAL_OPERATION	\N
2052	Cable Bar Military Press	347	NORMAL_OPERATION	\N
2053	Jack-knife Sit-up	347	NORMAL_OPERATION	\N
2054	Incline Twisting Sit-up	347	NORMAL_OPERATION	\N
2055	Dumbbell Step-up	348	NORMAL_OPERATION	\N
2056	Cable Seated Curl	348	NORMAL_OPERATION	\N
2483	Push-up	400	NORMAL_OPERATION	\N
2058	Lying Leg-Hip Raise	348	NORMAL_OPERATION	\N
2059	Incline Sit-up	348	NORMAL_OPERATION	\N
2484	Inverted Row	400	NORMAL_OPERATION	\N
2061	Cable Lateral Raise	349	NORMAL_OPERATION	\N
2062	Cable Lying Leg Curl	349	NORMAL_OPERATION	\N
2063	Incline Twisting Sit-up	349	NORMAL_OPERATION	\N
2064	Lying Leg-Hip Raise	349	NORMAL_OPERATION	\N
2065	Cable Underhand Pulldown	350	NORMAL_OPERATION	\N
2485	Rear Delt Inverted Row	400	NORMAL_OPERATION	\N
2067	Cable Shoulder Press	350	NORMAL_OPERATION	\N
2068	Jack-knife Sit-up	350	NORMAL_OPERATION	\N
2069	V-up	350	NORMAL_OPERATION	\N
2070	Barbell Glute-Ham Raise	351	NORMAL_OPERATION	\N
2486	Jack-knife Sit-up	400	NORMAL_OPERATION	\N
2072	Dumbbell Shrug	351	NORMAL_OPERATION	\N
2073	Incline Leg-Hip Raise	351	NORMAL_OPERATION	\N
2074	V-up	351	NORMAL_OPERATION	\N
2487	V-up	400	NORMAL_OPERATION	\N
2076	Dumbbell Shoulder Press	352	NORMAL_OPERATION	\N
2077	Barbell Full Squat	352	NORMAL_OPERATION	\N
2078	V-up	352	NORMAL_OPERATION	\N
2079	Incline Leg-Hip Raise	352	NORMAL_OPERATION	\N
2080	Cable Chest Press	353	NORMAL_OPERATION	\N
2081	Dumbbell Shrug	353	NORMAL_OPERATION	\N
2082	Dumbbell Raise	353	NORMAL_OPERATION	\N
2083	Incline Leg-Hip Raise	353	NORMAL_OPERATION	\N
2488	Rear Lunge	401	NORMAL_OPERATION	\N
2489	Inverted Biceps Row	401	NORMAL_OPERATION	\N
2490	Push-up (on knees)	401	NORMAL_OPERATION	\N
2087	Cable Bar Bench Press	354	NORMAL_OPERATION	\N
2491	Incline Leg-Hip Raise	401	NORMAL_OPERATION	\N
2492	V-up	401	NORMAL_OPERATION	\N
2090	Barbell Close Grip Bent-over Row	355	NORMAL_OPERATION	\N
2091	Dumbbell Shoulder Press	355	NORMAL_OPERATION	\N
2092	Barbell Full Squat	355	NORMAL_OPERATION	\N
2093	Jack-knife Sit-up	355	NORMAL_OPERATION	\N
2094	Incline Twisting Sit-up	355	NORMAL_OPERATION	\N
2097	Barbell Lying Triceps Extension	356	NORMAL_OPERATION	\N
2098	Barbell Decline Triceps Extension	356	NORMAL_OPERATION	\N
2099	Barbell Lying Triceps Extension	357	NORMAL_OPERATION	\N
2100	Barbell Decline Triceps Extension	357	NORMAL_OPERATION	\N
2493	Chin-up	402	NORMAL_OPERATION	\N
2494	Rear Delt Inverted Row	402	NORMAL_OPERATION	\N
2103	Dumbbell Lateral Raise	358	NORMAL_OPERATION	\N
2104	V-up	358	NORMAL_OPERATION	\N
2105	Jack-knife Sit-up	358	NORMAL_OPERATION	\N
2495	Hanging Hamstring Bridge Curl	402	NORMAL_OPERATION	\N
2496	Jack-knife Sit-up	402	NORMAL_OPERATION	\N
2497	V-up	402	NORMAL_OPERATION	\N
2109	Incline Leg-Hip Raise	359	NORMAL_OPERATION	\N
2110	Jack-knife Sit-up	359	NORMAL_OPERATION	\N
2112	Dumbbell One Arm Upright Row	360	NORMAL_OPERATION	\N
2113	Dumbbell Step-up	360	NORMAL_OPERATION	\N
2114	Lying Leg-Hip Raise	360	NORMAL_OPERATION	\N
2115	V-up	360	NORMAL_OPERATION	\N
2116	Dumbbell Squat	361	NORMAL_OPERATION	\N
2119	Incline Leg-Hip Raise	361	NORMAL_OPERATION	\N
2120	Jack-knife Sit-up	361	NORMAL_OPERATION	\N
2121	Dumbbell Lateral Raise	362	NORMAL_OPERATION	\N
2124	V-up	362	NORMAL_OPERATION	\N
2125	Incline Leg-Hip Raise	362	NORMAL_OPERATION	\N
2128	Dumbbell Arnold Press	363	NORMAL_OPERATION	\N
2129	V-up	363	NORMAL_OPERATION	\N
2130	Incline Leg-Hip Raise	363	NORMAL_OPERATION	\N
2131	Dumbbell Curl	364	NORMAL_OPERATION	\N
2134	Jack-knife Sit-up	364	NORMAL_OPERATION	\N
2135	V-up	364	NORMAL_OPERATION	\N
2649	Weighted Push-up	428	NORMAL_OPERATION	\N
2650	Weighted Hyperextension	428	NORMAL_OPERATION	\N
2651	Lying Leg-Hip Raise	428	NORMAL_OPERATION	\N
2652	V-up	428	NORMAL_OPERATION	\N
2653	Weighted Glute-Ham Raise	429	NORMAL_OPERATION	\N
2654	Weighted Bench Dip	429	NORMAL_OPERATION	\N
2459	Barbell Bench Press	394	NORMAL_OPERATION	\N
2460	Barbell Shoulder Press	394	NORMAL_OPERATION	\N
2461	Cable Standing Fly	394	NORMAL_OPERATION	\N
2462	Cable Triceps Extension	394	NORMAL_OPERATION	\N
3047	Leg-Hip Raise (on stability ball)	495	NORMAL_OPERATION	\N
3068	Cable Alternating Pulldown	492	NORMAL_OPERATION	\N
2498	Barbell Bench Press	390	NORMAL_OPERATION	\N
2499	Dumbbell Incline Bench Press	390	NORMAL_OPERATION	\N
2500	Cable One Arm Lateral Raise	390	NORMAL_OPERATION	\N
2501	Cable Seated Rear Lateral Raise	390	REPLACEMENT_TEMPORARILY	\N
2502	Cable Triceps Extension	390	NORMAL_OPERATION	TOO_DIFFICULT
2503	Cable Decline Fly	390	NORMAL_OPERATION	\N
2504	Cable Incline Fly	390	NORMAL_OPERATION	\N
2505	Dumbbell Shoulder Press	390	NORMAL_OPERATION	\N
3069	Dumbbell Incline Bench Press	492	NORMAL_OPERATION	\N
3070	Cable Upright Row	492	NORMAL_OPERATION	\N
3071	Incline Sit-up	492	NORMAL_OPERATION	\N
3072	V-up	492	NORMAL_OPERATION	\N
3073	Cable Alternating Pulldown	499	NORMAL_OPERATION	\N
3074	Dumbbell Incline Bench Press	499	NORMAL_OPERATION	\N
3075	Cable Upright Row	499	NORMAL_OPERATION	\N
3076	Incline Sit-up	499	NORMAL_OPERATION	\N
2196	Barbell Upright Row	273	NORMAL_OPERATION	\N
2197	Barbell Good-morning	273	NORMAL_OPERATION	\N
2198	Sit-up	273	REPLACEMENT_PERMANANTLY	INSUFFICIENT_TIME
2199	Crunch	273	REPLACEMENT_PERMANANTLY	INSUFFICIENT_TIME
2210	Dumbbell Rear Delt Row	369	NORMAL_OPERATION	\N
2212	Barbell Glute-Ham Raise	369	NORMAL_OPERATION	\N
2217	Barbell Seated Military Press	370	NORMAL_OPERATION	\N
2218	Incline Twisting Sit-up	370	NORMAL_OPERATION	\N
2219	Incline Sit-up	370	NORMAL_OPERATION	\N
2220	Barbell Bench Press	274	NORMAL_OPERATION	\N
2221	Barbell Sumo Deadlift	274	REPLACEMENT_PERMANANTLY	\N
2222	Barbell Military Press	274	REPLACEMENT_PERMANANTLY	TOO_DIFFICULT
2655	Weighted Push-up	429	NORMAL_OPERATION	\N
2224	Crunch Up	274	NORMAL_OPERATION	INSUFFICIENT_TIME
2656	Sit-up	429	NORMAL_OPERATION	\N
2657	Twisting Sit-up	429	NORMAL_OPERATION	\N
2708	Barbell Good-morning	440	NORMAL_OPERATION	\N
2709	Cable Chest Press	440	NORMAL_OPERATION	\N
2710	Cable One Arm Straight Back Seated High Row	440	NORMAL_OPERATION	\N
2711	V-up	440	NORMAL_OPERATION	\N
2712	Twisting Sit-up	440	NORMAL_OPERATION	\N
2232	Cable Alternating Standing Pulldown	373	NORMAL_OPERATION	\N
2713	Barbell Seated Military Press	441	NORMAL_OPERATION	\N
2234	Jack-knife Sit-up	373	NORMAL_OPERATION	\N
2235	Incline Leg-Hip Raise	373	NORMAL_OPERATION	\N
2236	Cable Belt Half Squat	374	NORMAL_OPERATION	\N
2237	Dumbbell Curl	374	NORMAL_OPERATION	\N
2238	Cable Chest Press	374	NORMAL_OPERATION	\N
2239	Jack-knife Sit-up	374	NORMAL_OPERATION	\N
2240	Incline Leg-Hip Raise	374	NORMAL_OPERATION	\N
2714	Barbell Lying Triceps Extension	441	NORMAL_OPERATION	\N
2242	Cable Seated Lateral Raise	375	NORMAL_OPERATION	\N
2243	Cable Belt Squat	375	NORMAL_OPERATION	\N
2244	V-up	375	NORMAL_OPERATION	\N
2715	Weighted Glute-Ham Raise	441	NORMAL_OPERATION	\N
2246	Cable Bar Pushdown	376	NORMAL_OPERATION	\N
2247	Cable Chest Dip	376	NORMAL_OPERATION	\N
2248	Cable One Arm Kneeling Pulldown	376	NORMAL_OPERATION	\N
2716	Lying Leg-Hip Raise	441	NORMAL_OPERATION	\N
2250	V-up	376	NORMAL_OPERATION	\N
2717	Sit-up	441	NORMAL_OPERATION	\N
2718	Cable Bench Press	442	NORMAL_OPERATION	\N
2719	Cable Straight Back Seated Row	442	NORMAL_OPERATION	\N
2720	Cable Wide Grip Upright Row	442	NORMAL_OPERATION	\N
2721	Sit-up	442	NORMAL_OPERATION	\N
2722	Lying Leg-Hip Raise	442	NORMAL_OPERATION	\N
2793	Cable Shrug	457	NORMAL_OPERATION	\N
2794	Barbell Incline Bench Press	457	NORMAL_OPERATION	\N
2795	Dumbbell Raise	457	NORMAL_OPERATION	\N
2796	V-up	457	NORMAL_OPERATION	\N
2797	Incline Leg-Hip Raise	457	NORMAL_OPERATION	\N
2798	Barbell Glute-Ham Raise	458	NORMAL_OPERATION	\N
2799	Cable Seated Curl	458	NORMAL_OPERATION	\N
2800	Barbell Underhand Bent-over Row	458	NORMAL_OPERATION	\N
2801	Jack-knife Sit-up	458	NORMAL_OPERATION	\N
2802	Incline Leg-Hip Raise	458	NORMAL_OPERATION	\N
2803	Barbell Incline Bench Press	459	NORMAL_OPERATION	\N
2804	Barbell Upright Row	459	NORMAL_OPERATION	\N
2805	Dumbbell Front Squat	459	NORMAL_OPERATION	\N
2806	Sit-up	459	NORMAL_OPERATION	\N
2807	V-up	459	NORMAL_OPERATION	\N
2272	Barbell Good-morning	313	NORMAL_OPERATION	\N
2273	Barbell Lying Triceps Extension	313	REPLACEMENT_TEMPORARILY	\N
2824	Suspended Twisting Jack-knife	463	NORMAL_OPERATION	\N
2275	Lying Leg-Hip Raise	313	NORMAL_OPERATION	\N
2276	Twisting Sit-up	313	REPLACEMENT_PERMANANTLY	\N
2826	Cable Curl	397	NORMAL_OPERATION	\N
2827	Pull-up	397	NORMAL_OPERATION	\N
2828	Cable One Arm Seated Row	397	NORMAL_OPERATION	\N
2829	Cable Rear Delt Row	397	NORMAL_OPERATION	TOO_DIFFICULT
2830	Cable Straight Back Seated Row	397	NORMAL_OPERATION	\N
2831	Cable Seated Reverse Fly	397	REPLACEMENT_TEMPORARILY	\N
2293	Cable Chest Press	382	NORMAL_OPERATION	\N
2295	Lying Leg-Hip Raise	382	NORMAL_OPERATION	\N
2297	Dumbbell Reclined Shoulder Press	383	NORMAL_OPERATION	\N
2298	Barbell Close Grip Incline Bench Press	383	NORMAL_OPERATION	\N
2299	Cable Squat	383	NORMAL_OPERATION	\N
2300	Suspended Hanging Leg Hip Raise	383	NORMAL_OPERATION	\N
2302	Lever Alternating Chest Press	384	NORMAL_OPERATION	\N
2303	Lever Front Pulldown	384	NORMAL_OPERATION	\N
2304	Cable Twisting Overhead Press	384	NORMAL_OPERATION	\N
2306	Suspended Jack-knife	384	NORMAL_OPERATION	\N
2307	Cable Bar Curl	385	NORMAL_OPERATION	\N
2310	V-up	385	NORMAL_OPERATION	\N
2311	Suspended Jack-knife Pike	385	NORMAL_OPERATION	\N
2312	Barbell Sumo Deadlift	386	NORMAL_OPERATION	\N
2844	Incline Sit-up	466	NORMAL_OPERATION	\N
2314	Lever Triceps Dip	386	NORMAL_OPERATION	\N
2845	Incline Leg Raise	466	NORMAL_OPERATION	\N
2846	Cable Twist	466	NORMAL_OPERATION	\N
2847	Weighted Lying Leg Raise	466	NORMAL_OPERATION	\N
2848	Cable Kneeling Crunch	466	NORMAL_OPERATION	\N
2849	Dumbbell Reverse Wrist Curl	466	NORMAL_OPERATION	\N
2850	Incline Sit-up	467	NORMAL_OPERATION	\N
2851	Incline Leg Raise	467	NORMAL_OPERATION	\N
2852	Cable Twist	467	NORMAL_OPERATION	\N
2853	Weighted Lying Leg Raise	467	NORMAL_OPERATION	\N
2316	Suspended Jack-knife Pike	386	NORMAL_OPERATION	\N
2658	Barbell Decline Bench Press	430	NORMAL_OPERATION	\N
2659	Dumbbell Incline Row	430	NORMAL_OPERATION	\N
2660	Barbell Upright Row	430	NORMAL_OPERATION	\N
2661	Hanging Leg-Hip Raise	430	NORMAL_OPERATION	\N
2662	Incline Leg-Hip Raise	430	NORMAL_OPERATION	\N
2663	Cable Bent-over Leg Curl	431	NORMAL_OPERATION	\N
2664	Cable Alternating Curl	431	NORMAL_OPERATION	\N
2665	Barbell Decline Bench Press	431	NORMAL_OPERATION	\N
2666	Incline Sit-up	431	NORMAL_OPERATION	\N
2667	Jack-knife Sit-up	431	NORMAL_OPERATION	\N
2668	Cable One Arm Seated Row	432	NORMAL_OPERATION	\N
2669	Cable Twisting Overhead Press	432	NORMAL_OPERATION	\N
2670	Dumbbell Step-up	432	NORMAL_OPERATION	\N
2671	Lying Leg-Hip Raise	432	NORMAL_OPERATION	\N
2672	V-up	432	NORMAL_OPERATION	\N
2673	Cable Bar Pushdown	433	NORMAL_OPERATION	\N
2674	Dumbbell Decline Bench Press	433	NORMAL_OPERATION	\N
2675	Weighted Inverted Row	433	NORMAL_OPERATION	\N
2676	Jack-knife Sit-up	433	NORMAL_OPERATION	\N
2677	Incline Leg-Hip Raise	433	NORMAL_OPERATION	\N
2723	Weighted Push-up	443	NORMAL_OPERATION	\N
2724	Cable Rear Pulldown	443	NORMAL_OPERATION	\N
2725	Dumbbell Reclined Shoulder Press	443	NORMAL_OPERATION	\N
2726	V-up	443	NORMAL_OPERATION	\N
2727	Incline Sit-up	443	NORMAL_OPERATION	\N
2728	Cable Squat	444	NORMAL_OPERATION	\N
2729	Dumbbell Lying Triceps Extension	444	NORMAL_OPERATION	\N
2730	Barbell Incline Bench Press	444	NORMAL_OPERATION	\N
2731	Incline Sit-up	444	NORMAL_OPERATION	\N
2732	Lying Leg-Hip Raise	444	NORMAL_OPERATION	\N
2733	Cable Pulldown	445	NORMAL_OPERATION	\N
2734	Dumbbell Seated Upright Row	445	NORMAL_OPERATION	\N
2735	Cable Bar Squat	445	NORMAL_OPERATION	\N
2736	Lying Leg-Hip Raise	445	NORMAL_OPERATION	\N
2737	Sit-up	445	NORMAL_OPERATION	\N
2825	Barbell Deadlift	464	NORMAL_OPERATION	\N
2854	Cable Kneeling Crunch	467	NORMAL_OPERATION	\N
2855	Dumbbell Reverse Wrist Curl	467	NORMAL_OPERATION	\N
2856	Cable Bent-over Leg Curl	468	NORMAL_OPERATION	\N
2857	Cable Bar Bench Press	468	NORMAL_OPERATION	\N
2858	Cable One Arm Kneeling Pulldown	468	NORMAL_OPERATION	\N
2859	V-up	468	NORMAL_OPERATION	\N
2860	Incline Leg-Hip Raise	468	NORMAL_OPERATION	\N
2861	Cable Bar Upright Row	469	NORMAL_OPERATION	\N
2862	Dumbbell One Arm Triceps Extension	469	NORMAL_OPERATION	\N
2863	Lever Lying Leg Curl	469	NORMAL_OPERATION	\N
2864	Incline Sit-up	469	NORMAL_OPERATION	\N
2865	V-up	469	NORMAL_OPERATION	\N
2866	Cable Decline Chest Press	470	NORMAL_OPERATION	\N
2867	Weighted Hyperextension	470	NORMAL_OPERATION	\N
2868	Cable Bar Military Press	470	NORMAL_OPERATION	\N
2869	V-up	470	NORMAL_OPERATION	\N
2870	Sit-up	470	NORMAL_OPERATION	\N
2871	Lever Seated Close Grip Press	471	NORMAL_OPERATION	\N
2872	Lever Alternating Bent-over Leg Curl	471	NORMAL_OPERATION	\N
2873	Cable Chest Press	471	NORMAL_OPERATION	\N
2874	Sit-up	471	NORMAL_OPERATION	\N
2875	Incline Twisting Sit-up	471	NORMAL_OPERATION	\N
2876	Lever Underhand Seated Row	472	NORMAL_OPERATION	\N
2877	Dumbbell Raise	472	NORMAL_OPERATION	\N
2878	Dumbbell Curl	472	NORMAL_OPERATION	\N
2879	Twisting Sit-up	472	NORMAL_OPERATION	\N
2880	V-up	472	NORMAL_OPERATION	\N
2886	Barbell Squat	387	NORMAL_OPERATION	\N
2887	Barbell Deadlift	387	NORMAL_OPERATION	TOO_DIFFICULT
2888	Dumbbell Lateral Raise	387	NORMAL_OPERATION	\N
2889	Crunch	387	NORMAL_OPERATION	\N
2894	Barbell Bench Press	474	NORMAL_OPERATION	\N
2895	Cable Alternating Close Grip Pulldown	474	NORMAL_OPERATION	\N
2896	Cable Lateral Raise	474	NORMAL_OPERATION	\N
2897	Hanging Leg-Hip Raise	474	NORMAL_OPERATION	\N
2898	Twisting Sit-up	474	NORMAL_OPERATION	\N
2899	Barbell Squat	475	NORMAL_OPERATION	\N
2900	Weighted Bench Dip	475	NORMAL_OPERATION	\N
2901	Barbell Decline Bench Press	475	NORMAL_OPERATION	\N
2902	Jack-knife Sit-up	475	NORMAL_OPERATION	\N
2903	Hanging Straight Leg-Hip Raise	475	NORMAL_OPERATION	\N
2904	Barbell Full Squat	476	NORMAL_OPERATION	\N
2905	Barbell Bent-over Row	476	NORMAL_OPERATION	\N
2906	Pull-up	476	NORMAL_OPERATION	\N
2907	Dumbbell Curl	476	NORMAL_OPERATION	\N
2908	Barbell Bench Press	427	NORMAL_OPERATION	TOO_DIFFICULT
2909	Cable One Arm Lateral Raise	427	NORMAL_OPERATION	TOO_DIFFICULT
2910	Dumbbell Incline Bench Press	427	NORMAL_OPERATION	\N
2911	Cable Triceps Extension	427	NORMAL_OPERATION	\N
2912	Dumbbell One Arm Lateral Raise	427	NORMAL_OPERATION	LOW_MOOD
2913	Cable Incline Fly	427	NORMAL_OPERATION	TOO_DIFFICULT
2914	Cable Decline Fly	427	REPLACEMENT_PERMANANTLY	\N
2915	Triceps Dip	427	NORMAL_OPERATION	\N
2916	Dumbbell Shoulder Press	427	NORMAL_OPERATION	\N
2926	Weighted Push-up	478	NORMAL_OPERATION	\N
2927	Dumbbell Straight Leg Deadlift (Romanian)	478	NORMAL_OPERATION	\N
2928	Dumbbell Arnold Press	478	NORMAL_OPERATION	\N
2929	V-up	478	NORMAL_OPERATION	\N
2930	Jack-knife Sit-up	478	NORMAL_OPERATION	\N
2931	Dumbbell Squat	479	NORMAL_OPERATION	\N
2932	Dumbbell Curl	479	NORMAL_OPERATION	\N
2933	Weighted Push-up	479	NORMAL_OPERATION	\N
2934	V-up	479	NORMAL_OPERATION	\N
2935	Jack-knife Sit-up	479	NORMAL_OPERATION	\N
2936	Cable Shrug	480	NORMAL_OPERATION	\N
2937	Cable Incline Chest Press	480	NORMAL_OPERATION	\N
2938	Barbell Seated Military Press	480	NORMAL_OPERATION	\N
2939	Sit-up	480	NORMAL_OPERATION	\N
2940	Incline Sit-up	480	NORMAL_OPERATION	\N
2941	Dumbbell Squat	481	NORMAL_OPERATION	\N
2942	Cable Lying Triceps Extension	481	NORMAL_OPERATION	\N
2943	Cable Twisting Seated High Row	481	NORMAL_OPERATION	\N
2944	Hanging Leg-Hip Raise	481	NORMAL_OPERATION	\N
2945	Jack-knife Sit-up	481	NORMAL_OPERATION	\N
2946	Smith Decline Bench Press	482	NORMAL_OPERATION	\N
2947	Smith Upright Row	482	NORMAL_OPERATION	\N
2948	Barbell Full Squat	482	NORMAL_OPERATION	\N
2949	Sit-up	482	NORMAL_OPERATION	\N
2950	Incline Twisting Sit-up	482	NORMAL_OPERATION	\N
2951	Barbell Close Grip Incline Bench Press	483	NORMAL_OPERATION	\N
2952	Cable Seated Row	483	NORMAL_OPERATION	\N
2953	Cable Incline Bench Press	483	NORMAL_OPERATION	\N
2954	Hanging Leg-Hip Raise	483	NORMAL_OPERATION	\N
2955	Incline Leg-Hip Raise	483	NORMAL_OPERATION	\N
2956	Pull-up	465	NORMAL_OPERATION	\N
2957	Cable One Arm Seated Row	465	NORMAL_OPERATION	\N
2958	Cable Rear Delt Row	465	NORMAL_OPERATION	\N
2959	Cable Curl	465	NORMAL_OPERATION	TOO_DIFFICULT
2960	Cable Straight Back Seated Row	465	NORMAL_OPERATION	TOO_DIFFICULT
2961	Cable Pulldown	465	NORMAL_OPERATION	\N
4120	Cable Incline Chest Press	700	NORMAL_OPERATION	\N
4121	Cable Seated High Row	700	NORMAL_OPERATION	\N
4122	Cable Bar Shoulder Press	700	NORMAL_OPERATION	\N
4123	Lying Leg-Hip Raise	700	NORMAL_OPERATION	\N
4124	Incline Leg-Hip Raise	700	NORMAL_OPERATION	\N
4125	Cable Incline Chest Press	701	NORMAL_OPERATION	\N
2968	Cable Standing Leg Curl	485	NORMAL_OPERATION	\N
2969	Dumbbell Incline Bench Press	485	NORMAL_OPERATION	\N
2970	Cable Seated High Row	485	NORMAL_OPERATION	\N
2971	Sit-up	485	NORMAL_OPERATION	\N
2972	Lying Leg-Hip Raise	485	NORMAL_OPERATION	\N
4126	Cable Seated High Row	701	NORMAL_OPERATION	\N
4127	Cable Bar Shoulder Press	701	NORMAL_OPERATION	\N
4128	Lying Leg-Hip Raise	701	NORMAL_OPERATION	\N
4129	Incline Leg-Hip Raise	701	NORMAL_OPERATION	\N
2997	Dumbbell Incline Row	393	REPLACEMENT_TEMPORARILY	\N
2998	Dumbbell Triceps Extension	393	REPLACEMENT_TEMPORARILY	\N
2999	Lunge	393	REPLACEMENT_TEMPORARILY	\N
3000	Lying Leg-Hip Raise	393	NORMAL_OPERATION	\N
3001	Incline Sit-up	393	REPLACEMENT_TEMPORARILY	\N
3077	V-up	499	NORMAL_OPERATION	\N
3096	Leg-Hip Raise (on stability ball)	503	NORMAL_OPERATION	\N
3097	Incline Leg-Hip Raise	503	NORMAL_OPERATION	\N
3120	Barbell Squat	473	NORMAL_OPERATION	\N
3121	Barbell Deadlift	473	NORMAL_OPERATION	\N
3122	Dumbbell Lateral Raise	473	NORMAL_OPERATION	\N
3172	Barbell Decline Bench Press	513	NORMAL_OPERATION	\N
3173	Weighted Neutral Grip Chin-up	513	NORMAL_OPERATION	\N
3174	Dumbbell Rear Delt Row	513	NORMAL_OPERATION	\N
3175	Incline Sit-up	513	NORMAL_OPERATION	\N
3176	Lying Leg-Hip Raise	513	NORMAL_OPERATION	\N
3177	Barbell Glute-Ham Raise	514	NORMAL_OPERATION	\N
3178	Dumbbell Lying Triceps Extension	514	NORMAL_OPERATION	\N
3179	Dumbbell Decline Bench Press	514	NORMAL_OPERATION	\N
3180	Hanging Straight Leg-Hip Raise	514	NORMAL_OPERATION	\N
3181	Hanging Leg-Hip Raise	514	NORMAL_OPERATION	\N
3182	Weighted Rear Pull-up	515	NORMAL_OPERATION	\N
3183	Barbell Lying Rear Delt Row	515	NORMAL_OPERATION	\N
3184	Barbell Squat	515	NORMAL_OPERATION	\N
3185	Incline Leg-Hip Raise	515	NORMAL_OPERATION	\N
3186	Lying Leg-Hip Raise	515	NORMAL_OPERATION	\N
3187	Dumbbell Lying Triceps Extension	516	NORMAL_OPERATION	\N
3188	Weighted Push-up	516	NORMAL_OPERATION	\N
3189	Dumbbell Straight Leg Deadlift (Romanian)	516	NORMAL_OPERATION	\N
3190	Sit-up	516	NORMAL_OPERATION	\N
3191	Incline Twisting Sit-up	516	NORMAL_OPERATION	\N
3192	Barbell Bench Press	389	NORMAL_OPERATION	TOO_DIFFICULT
3193	Barbell Military Press	389	NORMAL_OPERATION	\N
3194	Barbell Curl	389	NORMAL_OPERATION	\N
3205	Barbell Bench Press	477	NORMAL_OPERATION	TOO_DIFFICULT
3206	Cable One Arm Lateral Raise	477	NORMAL_OPERATION	TOO_DIFFICULT
3207	Barbell Incline Bench Press	477	REPLACEMENT_TEMPORARILY	\N
3208	Cable Triceps Extension	477	NORMAL_OPERATION	\N
3209	Dumbbell One Arm Lateral Raise	477	NORMAL_OPERATION	\N
3210	Cable Incline Fly	477	NORMAL_OPERATION	\N
3211	Cable Decline Fly	477	NORMAL_OPERATION	\N
3212	Triceps Dip	477	NORMAL_OPERATION	\N
3213	Dumbbell Shoulder Press	477	NORMAL_OPERATION	\N
3214	Dumbbell Incline Bench Press	518	NORMAL_OPERATION	\N
3215	Barbell Bench Press	518	NORMAL_OPERATION	TOO_DIFFICULT
3216	Cable One Arm Lateral Raise	518	NORMAL_OPERATION	TOO_DIFFICULT
3217	Cable Triceps Extension	518	NORMAL_OPERATION	\N
3218	Dumbbell One Arm Lateral Raise	518	NORMAL_OPERATION	\N
3219	Cable Incline Fly	518	NORMAL_OPERATION	\N
3220	Cable Decline Fly	518	NORMAL_OPERATION	\N
3221	Triceps Dip	518	NORMAL_OPERATION	\N
3222	Dumbbell Shoulder Press	518	NORMAL_OPERATION	\N
3717	Cable Bar Squat	572	NORMAL_OPERATION	\N
3718	Barbell Incline Bench Press	572	NORMAL_OPERATION	\N
3719	Cable Straight Leg Deadlift (Romanian)	572	NORMAL_OPERATION	\N
3720	Incline Sit-up	572	NORMAL_OPERATION	\N
3249	Pull-up	484	NORMAL_OPERATION	TOO_DIFFICULT
3250	Cable One Arm Seated Row	484	NORMAL_OPERATION	\N
3251	Cable Rear Delt Row	484	NORMAL_OPERATION	TOO_DIFFICULT
3252	Cable Curl	484	NORMAL_OPERATION	TOO_DIFFICULT
3253	Cable Straight Back Seated Row	484	NORMAL_OPERATION	TOO_DIFFICULT
3254	Cable Pulldown	484	NORMAL_OPERATION	\N
3255	Pull-up	526	NORMAL_OPERATION	TOO_DIFFICULT
3256	Cable One Arm Seated Row	526	NORMAL_OPERATION	\N
3257	Cable Rear Delt Row	526	NORMAL_OPERATION	TOO_DIFFICULT
3258	Cable Curl	526	NORMAL_OPERATION	TOO_DIFFICULT
3259	Cable Straight Back Seated Row	526	NORMAL_OPERATION	TOO_DIFFICULT
3260	Cable Pulldown	526	NORMAL_OPERATION	\N
3261	Barbell Deadlift	527	NORMAL_OPERATION	\N
3262	Pull-up	527	NORMAL_OPERATION	\N
3263	Barbell Deadlift	528	NORMAL_OPERATION	\N
3264	Pull-up	528	NORMAL_OPERATION	\N
3721	Sit-up	572	NORMAL_OPERATION	\N
3266	Cable Standing Leg Curl	530	NORMAL_OPERATION	\N
3267	Cable Incline Chest Press	530	NORMAL_OPERATION	\N
3268	Trap Bar Shrug	530	NORMAL_OPERATION	\N
3269	Hanging Straight Leg-Hip Raise	530	NORMAL_OPERATION	\N
3270	Jack-knife Sit-up	530	NORMAL_OPERATION	\N
3271	Barbell Rear Delt Row	531	NORMAL_OPERATION	\N
3272	Dumbbell One Arm Triceps Extension	531	NORMAL_OPERATION	\N
3273	Lever Lying Leg Curl	531	NORMAL_OPERATION	\N
3274	Sit-up	531	NORMAL_OPERATION	\N
3275	Lying Leg-Hip Raise	531	NORMAL_OPERATION	\N
3276	Barbell Decline Bench Press	532	NORMAL_OPERATION	\N
3277	Cable Incline Row	532	NORMAL_OPERATION	\N
3278	Cable Wide Grip Upright Row	532	NORMAL_OPERATION	\N
3279	Suspended Hanging Leg Hip Raise	532	NORMAL_OPERATION	\N
3280	Hanging Leg-Hip Raise	532	NORMAL_OPERATION	\N
3281	Barbell Bent-over Row	488	NORMAL_OPERATION	\N
3282	Barbell Triceps Extension	488	NORMAL_OPERATION	\N
3283	Barbell Good-morning	488	NORMAL_OPERATION	\N
4130	Dumbbell Arnold Press	702	NORMAL_OPERATION	\N
4131	Cable Lying Triceps Extension	702	NORMAL_OPERATION	\N
4132	Dumbbell Pullover	702	NORMAL_OPERATION	\N
4133	Dumbbell Arnold Press	702	NORMAL_OPERATION	\N
4134	Dumbbell Kickback	702	NORMAL_OPERATION	\N
4135	Barbell Bench Press	702	NORMAL_OPERATION	\N
4136	Dumbbell Alternating Side Lunge	703	NORMAL_OPERATION	\N
4137	Cable Bent-over Pullover	703	NORMAL_OPERATION	\N
4138	Weighted Inverted Row	703	NORMAL_OPERATION	\N
4139	Weighted Incline Straight Leg Raise	703	NORMAL_OPERATION	\N
4140	Cable Lying Straight Leg-Hip Raise	703	NORMAL_OPERATION	\N
4145	Cable Bar Behind Neck Press	705	NORMAL_OPERATION	\N
4146	Cable Triceps Dip	705	NORMAL_OPERATION	\N
4147	Dumbbell Fly	705	NORMAL_OPERATION	\N
4148	Dumbbell Seated Lateral Raise	705	NORMAL_OPERATION	\N
4149	Dumbbell Seated Supination	705	NORMAL_OPERATION	\N
4150	Dumbbell Decline Bench Press	705	NORMAL_OPERATION	\N
3317	Dumbbell Lateral Raise	505	NORMAL_OPERATION	\N
3318	Barbell Deadlift	505	NORMAL_OPERATION	\N
3319	Barbell Squat	505	NORMAL_OPERATION	\N
3608	Barbell Deadlift	600	REPLACEMENT_PERMANANTLY	\N
3609	Barbell Squat	600	NORMAL_OPERATION	\N
3610	Dumbbell Lateral Raise	600	NORMAL_OPERATION	\N
3616	Barbell Close Grip Incline Bench Press	601	NORMAL_OPERATION	\N
3617	Barbell Bent-over Row	601	NORMAL_OPERATION	\N
3618	Barbell Triceps Extension	601	NORMAL_OPERATION	\N
3619	Barbell Curl	602	NORMAL_OPERATION	\N
3620	Barbell Military Press	602	NORMAL_OPERATION	\N
3621	Barbell Bench Press	602	NORMAL_OPERATION	\N
4141	Barbell Full Squat	704	NORMAL_OPERATION	\N
4142	Cable Split Squat	704	NORMAL_OPERATION	\N
3652	Barbell Underhand Bent-over Row	603	NORMAL_OPERATION	\N
3653	Cable Bar Incline Bench Press	603	NORMAL_OPERATION	\N
3654	Dumbbell Raise	603	NORMAL_OPERATION	\N
3655	Lying Leg-Hip Raise	603	NORMAL_OPERATION	\N
3656	V-up	603	NORMAL_OPERATION	\N
4143	Cable Lying Hip Adduction	704	NORMAL_OPERATION	\N
4144	Cable Standing Leg Raise	704	NORMAL_OPERATION	\N
3662	Jack-knife Sit-up	610	NORMAL_OPERATION	\N
3663	V-up	610	NORMAL_OPERATION	\N
3664	Cable Alternating Standing Pulldown	610	NORMAL_OPERATION	\N
3665	Dumbbell Bench Press	610	NORMAL_OPERATION	\N
3666	Cable Belt Squat	610	NORMAL_OPERATION	\N
3667	Incline Twisting Sit-up	611	NORMAL_OPERATION	\N
3668	Incline Leg-Hip Raise	611	NORMAL_OPERATION	\N
3669	Dumbbell Front Squat	611	NORMAL_OPERATION	\N
3670	Dumbbell Lying Triceps Extension	611	NORMAL_OPERATION	\N
3671	Cable Bar Shoulder Press	611	NORMAL_OPERATION	\N
3672	Sit-up	612	NORMAL_OPERATION	\N
3673	Incline Sit-up	612	NORMAL_OPERATION	\N
3674	Cable Bar Behind Neck Press	612	NORMAL_OPERATION	\N
3675	Cable Parallel Grip Pulldown	612	NORMAL_OPERATION	\N
3676	Dumbbell Incline Bench Press	612	NORMAL_OPERATION	\N
3677	Twisting Sit-up	613	NORMAL_OPERATION	\N
3678	Jack-knife Sit-up	613	NORMAL_OPERATION	\N
3679	Cable Incline Bench Press	613	NORMAL_OPERATION	\N
3680	Barbell Squat	613	NORMAL_OPERATION	\N
3681	Dumbbell Reclined Triceps Extension	613	NORMAL_OPERATION	\N
3682	Incline Sit-up	614	NORMAL_OPERATION	\N
3683	Twisting Sit-up	614	NORMAL_OPERATION	\N
3684	Dumbbell One Arm Reclined Triceps Extension	614	NORMAL_OPERATION	\N
3685	Cable Twisting Overhead Press	614	NORMAL_OPERATION	\N
3686	Cable Wide Grip Seated Row	614	NORMAL_OPERATION	\N
3687	Sit-up	615	NORMAL_OPERATION	\N
3688	Lying Leg-Hip Raise	615	NORMAL_OPERATION	\N
3689	Cable Alternating Standing Pulldown	615	NORMAL_OPERATION	\N
3690	Cable Chest Dip	615	NORMAL_OPERATION	\N
3691	Cable Bar Squat	615	NORMAL_OPERATION	\N
\.


--
-- Data for Name: Measurement; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Measurement" (measurement_id, measured_at, measurement_value, length_units, user_id, muscle_region_id) FROM stdin;
\.


--
-- Data for Name: MuscleRegion; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."MuscleRegion" (muscle_region_id, muscle_region_name, muscle_region_description, muscle_region_type) FROM stdin;
1	Adductors	\N	HIPS
2	Abductors	\N	HIPS
3	Brachioradialis	\N	FORE_ARM
4	Biceps Brachii	\N	UPPER_ARM
5	Brachialis	\N	UPPER_ARM
6	Quadriceps	\N	THIGHS
7	Longus colli	\N	NECK
8	Piriformis	\N	HIPS
9	Obturator externus	\N	HIPS
10	Deltoid, Anterior	\N	SHOULDER
11	Deltoid, Lateral	\N	SHOULDER
12	Deltoid, Posterior	\N	SHOULDER
13	Deep Hip External Rotators	\N	HIPS
14	Erector Spinae	\N	BACK
15	Gastrocnemius	\N	CALVES
16	Gluteus Maximus	\N	THIGHS
17	Gluteus Medius	\N	THIGHS
18	Gluteus Minimus	\N	THIGHS
19	Gracilis	\N	THIGHS
20	Hamstrings	\N	THIGHS
21	Iliopsoas	\N	HIPS
22	Infraspinatus	\N	BACK
23	Latissimus Dorsi	\N	BACK
24	Levator Scapulae	\N	BACK
25	Obliques	\N	WAIST
26	Pectineous	\N	HIPS
27	Pectoralis Major, Clavicular Head	\N	CHEST
28	Pectoralis Major, Sternal Head	\N	CHEST
29	Teres Major	\N	BACK
30	Teres Minor	\N	BACK
31	Tibialis Anterior	\N	CALVES
32	Transverse Abdominus	\N	WAIST
33	Trapezius, Lower Fibers	\N	BACK
34	Trapezius, Middle Fibers	\N	BACK
35	Trapezius, Upper Fibers	\N	BACK
36	Pronators	\N	UPPER_ARM
37	Supinator	\N	UPPER_ARM
38	Triceps Brachii	\N	UPPER_ARM
39	Wrist Extensors	\N	FORE_ARM
40	Wrist Flexors	\N	FORE_ARM
41	Pectoralis Minor	\N	CHEST
42	Popliteus	\N	CALVES
43	Quadratus Lumborum	\N	WAIST
44	Rectus Abdominis	\N	WAIST
45	Rhomboids	\N	BACK
46	Sartorius	\N	THIGHS
47	Serratus Anterior	\N	WAIST
48	Soleus	\N	CALVES
49	Splenius	\N	NECK
50	Sternocleidomastoid	\N	NECK
51	Subscapularis	\N	BACK
52	Supraspinatus	\N	SHOULDER
53	Tensor Fasciae Latae	\N	HIPS
54	Iliopsoas Lumborum	\N	HIPS
55	Iliopsoas Thoracis	\N	HIPS
56	Psoas Major	\N	HIPS
57	Iliocastalis Lumborum	\N	BACK
58	Iliocastalis Thoracis	\N	BACK
\.


--
-- Data for Name: Notification; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Notification" (notification_id, notification_message, user_id) FROM stdin;
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."User" (user_id, email, firebase_uid, "displayName", prior_years_of_experience, level_of_experience, age, dark_mode, automatic_scheduling, workout_frequency, workout_duration, goal, gender, weight, height, weight_unit, height_unit, "phoneNumber", compound_movement_rep_lower_bound, compound_movement_rep_upper_bound, isolated_movement_rep_lower_bound, isolated_movement_rep_upper_bound, equipment_accessible, body_weight_rep_lower_bound, body_weight_rep_upper_bound, workout_type_enrollment) FROM stdin;
54	youjing.us@gmail.com	GJc5qEmWDEcMVJdfMDF3FpKWFNq1	aperinooooo	0.5	BEGINNER	25	t	t	3	30	BODY_RECOMPOSITION	FEMALE	55	165	KG	CM	\N	3	10	5	15	{DUMBBELL,BARBELL,BENCH,KETTLEBELL,CABLE}	8	20	SELF_MANAGED
57	yang_yin@live.com	SnXgkyNK3BebE0E0kfRxPqi9QxH3	bigboy	2	MID	23	t	t	4	90	BODY_RECOMPOSITION	MALE	78.1	176	KG	CM	\N	3	10	5	15	{DUMBBELL,BARBELL,BENCH,CABLE}	8	20	SELF_MANAGED
69	abanoub.ishak@gmail.com	mD5KWDFadaRotIcFo0FDjnJRblC2	jonark	0	BEGINNER	25	t	t	7	20	STRENGTH	MALE	160	175	LB	CM	\N	3	10	5	15	{DUMBBELL,BENCH}	8	20	SELF_MANAGED
53	jordanongzq@gmail.com	ljy1FfiXZkMQt0fFpV74hA0xZ6L2	Jordan	1	MID	23	t	t	3	60	KEEPING_FIT	MALE	65	170	KG	CM	\N	3	8	5	10	{DUMBBELL,BARBELL,BENCH}	8	20	SELF_MANAGED
59	elianinsing@gmail.com	mSVv3UMJF5Mq2H8XONji704WbWU2	eli	10	MID	33	t	t	7	25	BODY_RECOMPOSITION	MALE	62	178	KG	CM	\N	3	10	5	15	{}	8	20	SELF_MANAGED
60	lchuan1998@gmail.com	xqDE6ebCutRHYkZfI9huekHt20n1	chuan	5	MID	24	t	t	2	120	KEEPING_FIT	MALE	85	175	KG	CM	\N	3	10	5	15	{DUMBBELL,BARBELL,BENCH,KETTLEBELL,CABLE}	8	20	SELF_MANAGED
70	alexander@klippel.se	bvafy0Ma2JPP9yhcIBAhg3E40mI2	Alexander 	2	MID	36	t	t	3	45	KEEPING_FIT	MALE	80	173	KG	CM	\N	3	10	5	15	{DUMBBELL,BARBELL,BENCH,KETTLEBELL,CABLE}	8	20	SELF_MANAGED
71	jacob.ruberg@hotmail.com	eop43XlhvWVuOSh1LQrDmoUssVY2	Jacob	2	MID	25	t	t	3	45	KEEPING_FIT	MALE	80	179	KG	CM	\N	3	10	5	15	{DUMBBELL,BARBELL,CABLE}	8	20	SELF_MANAGED
73	ebw123@gmail.com	WSAL4PdXO1axqTAyHDRYCFmjYv32	Eric	3	ADVANCED	45	t	t	4	60	BODY_RECOMPOSITION	MALE	195	5.9	LB	FT	\N	3	10	5	15	{DUMBBELL,BARBELL,BENCH,KETTLEBELL,CABLE}	8	20	SELF_MANAGED
74	hojae.k.lee@gmail.com	jRcfCGvWmVWvEyC8ETYaON8EI5r1	Hojae 	0	BEGINNER	29	t	t	3	15	BODY_RECOMPOSITION	FEMALE	165	160	LB	CM	\N	3	10	5	15	{DUMBBELL,BENCH}	8	20	SELF_MANAGED
75	cadenjsumner@gmail.com	FrPgPJPK2PSeIGAUteivxUfqhBf1	Caden	2	MID	25	f	t	4	20	BODY_RECOMPOSITION	MALE	192	6	LB	FT	\N	3	10	5	15	{DUMBBELL}	8	20	SELF_MANAGED
76	samarkamat+firbird@gmail.com	AVhYlF3weWbz7rm2Rh0fwy8rjS42	samar	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	3	10	5	15	\N	8	20	SELF_MANAGED
45	minhuikam13@gmail.com	kYU7tdojulROZuPY1ydarvkO98m1	mapplesyrp	0	BEGINNER	21	t	t	3	\N	KEEPING_FIT	FEMALE	55	164	KG	CM	\N	3	10	5	15	{DUMBBELL,BENCH,BARBELL}	8	20	SELF_MANAGED
78	cody.rocquemore@gmail.com	dMuBILKBnSS0ccvce8zc4OWQQ512	Cody	6	MID	28	t	t	4	\N	KEEPING_FIT	MALE	198	5.9	LB	FT	\N	3	10	5	15	{DUMBBELL,CABLE}	8	20	SELF_MANAGED
63	chloexng@gmail.com	ZtvncdXetbYUK9bD2t7uLrQD1Xi1	chloe	0.5	MID	23	t	t	3	60	BODY_RECOMPOSITION	FEMALE	52	165	KG	CM	\N	3	10	5	15	{DUMBBELL,BARBELL,BENCH,KETTLEBELL,CABLE}	8	20	SELF_MANAGED
77	bilal@ayub.co	bTTf1lfV5wRkqM8e2zin8fT4h332	ayub	1	MID	26	t	t	5	\N	ATHLETICISM	MALE	115	5.1	LB	FT	\N	3	5	3	5	{DUMBBELL,BARBELL,BENCH,KETTLEBELL,CABLE,LEVER,SUSPENSION,SLED,TRAP_BAR,T_BAR,SMITH,MEDICINE_BALL}	8	30	SELF_MANAGED
83	saurav30798@gmail.com	7rRLQbp6rxYqQnP3vmeNCTbqRWY2	Saurav 	0	BEGINNER	24	t	t	2	\N	BODY_RECOMPOSITION	MALE	58	167	KG	CM	\N	3	10	5	15	{BENCH}	8	20	SELF_MANAGED
58	android_tester@gmail.com	Q9hYAfwZBye1XarwDXLyYhD8tsk1	android tester	1.5	MID	23	t	t	3	40	BODY_RECOMPOSITION	MALE	77.5	176.5	KG	CM	\N	3	10	5	15	{DUMBBELL,BARBELL,KETTLEBELL,CABLE,LEVER,SUSPENSION,T_BAR,TRAP_BAR,BENCH,MEDICINE_BALL,SLED,SMITH,PREACHER,PARALLEL_BARS,STABILITY_BALL,PULL_UP_BAR}	8	20	SELF_MANAGED
64	tankunkun77@gmail.com	e7QsNm3u3WgDXIpQai123NdF4R13	huakun	2.5	BEGINNER	23	t	t	3	\N	KEEPING_FIT	MALE	63	168	KG	CM	\N	3	10	5	15	{DUMBBELL,BARBELL,BENCH,CABLE}	8	60	SELF_MANAGED
49	apple_user@icloud.com	ahYx4JUusIco7DCl9909MlOncUb2	Apple User	5	ADVANCED	23	t	t	1	\N	STRENGTH	MALE	78	190	KG	CM	\N	3	3	3	3	{DUMBBELL,BARBELL,BENCH,KETTLEBELL,CABLE}	8	20	SELF_MANAGED
51	angyangcheng99@gmail.com	fqpfKUVz6AdOkDaiX2Jf7JakuF52	chayce	0	BEGINNER	23	t	t	3	\N	BODY_RECOMPOSITION	MALE	63	163	KG	CM	\N	8	12	8	12	{}	8	20	SELF_MANAGED
47	donovanipman@gmail.com	2RhiTfgYr1bpLdm9MU1jYz5os6i2	Donovan Ng	5	ADVANCED	23	t	t	5	90	ATHLETICISM	MALE	58	155	KG	CM	\N	3	10	5	15	{DUMBBELL,BARBELL,BENCH,KETTLEBELL,CABLE}	8	20	AI_MANAGED
82	ajaed92@gmail.com	q9IwQN7XRiYLRbEDooRDlaZO3Wy2	Abu Jaed	1	MID	30	t	t	4	\N	KEEPING_FIT	MALE	235	177	LB	CM	\N	3	10	5	15	{DUMBBELL,BARBELL,BENCH,KETTLEBELL,CABLE,PULL_UP_BAR}	8	20	SELF_MANAGED
84	brandon@16cards.com	AmWBHaNwhKZhbZztSjxx3wYAI9R2	BrandonSmith	0	BEGINNER	44	t	t	3	\N	BODY_RECOMPOSITION	MALE	245	5.91	LB	FT	\N	3	10	5	15	{DUMBBELL,SUSPENSION,MEDICINE_BALL}	8	20	SELF_MANAGED
85	3ewfili0@duck.com	wEoyjy39SzcCvHPOq0rjeWTHWsf2	Alex	1.5	MID	36	t	t	3	\N	STRENGTH	MALE	79	173	KG	CM	\N	3	10	5	15	{DUMBBELL,BARBELL,BENCH,CABLE}	8	20	SELF_MANAGED
86	pjasonhuff@gmail.com	EsMVTKv0g0hbx9VDV8V1C0bKJHn1	Jason 	2	MID	50	t	t	3	\N	BODY_RECOMPOSITION	MALE	187	6.5	LB	FT	\N	3	10	5	15	{DUMBBELL,BARBELL,BENCH,KETTLEBELL,CABLE}	8	20	SELF_MANAGED
72	atreug@hotmail.com	uuvj08xuolXfX7Hxy75hNQdD2a72	atreu	10	BEGINNER	41	t	t	3	30	BODY_RECOMPOSITION	MALE	207	5.8	LB	FT	\N	3	10	5	15	{DUMBBELL,BARBELL,BENCH,KETTLEBELL,CABLE}	8	20	SELF_MANAGED
87	msweeterman24@icloud.com	mIthrdfuyDh1j9NftYhwSsyaCey1	untitledAltTrack 	0	BEGINNER	25	t	t	5	\N	KEEPING_FIT	MALE	152	175.26	LB	CM	\N	3	10	5	15	{DUMBBELL,CABLE,BARBELL,KETTLEBELL,LEVER,SUSPENSION,T_BAR,TRAP_BAR,SLED,SMITH,BENCH,MEDICINE_BALL,PREACHER,PARALLEL_BARS,PULL_UP_BAR}	8	20	SELF_MANAGED
88	marla0217@aol.com	pbnzrlarc6cBzUWyZ79JJUyudN73	MARLA 	7	ADVANCED	62	t	t	6	\N	KEEPING_FIT	FEMALE	131.6	5.3	KG	FT	\N	3	10	5	15	{BARBELL,CABLE,MEDICINE_BALL}	8	20	SELF_MANAGED
89	tatidermeier@gmail.com	l8e4AjsP0VaqidFoawyaW8xaB843	konstantin	5	MID	23	t	t	5	\N	ATHLETICISM	MALE	80	180	KG	CM	\N	3	10	5	15	{DUMBBELL,BENCH,CABLE,T_BAR}	8	20	SELF_MANAGED
50	dionneo123@gmail.com	G92IbMs5S4WYDx0XmeNMgcCLjcz2	neowenshun	1.5	BEGINNER	23	t	t	3	\N	BODY_RECOMPOSITION	MALE	77.5	176.5	KG	CM	\N	4	15	5	15	{DUMBBELL,BARBELL,KETTLEBELL,CABLE}	8	20	SELF_MANAGED
61	sumugz@gmail.com	BqiSLIa5ZghHdcYW1TrzgOQutIr1	sofia	0.5	MID	23	t	t	3	\N	KEEPING_FIT	FEMALE	65	170	KG	CM	\N	3	10	5	15	{DUMBBELL,BENCH,KETTLEBELL,CABLE,MEDICINE_BALL}	8	20	SELF_MANAGED
62	jasonang0210@gmail.com	RyXI3kVLdOPLnMrIKNgUzp3QFM03	jason	0.5	BEGINNER	23	t	t	4	60	BODY_RECOMPOSITION	MALE	75	180	KG	CM	\N	3	12	5	16	{DUMBBELL,BARBELL,BENCH,KETTLEBELL,CABLE}	8	20	SELF_MANAGED
90	hjcranford@gmail.com	dcIkFL27IdgSFYXqDXg2ypmIzTO2	Jay	1	MID	28	t	t	5	\N	STRENGTH	MALE	188	6	LB	FT	\N	3	10	5	15	{DUMBBELL,CABLE}	8	20	SELF_MANAGED
105	weeinthesea@gmail.com	ViaRY29tn8beMONjrhThwzHDOT43	yw	1	MID	22	t	t	4	\N	BODY_RECOMPOSITION	MALE	69.8	170	KG	CM	\N	3	10	5	15	{DUMBBELL,BARBELL,BENCH,PULL_UP_BAR,MEDICINE_BALL,PULL_UP_BAR}	8	20	SELF_MANAGED
91	ravenspearl@gmail.com	e0Fs9e7FOWTROTx1yfhINi5bohC3	Ravenspearl	2	MID	38	t	t	3	\N	STRENGTH	FEMALE	185	174	LB	CM	\N	3	10	5	15	{DUMBBELL,BARBELL,BENCH,KETTLEBELL,PULL_UP_BAR,SUSPENSION}	8	20	SELF_MANAGED
92	jenmakowsky@outlook.com	MQm0BgXafjRq7Bao2EzDW0appHt1	JMakowsky	2	MID	38	t	t	3	\N	STRENGTH	FEMALE	185	175	LB	CM	\N	3	10	5	15	{DUMBBELL,BARBELL,BENCH,KETTLEBELL,PULL_UP_BAR}	8	20	SELF_MANAGED
93	sonicscrewdriver@comcast.net	Xfr1Q6RJyNbHDgBlibpLY0mrMg43	ron74	0	BEGINNER	48	t	t	5	\N	KEEPING_FIT	MALE	175	5.9	LB	FT	\N	3	10	5	15	{DUMBBELL,BENCH,KETTLEBELL,CABLE,LEVER,T_BAR}	8	20	SELF_MANAGED
94	renfredyeow@gmail.com	TcHYPNhTU6f3JsuNbeGvKT1EByE2	Renfredy	3	MID	22	t	t	2	\N	KEEPING_FIT	MALE	66	165	KG	CM	\N	3	10	5	15	{DUMBBELL,BARBELL,BENCH,CABLE,PULL_UP_BAR,MEDICINE_BALL,SMITH}	8	20	SELF_MANAGED
95	tony.200705@gmail.com	60e3NM7SbdbyOzpcFp1BMyS7jkT2	Tony	4	ADVANCED	23	t	t	5	\N	OTHERS	MALE	92	190	KG	CM	\N	3	10	5	15	{DUMBBELL,BARBELL,BENCH,KETTLEBELL,CABLE,SMITH,PREACHER,PULL_UP_BAR,T_BAR}	8	20	SELF_MANAGED
96	trinachuaminxuan@gmail.com	hm1MNjxdHSQWw2UPPm6zQ8jmuFI3	trina	0	BEGINNER	23	t	t	2	\N	KEEPING_FIT	FEMALE	50	166	KG	CM	\N	3	10	5	15	{DUMBBELL}	8	20	SELF_MANAGED
97	amandalowalky@gmail.com	ct4PMTlqFoWuFvnLLiEFecqPUv53	Amanda	6	MID	20	t	t	4	\N	ATHLETICISM	FEMALE	57	164	KG	CM	\N	3	10	5	15	{DUMBBELL,BARBELL,BENCH,KETTLEBELL,CABLE,MEDICINE_BALL,T_BAR,SMITH,STABILITY_BALL,PULL_UP_BAR,PREACHER,TRAP_BAR}	8	20	SELF_MANAGED
98	junweiwang92@gmail.com	tG7m3SCCHwUy9gy6NhJFIo6vmse2	Azre	0	BEGINNER	21	t	t	1	\N	BODY_RECOMPOSITION	MALE	51.5	172	KG	CM	\N	3	10	5	15	{DUMBBELL,BARBELL,BENCH,KETTLEBELL,CABLE}	8	20	SELF_MANAGED
106	vuongthihoai3004@gmail.com	nrq5DyfqcUNCL1oJ0PGdiIAIMfm2	Vuong Hoai	0	BEGINNER	22	t	t	6	\N	OTHERS	FEMALE	43	158	KG	CM	\N	3	10	5	15	{DUMBBELL,BARBELL,BENCH,KETTLEBELL,CABLE}	8	20	SELF_MANAGED
100	melvinleong@hotmail.com	yi9MHQ0RrWZ212XoBImLg6fW7Bo1	melvin	1	MID	23	t	t	5	\N	BODY_RECOMPOSITION	MALE	74	168	KG	CM	\N	3	10	5	15	{DUMBBELL,BARBELL,BENCH,CABLE,PULL_UP_BAR}	8	20	SELF_MANAGED
101	andsaumur@gmail.com	h1CwrZilW5bylbVvMuFKXqv6zaf2	Andreu	5	ADVANCED	28	f	t	3	\N	KEEPING_FIT	MALE	91	191	KG	CM	\N	3	10	5	15	{DUMBBELL,BARBELL,BENCH,KETTLEBELL,CABLE,PULL_UP_BAR,T_BAR,TRAP_BAR,SMITH}	8	20	SELF_MANAGED
102	kaijiewong16@gmail.com	6WRkLyS33RVqLkWiQ4wMWYWKmRH2	kaijie	6	ADVANCED	21	t	t	4	\N	STRENGTH	MALE	110	174.5	KG	CM	\N	3	10	5	15	{DUMBBELL,BARBELL,BENCH,KETTLEBELL,CABLE,T_BAR,TRAP_BAR,SMITH,PARALLEL_BARS,PULL_UP_BAR,STABILITY_BALL}	8	20	SELF_MANAGED
99	ang_yixuan@hotmail.com	eQaIyOfiM0eoGdLN1nujc5lxTU82	yixuan	4	ADVANCED	22	t	t	2	\N	ATHLETICISM	FEMALE	58	162.7	KG	CM	\N	3	10	5	15	{DUMBBELL,BARBELL,BENCH,CABLE,PULL_UP_BAR,KETTLEBELL}	8	20	SELF_MANAGED
103	a0972236805@gmail.com	7OHR22IdbbTZHm49mz4YEBvbwZ13	Ariel 	1	MID	27	f	t	3	\N	BODY_RECOMPOSITION	FEMALE	51	163	KG	CM	\N	3	10	5	15	{DUMBBELL,BENCH,CABLE}	8	20	SELF_MANAGED
104	basak20021974@gmail.com	bYp2u4SjdCYyJkTG5vxtLfC0q5h1	teesha	3	MID	20	t	t	4	\N	BODY_RECOMPOSITION	FEMALE	55	164	KG	CM	\N	3	10	5	15	{DUMBBELL,BARBELL,BENCH,KETTLEBELL,CABLE,SMITH,PULL_UP_BAR,STABILITY_BALL,PREACHER,LEVER}	8	20	SELF_MANAGED
107	donovangng@gmail.com	3XCvsfo1dBUSic6Kt5GEIiV9ods2	Donovanny	2	ADVANCED	23	t	t	5	\N	ATHLETICISM	MALE	80	188	KG	CM	\N	3	10	5	15	{DUMBBELL,BARBELL,BENCH,KETTLEBELL,CABLE}	8	20	SELF_MANAGED
110	derrenwinata1727@gmail.com	yEBXNQA75yYGOMhgntrI5FVy5PB3	darderrdur	0.16	MID	17	t	t	3	\N	KEEPING_FIT	MALE	98	182	KG	CM	\N	3	10	5	15	{DUMBBELL,BARBELL,BENCH,CABLE}	8	20	SELF_MANAGED
\.


--
-- Data for Name: Workout; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Workout" (workout_id, workout_name, life_span, order_index, date_scheduled, date_completed, performance_rating, user_id, workout_state, workout_type) FROM stdin;
302	Charming Canary	12	0	\N	\N	\N	61	UNATTEMPTED	SELF_MANAGED
361	Kind King-fisher	12	0	\N	\N	\N	75	UNATTEMPTED	SELF_MANAGED
268	Charming Canary	11	0	\N	2022-08-12 07:38:04.62	5	50	UNATTEMPTED	SELF_MANAGED
397	pull	29	0	\N	2022-09-07 06:21:40.919	3	62	COMPLETED	SELF_MANAGED
403	push	29	1	\N	2022-09-05 16:40:34.841	3	62	COMPLETED	SELF_MANAGED
362	Elated Eagle	12	1	\N	\N	\N	75	UNATTEMPTED	SELF_MANAGED
265	Seagull	12	0	\N	\N	\N	53	UNATTEMPTED	SELF_MANAGED
266	Ominous Owl	12	1	\N	\N	\N	53	UNATTEMPTED	SELF_MANAGED
267	Charming Canary	12	2	\N	\N	\N	53	UNATTEMPTED	SELF_MANAGED
430	Charming Canary	12	0	\N	\N	\N	82	UNATTEMPTED	SELF_MANAGED
363	Peaceful Parakeet	12	2	\N	\N	\N	75	UNATTEMPTED	SELF_MANAGED
364	Crazy Cuckoo	12	3	\N	\N	\N	75	UNATTEMPTED	SELF_MANAGED
270	Seagull	12	0	\N	\N	\N	54	UNATTEMPTED	SELF_MANAGED
271	Sexy Sparrow	12	1	\N	\N	\N	54	UNATTEMPTED	SELF_MANAGED
272	Kind King-fisher	12	2	\N	\N	\N	54	UNATTEMPTED	SELF_MANAGED
431	Odd Osprey	12	1	\N	\N	\N	82	UNATTEMPTED	SELF_MANAGED
432	Perky Pigeon	12	2	\N	\N	\N	82	UNATTEMPTED	SELF_MANAGED
433	Kind King-fisher	12	3	\N	\N	\N	82	UNATTEMPTED	SELF_MANAGED
441	Seagull	12	1	\N	\N	\N	86	UNATTEMPTED	SELF_MANAGED
303	Crazy Cuckoo	12	1	\N	\N	\N	61	UNATTEMPTED	SELF_MANAGED
304	Peaceful Parakeet	12	2	\N	\N	\N	61	UNATTEMPTED	SELF_MANAGED
305	Charming Canary	12	3	\N	\N	\N	61	UNATTEMPTED	SELF_MANAGED
264	Seagull	11	0	\N	2022-08-08 16:35:47.579	5	50	UNATTEMPTED	SELF_MANAGED
518	push	26	2	\N	\N	\N	62	UNATTEMPTED	SELF_MANAGED
528	Deadlift	3	5	\N	\N	\N	92	UNATTEMPTED	SELF_MANAGED
369	Sexy Sparrow	12	0	\N	\N	\N	64	UNATTEMPTED	SELF_MANAGED
284	Elated Eagle	12	0	\N	\N	\N	59	UNATTEMPTED	SELF_MANAGED
702	Peaceful Parakeet	12	0	\N	\N	\N	47	UNATTEMPTED	AI_MANAGED
703	Wacky Woodpecker	12	1	\N	\N	\N	47	UNATTEMPTED	AI_MANAGED
705	Seagull	12	3	\N	\N	\N	47	UNATTEMPTED	AI_MANAGED
370	Ominous Owl	12	1	\N	\N	\N	64	UNATTEMPTED	SELF_MANAGED
394	Chest Day	29	2	\N	\N	\N	64	UNATTEMPTED	SELF_MANAGED
398	Core Day	29	3	\N	\N	\N	64	UNATTEMPTED	SELF_MANAGED
280	Wacky Woodpecker	12	0	\N	\N	\N	57	UNATTEMPTED	SELF_MANAGED
281	Dangerous Dove	12	1	\N	\N	\N	57	UNATTEMPTED	SELF_MANAGED
282	Perky Pigeon	12	2	\N	\N	\N	57	UNATTEMPTED	SELF_MANAGED
283	Elated Eagle	12	3	\N	\N	\N	57	UNATTEMPTED	SELF_MANAGED
285	Crazy Cuckoo	12	1	\N	\N	\N	59	UNATTEMPTED	SELF_MANAGED
286	Odd Osprey	12	2	\N	\N	\N	59	UNATTEMPTED	SELF_MANAGED
287	Elated Eagle	12	3	\N	\N	\N	59	UNATTEMPTED	SELF_MANAGED
288	Seagull	12	3	\N	\N	\N	59	UNATTEMPTED	SELF_MANAGED
289	Crazy Cuckoo	12	5	\N	\N	\N	59	UNATTEMPTED	SELF_MANAGED
290	Wacky Woodpecker	12	5	\N	\N	\N	59	UNATTEMPTED	SELF_MANAGED
291	Peaceful Parakeet	12	7	\N	\N	\N	59	UNATTEMPTED	SELF_MANAGED
292	Charming Canary	12	7	\N	\N	\N	59	UNATTEMPTED	SELF_MANAGED
293	Odd Osprey	12	9	\N	\N	\N	59	UNATTEMPTED	SELF_MANAGED
294	Kind King-fisher	12	9	\N	\N	\N	59	UNATTEMPTED	SELF_MANAGED
295	Sexy Sparrow	12	10	\N	\N	\N	59	UNATTEMPTED	SELF_MANAGED
296	Dangerous Dove	12	12	\N	\N	\N	59	UNATTEMPTED	SELF_MANAGED
297	Seagull	12	13	\N	\N	\N	59	UNATTEMPTED	SELF_MANAGED
440	Wacky Woodpecker	12	0	\N	\N	\N	86	IN_PROGRESS	SELF_MANAGED
306	Dangerous Dove	12	0	\N	\N	\N	63	UNATTEMPTED	SELF_MANAGED
307	Wacky Woodpecker	12	1	\N	\N	\N	63	UNATTEMPTED	SELF_MANAGED
308	Perky Pigeon	12	2	\N	\N	\N	63	UNATTEMPTED	SELF_MANAGED
312	Legs	5	3	\N	\N	\N	63	UNATTEMPTED	SELF_MANAGED
298	Ominous Owl	12	1	\N	\N	\N	60	UNATTEMPTED	SELF_MANAGED
299	Wacky Woodpecker	12	1	\N	\N	\N	60	UNATTEMPTED	SELF_MANAGED
389	Seagull	8	0	\N	2022-09-18 16:15:43.874	5	50	COMPLETED	SELF_MANAGED
340	Elated Eagle	12	0	\N	\N	\N	69	UNATTEMPTED	SELF_MANAGED
341	Charming Canary	12	1	\N	\N	\N	69	UNATTEMPTED	SELF_MANAGED
342	Wacky Woodpecker	12	2	\N	\N	\N	69	UNATTEMPTED	SELF_MANAGED
343	Crazy Cuckoo	12	3	\N	\N	\N	69	UNATTEMPTED	SELF_MANAGED
344	Peaceful Parakeet	12	4	\N	\N	\N	69	UNATTEMPTED	SELF_MANAGED
345	Dangerous Dove	12	5	\N	\N	\N	69	UNATTEMPTED	SELF_MANAGED
346	Ominous Owl	12	6	\N	\N	\N	69	UNATTEMPTED	SELF_MANAGED
347	Crazy Cuckoo	12	0	\N	\N	\N	70	UNATTEMPTED	SELF_MANAGED
348	Elated Eagle	12	1	\N	\N	\N	70	UNATTEMPTED	SELF_MANAGED
349	Dangerous Dove	12	2	\N	\N	\N	70	UNATTEMPTED	SELF_MANAGED
350	Kind King-fisher	12	0	\N	\N	\N	71	UNATTEMPTED	SELF_MANAGED
351	Seagull	12	1	\N	\N	\N	71	UNATTEMPTED	SELF_MANAGED
352	Odd Osprey	12	2	\N	\N	\N	71	UNATTEMPTED	SELF_MANAGED
353	Dangerous Dove	12	0	\N	\N	\N	72	UNATTEMPTED	SELF_MANAGED
354	Ominous Owl	12	1	\N	\N	\N	72	UNATTEMPTED	SELF_MANAGED
355	Sexy Sparrow	12	2	\N	\N	\N	72	UNATTEMPTED	SELF_MANAGED
357	test	11	0	\N	\N	\N	73	UNATTEMPTED	SELF_MANAGED
356	test	12	0	\N	2022-08-13 18:35:07.95	5	73	UNATTEMPTED	SELF_MANAGED
358	Wacky Woodpecker	12	0	\N	\N	\N	74	UNATTEMPTED	SELF_MANAGED
359	Crazy Cuckoo	12	1	\N	\N	\N	74	UNATTEMPTED	SELF_MANAGED
360	Dangerous Dove	12	2	\N	\N	\N	74	UNATTEMPTED	SELF_MANAGED
385	Seagull	12	3	\N	\N	\N	77	UNATTEMPTED	SELF_MANAGED
386	Kind King-fisher	12	4	\N	\N	\N	77	UNATTEMPTED	SELF_MANAGED
274	Seagull	10	0	\N	2022-08-20 12:04:36.919	4	50	UNATTEMPTED	SELF_MANAGED
405	leg	29	0	\N	\N	\N	62	UNATTEMPTED	SELF_MANAGED
526	pull	26	3	\N	\N	\N	62	UNATTEMPTED	SELF_MANAGED
273	Dangerous Dove	11	0	\N	2022-08-18 10:05:39.22	5	50	UNATTEMPTED	SELF_MANAGED
373	Charming Canary	12	0	\N	\N	\N	78	UNATTEMPTED	SELF_MANAGED
374	Ominous Owl	12	1	\N	\N	\N	78	UNATTEMPTED	SELF_MANAGED
375	Crazy Cuckoo	12	2	\N	\N	\N	78	UNATTEMPTED	SELF_MANAGED
376	Peaceful Parakeet	12	3	\N	\N	\N	78	UNATTEMPTED	SELF_MANAGED
371	Seagull	9	0	\N	2022-08-29 13:34:04.815	5	50	COMPLETED	SELF_MANAGED
313	Charming Canary	10	0	\N	2022-08-23 13:40:29.221	5	50	UNATTEMPTED	SELF_MANAGED
382	Ominous Owl	12	0	\N	\N	\N	77	UNATTEMPTED	SELF_MANAGED
383	Odd Osprey	12	1	\N	\N	\N	77	UNATTEMPTED	SELF_MANAGED
384	Crazy Cuckoo	12	2	\N	\N	\N	77	UNATTEMPTED	SELF_MANAGED
391	pull	30	0	\N	2022-08-30 16:06:08.889	3	62	COMPLETED	SELF_MANAGED
367	Dangerous Dove	10	0	\N	2022-08-25 15:41:10.701	5	50	UNATTEMPTED	SELF_MANAGED
380	Charming Canary	9	0	\N	2022-08-30 15:14:19.456	1	50	COMPLETED	SELF_MANAGED
372	Monday 22 Aug	30	3	\N	2022-08-30 15:26:37.817	3	64	COMPLETED	SELF_MANAGED
400	Sexy Sparrow	12	0	\N	\N	\N	51	UNATTEMPTED	SELF_MANAGED
395	Core Day	30	4	\N	2022-08-31 06:45:49.098	\N	64	COMPLETED	SELF_MANAGED
401	Dangerous Dove	12	1	\N	\N	\N	51	UNATTEMPTED	SELF_MANAGED
402	Odd Osprey	12	2	\N	\N	\N	51	UNATTEMPTED	SELF_MANAGED
390	push	30	0	\N	2022-09-01 16:19:44.022	3	62	COMPLETED	SELF_MANAGED
404	leg	30	2	\N	2022-09-02 16:31:53.425	3	62	COMPLETED	SELF_MANAGED
434	Odd Osprey	12	0	\N	\N	\N	84	UNATTEMPTED	SELF_MANAGED
435	Charming Canary	12	1	\N	\N	\N	84	UNATTEMPTED	SELF_MANAGED
436	Perky Pigeon	12	2	\N	\N	\N	84	UNATTEMPTED	SELF_MANAGED
442	Perky Pigeon	12	2	\N	\N	\N	86	UNATTEMPTED	SELF_MANAGED
452	Sexy Sparrow	12	0	\N	\N	\N	88	UNATTEMPTED	SELF_MANAGED
453	Peaceful Parakeet	12	1	\N	\N	\N	88	UNATTEMPTED	SELF_MANAGED
454	Kind King-fisher	12	2	\N	\N	\N	88	UNATTEMPTED	SELF_MANAGED
455	Elated Eagle	12	3	\N	\N	\N	88	UNATTEMPTED	SELF_MANAGED
456	Seagull	12	4	\N	\N	\N	88	UNATTEMPTED	SELF_MANAGED
477	push	27	2	\N	2022-09-19 04:46:29.767	3	62	COMPLETED	SELF_MANAGED
457	Charming Canary	12	4	\N	\N	\N	61	UNATTEMPTED	SELF_MANAGED
459	Kind King-fisher	12	6	\N	\N	\N	61	UNATTEMPTED	SELF_MANAGED
458	Perky Pigeon	12	5	\N	\N	\N	61	UNATTEMPTED	SELF_MANAGED
427	push	28	1	\N	2022-09-10 05:32:13.171	3	62	COMPLETED	SELF_MANAGED
479	Ominous Owl	12	1	\N	\N	\N	96	UNATTEMPTED	SELF_MANAGED
478	Elated Eagle	12	0	\N	\N	\N	96	IN_PROGRESS	SELF_MANAGED
467	core	29	1	\N	\N	\N	62	UNATTEMPTED	SELF_MANAGED
462	Dangerous Dove	12	1	\N	\N	\N	92	UNATTEMPTED	SELF_MANAGED
484	pull	27	2	\N	2022-09-20 09:56:53.523	3	62	COMPLETED	SELF_MANAGED
531	Dangerous Dove	12	1	\N	\N	\N	58	UNATTEMPTED	SELF_MANAGED
463	Perky Pigeon	12	2	\N	\N	\N	92	UNATTEMPTED	SELF_MANAGED
461	Wacky Woodpecker	12	0	\N	\N	\N	92	UNATTEMPTED	SELF_MANAGED
465	pull	28	1	\N	2022-09-11 08:14:34.211	3	62	COMPLETED	SELF_MANAGED
485	Kind King-fisher	12	0	\N	\N	\N	98	UNATTEMPTED	SELF_MANAGED
700	Ominous Owl	12	0	\N	2022-09-28 10:37:00.553	3	49	COMPLETED	SELF_MANAGED
393	Charming Canary	8	0	\N	2022-09-12 12:49:39.59	5	50	COMPLETED	SELF_MANAGED
704	Charming Canary	12	2	\N	\N	\N	47	UNATTEMPTED	AI_MANAGED
493	Kind King-fisher	12	0	\N	\N	\N	102	UNATTEMPTED	SELF_MANAGED
494	Odd Osprey	12	1	\N	\N	\N	102	UNATTEMPTED	SELF_MANAGED
495	Crazy Cuckoo	12	2	\N	\N	\N	102	UNATTEMPTED	SELF_MANAGED
499	Peaceful Parakeet	11	3	\N	\N	\N	102	UNATTEMPTED	SELF_MANAGED
492	Peaceful Parakeet	12	0	\N	2022-09-14 06:43:26.496	5	102	COMPLETED	SELF_MANAGED
387	Dangerous Dove	9	0	\N	2022-09-08 15:50:47.084	3.5	50	COMPLETED	SELF_MANAGED
476	leg + back	30	4	\N	\N	\N	64	IN_PROGRESS	SELF_MANAGED
602	Routine 2	12	1	\N	\N	\N	50	UNATTEMPTED	SELF_MANAGED
473	Dangerous Dove	8	0	\N	2022-09-15 17:36:04.847	5	50	COMPLETED	SELF_MANAGED
514	Crazy Cuckoo	12	1	\N	\N	\N	105	UNATTEMPTED	SELF_MANAGED
515	Kind King-fisher	12	2	\N	\N	\N	105	UNATTEMPTED	SELF_MANAGED
516	Elated Eagle	12	3	\N	\N	\N	105	UNATTEMPTED	SELF_MANAGED
513	Sexy Sparrow	12	0	\N	\N	\N	105	UNATTEMPTED	SELF_MANAGED
600	Routine 1	12	2	\N	\N	\N	50	UNATTEMPTED	SELF_MANAGED
610	Charming Canary	12	0	\N	\N	\N	47	UNATTEMPTED	SELF_MANAGED
611	Seagull	12	1	\N	\N	\N	47	UNATTEMPTED	SELF_MANAGED
614	Perky Pigeon	12	4	\N	\N	\N	47	UNATTEMPTED	SELF_MANAGED
601	Routine 2	12	0	\N	\N	\N	50	UNATTEMPTED	SELF_MANAGED
480	Elated Eagle	12	0	\N	\N	\N	97	UNATTEMPTED	SELF_MANAGED
481	Wacky Woodpecker	12	1	\N	\N	\N	97	UNATTEMPTED	SELF_MANAGED
482	Perky Pigeon	12	2	\N	\N	\N	97	UNATTEMPTED	SELF_MANAGED
483	Peaceful Parakeet	12	3	\N	\N	\N	97	UNATTEMPTED	SELF_MANAGED
603	Peaceful Parakeet	12	0	\N	2022-09-25 13:35:05.146	3	47	COMPLETED	SELF_MANAGED
489	Dangerous Dove	12	0	\N	\N	\N	99	UNATTEMPTED	SELF_MANAGED
527	Deadlift	3	4	\N	\N	\N	92	UNATTEMPTED	SELF_MANAGED
428	Peaceful Parakeet	12	0	\N	\N	\N	83	UNATTEMPTED	SELF_MANAGED
429	Seagull	12	1	\N	\N	\N	83	UNATTEMPTED	SELF_MANAGED
438	Charming Canary	12	1	\N	\N	\N	85	UNATTEMPTED	SELF_MANAGED
439	Dangerous Dove	12	2	\N	\N	\N	85	UNATTEMPTED	SELF_MANAGED
437	Sexy Sparrow	12	0	\N	\N	\N	85	IN_PROGRESS	SELF_MANAGED
443	Ominous Owl	12	3	\N	\N	\N	72	UNATTEMPTED	SELF_MANAGED
444	Crazy Cuckoo	12	4	\N	\N	\N	72	UNATTEMPTED	SELF_MANAGED
445	Dangerous Dove	12	5	\N	\N	\N	72	UNATTEMPTED	SELF_MANAGED
447	Crazy Cuckoo	12	1	\N	\N	\N	87	UNATTEMPTED	SELF_MANAGED
448	Wacky Woodpecker	12	2	\N	\N	\N	87	UNATTEMPTED	SELF_MANAGED
449	Dangerous Dove	12	3	\N	\N	\N	87	UNATTEMPTED	SELF_MANAGED
450	Ominous Owl	12	4	\N	\N	\N	87	UNATTEMPTED	SELF_MANAGED
490	Odd Osprey	12	1	\N	\N	\N	99	UNATTEMPTED	SELF_MANAGED
446	Sexy Sparrow	12	0	\N	\N	\N	87	UNATTEMPTED	SELF_MANAGED
464	Dead Lift	6	3	\N	\N	\N	92	UNATTEMPTED	SELF_MANAGED
466	core	30	3	\N	2022-09-07 14:39:34.409	3	62	COMPLETED	SELF_MANAGED
468	Wacky Woodpecker	12	0	\N	\N	\N	93	UNATTEMPTED	SELF_MANAGED
469	Odd Osprey	12	1	\N	\N	\N	93	UNATTEMPTED	SELF_MANAGED
470	Dangerous Dove	12	2	\N	\N	\N	93	UNATTEMPTED	SELF_MANAGED
471	Sexy Sparrow	12	3	\N	\N	\N	93	UNATTEMPTED	SELF_MANAGED
472	Seagull	12	4	\N	\N	\N	93	UNATTEMPTED	SELF_MANAGED
474	Sexy Sparrow	12	0	\N	\N	\N	94	UNATTEMPTED	SELF_MANAGED
475	Kind King-fisher	12	1	\N	\N	\N	94	UNATTEMPTED	SELF_MANAGED
497	Dangerous Dove	12	0	\N	\N	\N	103	UNATTEMPTED	SELF_MANAGED
498	Perky Pigeon	12	1	\N	\N	\N	103	UNATTEMPTED	SELF_MANAGED
500	Sexy Sparrow	12	0	\N	\N	\N	104	UNATTEMPTED	SELF_MANAGED
501	Kind King-fisher	12	1	\N	\N	\N	104	UNATTEMPTED	SELF_MANAGED
502	Perky Pigeon	12	2	\N	\N	\N	104	UNATTEMPTED	SELF_MANAGED
503	Charming Canary	12	3	\N	\N	\N	104	UNATTEMPTED	SELF_MANAGED
701	Ominous Owl	11	0	\N	\N	\N	49	UNATTEMPTED	SELF_MANAGED
532	Perky Pigeon	12	2	\N	\N	\N	58	UNATTEMPTED	SELF_MANAGED
572	Wacky Woodpecker	12	0	\N	2022-09-25 19:09:24.152	3	107	COMPLETED	SELF_MANAGED
530	Wacky Woodpecker	12	0	\N	\N	\N	58	UNATTEMPTED	SELF_MANAGED
505	Dangerous Dove	7	0	\N	2022-09-24 15:00:24.771	5	50	COMPLETED	SELF_MANAGED
488	Charming Canary	7	0	\N	2022-09-21 16:46:14.505	5	50	COMPLETED	SELF_MANAGED
706	Kind King-fisher	12	4	\N	\N	\N	47	UNATTEMPTED	AI_MANAGED
612	Peaceful Parakeet	12	2	\N	\N	\N	47	UNATTEMPTED	SELF_MANAGED
613	Wacky Woodpecker	12	3	\N	\N	\N	47	UNATTEMPTED	SELF_MANAGED
615	Elated Eagle	12	5	\N	\N	\N	47	UNATTEMPTED	SELF_MANAGED
\.


--
-- Data for Name: _BroadCastToUser; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."_BroadCastToUser" ("A", "B") FROM stdin;
\.


--
-- Data for Name: _dynamic; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public._dynamic ("A", "B") FROM stdin;
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
6af15228-21be-4db3-941d-c6f7ddae0594	ca4ac8a0ffdb4f8eeed67230e57146a00433d5e43669e5d117e28a01557b8831	2022-08-01 09:31:31.891393+00	20220801093131_init	\N	\N	2022-08-01 09:31:31.77093+00	1
1c804b2b-30be-46b6-8b38-8eb9bbc97248	10beb440c88e430a7f4a8f4fe4a647a70cae88e9b3202a93d7935720f076553b	2022-08-07 06:39:00.757349+00	20220807063900_added_new_equipment_enums	\N	\N	2022-08-07 06:39:00.718679+00	1
c56864c8-f4ae-4f18-b220-ecd2ba637263	5f5f5ff3f7e7ca3589f493b1b78e51fb41dad031c34098a491f7492e0e9f0742	2022-08-08 16:55:12.081484+00	20220808165511_add_cascade_on_exercisemetadata	\N	\N	2022-08-08 16:55:12.042122+00	1
2598418c-781e-4a41-a3c0-fa99d8474322	d7f1bac2f413c735dcb16815c10aa4dc12b529c5ce950ec039197a9199f19592	2022-08-13 09:08:52.377267+00	20220813090852_support_body_weight	\N	\N	2022-08-13 09:08:52.318537+00	1
8b434b4d-4ab0-424b-acfb-618f3d04d54b	1fece327394752ab277f040c16d73203d7d9bd08f08d9bc00c996a0baa67cc5f	2022-08-15 08:30:19.766018+00	20220815083019_cascade_delete_of_workouts	\N	\N	2022-08-15 08:30:19.720328+00	1
1771c2d5-cd13-42f9-96b7-d45c43179374	a098975b0b392239619e7bcd72bc289c661822788acca9c94be842fe1754bdcc	2022-08-15 08:30:56.929383+00	20220815083056_cascade_delete_of_exercisemetadata	\N	\N	2022-08-15 08:30:56.890399+00	1
ea56a309-8400-44ad-94e6-3e11e567d622	b82656bcb8f4a09ebd40f683634ff0dfdd1d96a3dc991e6f1cfa2cac31bf0b5e	2022-08-18 09:20:25.50429+00	20220817100648_add_failure_reason	\N	\N	2022-08-18 09:20:25.463367+00	1
b2fa30ac-e95c-420e-a0db-c2565174e2b7	a3df26fc2cf972cb5c5135750a5b0107e28235bfb6654a9c4d24d80a197722d2	2022-08-18 09:20:25.557668+00	20220818041043_change_failure_reason_to_reside_in_exercisesetgroup	\N	\N	2022-08-18 09:20:25.519446+00	1
3c7c4ba5-3086-497e-853f-7589ed5b20ce	549e8fcf6a63005a75b4af8d801809217068cae25dac2306970b845bc75d970b	2022-08-23 17:22:28.190335+00	20220823172227_cascade_exercise_delete	\N	\N	2022-08-23 17:22:28.152094+00	1
42d47d9e-11ea-45a2-a8cd-e2f91d42b2cc	06d6d2ea778459df8b242187680fb3eb3f1fae0b4b5e5488f561e75f223d528e	\N	20220823191735_remove_machine	\N	2022-08-26 10:17:38.968863+00	2022-08-23 19:17:35.641668+00	0
9973ea00-ff3d-4985-a2f9-88197f389019	06d6d2ea778459df8b242187680fb3eb3f1fae0b4b5e5488f561e75f223d528e	2022-08-26 10:17:54.309151+00	20220823191735_remove_machine	\N	\N	2022-08-26 10:17:54.212919+00	1
875bd727-d232-4b20-a717-6fe708b49964	5cfeb3b963e0e0f52247442e6414ea68287dd4012dc4fab072673ae379cb45d2	2022-08-28 20:03:37.330903+00	20220826101852_add_support_for_workout_states	\N	\N	2022-08-28 20:03:37.290579+00	1
3507c749-9021-43b1-9a44-f8511b141f0d	2f6c730e69ffa735a7a2fdd28e062721dcfee706180f366be25f64913dc93713	2022-09-29 19:19:08.451757+00	20220928185930_support_workout_seggregation	\N	\N	2022-09-29 19:19:08.39684+00	1
\.


--
-- Data for Name: _stabilizer; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public._stabilizer ("A", "B") FROM stdin;
Weighted Bench Dip	33
Weighted Close Grip Push-up	6
Barbell Lying Triceps Extension	10
Barbell Lying Triceps Extension	12
Barbell Lying Triceps Extension	23
Barbell Lying Triceps Extension	27
Barbell Lying Triceps Extension	28
Barbell Lying Triceps Extension	29
Barbell Lying Triceps Extension	40
Barbell Decline Triceps Extension	10
Barbell Decline Triceps Extension	12
Barbell Decline Triceps Extension	23
Barbell Decline Triceps Extension	28
Barbell Decline Triceps Extension	29
Barbell Decline Triceps Extension	40
Barbell Incline Triceps Extension	10
Barbell Incline Triceps Extension	12
Barbell Incline Triceps Extension	23
Barbell Incline Triceps Extension	27
Barbell Incline Triceps Extension	29
Barbell Incline Triceps Extension	40
Barbell Lying Triceps Extension "Skull Crusher"	10
Barbell Lying Triceps Extension "Skull Crusher"	12
Barbell Lying Triceps Extension "Skull Crusher"	23
Barbell Lying Triceps Extension "Skull Crusher"	27
Barbell Lying Triceps Extension "Skull Crusher"	28
Barbell Lying Triceps Extension "Skull Crusher"	29
Barbell Lying Triceps Extension "Skull Crusher"	40
Barbell Triceps Extension	10
Barbell Triceps Extension	27
Barbell Triceps Extension	40
Barbell Reclined Triceps Extension	10
Barbell Reclined Triceps Extension	27
Barbell Reclined Triceps Extension	40
Cable Bar Bent-over Triceps Extension	10
Cable Bar Bent-over Triceps Extension	25
Cable Bar Bent-over Triceps Extension	27
Cable Bar Bent-over Triceps Extension	40
Cable Bar Bent-over Triceps Extension	44
Cable Incline Triceps Extension	10
Cable Incline Triceps Extension	12
Cable Incline Triceps Extension	23
Cable Incline Triceps Extension	27
Cable Incline Triceps Extension	28
Cable Incline Triceps Extension	29
Cable Incline Triceps Extension	40
Cable Lying Triceps Extension	10
Cable Lying Triceps Extension	12
Cable Lying Triceps Extension	23
Cable Lying Triceps Extension	27
Cable Lying Triceps Extension	28
Cable Lying Triceps Extension	29
Cable Lying Triceps Extension	40
Cable Bar Lying Triceps Extension	10
Cable Bar Lying Triceps Extension	12
Cable Bar Lying Triceps Extension	23
Cable Bar Lying Triceps Extension	27
Cable Bar Lying Triceps Extension	28
Cable Bar Lying Triceps Extension	29
Cable Bar Lying Triceps Extension	40
Cable Decline Triceps Extension	10
Cable Decline Triceps Extension	12
Cable Decline Triceps Extension	23
Cable Decline Triceps Extension	27
Cable Decline Triceps Extension	28
Cable Decline Triceps Extension	29
Cable Decline Triceps Extension	40
Cable Pushdown	12
Cable Pushdown	23
Cable Pushdown	25
Cable Pushdown	28
Cable Pushdown	29
Cable Pushdown	33
Cable Pushdown	40
Cable Pushdown	41
Cable Pushdown	44
Cable Alternating Seated Pushdown	12
Cable Alternating Seated Pushdown	23
Cable Alternating Seated Pushdown	28
Cable Alternating Seated Pushdown	29
Cable Alternating Seated Pushdown	33
Cable Alternating Seated Pushdown	40
Cable Alternating Seated Pushdown	41
Cable Bar Pushdown	12
Cable Bar Pushdown	23
Cable Bar Pushdown	25
Cable Bar Pushdown	28
Cable Bar Pushdown	29
Cable Bar Pushdown	33
Cable Bar Pushdown	40
Cable Bar Pushdown	41
Cable Bar Pushdown	44
Cable Pushdown (forward leaning)	12
Cable Pushdown (forward leaning)	23
Cable Pushdown (forward leaning)	25
Cable Pushdown (forward leaning)	28
Cable Pushdown (forward leaning)	29
Cable Pushdown (forward leaning)	33
Cable Pushdown (forward leaning)	40
Cable Pushdown (forward leaning)	41
Cable Pushdown (forward leaning)	44
Cable Incline Pushdown	12
Cable Incline Pushdown	23
Cable Incline Pushdown	28
Cable Incline Pushdown	29
Cable Incline Pushdown	33
Cable Incline Pushdown	40
Cable Incline Pushdown	41
Cable One Arm Pushdown	12
Cable One Arm Pushdown	23
Cable One Arm Pushdown	25
Cable One Arm Pushdown	28
Weighted Close Grip Push-up	25
Weighted Close Grip Push-up	44
Weighted Triceps Dip	33
Weighted Inverted Row	14
Weighted Inverted Row	16
Weighted Inverted Row	20
Weighted Chest Dip	33
Weighted Push-up	6
Weighted Push-up	25
Weighted Push-up	41
Weighted Push-up	44
Weighted Push-up	47
Cable One Arm Pushdown	29
Cable One Arm Pushdown	33
Cable One Arm Pushdown	39
Cable One Arm Pushdown	41
Cable One Arm Pushdown	44
Weighted Reverse Hyper-extension	14
Weighted Single Leg Squat	17
Weighted Single Leg Squat	18
Weighted Single Leg Squat	25
Weighted Single Leg Squat	43
Weighted Single Leg Squat	44
Weighted Lying Hip Abduction	2
Weighted Hanging Leg Raise	25
Weighted Hanging Leg Raise	44
Weighted Hanging Straight Leg Raise	6
Cable Side Triceps Extension	23
Cable Side Triceps Extension	25
Cable Side Triceps Extension	27
Cable Side Triceps Extension	29
Cable Side Triceps Extension	39
Cable Side Triceps Extension	41
Cable Side Triceps Extension	43
Cable Side Triceps Extension	56
Cable Side Triceps Extension	57
Cable Side Triceps Extension	58
Cable Triceps Dip	33
Cable Triceps Extension	10
Cable Triceps Extension	27
Cable Triceps Extension	40
Cable One Arm Triceps Extension (pronated grip)	40
Cable One Arm Triceps Extension (supinated grip)	39
Weighted Hanging Straight Leg Raise	25
Weighted Hanging Straight Leg Raise	44
Weighted Incline Leg Raise	6
Dumbbell Kickback	12
Dumbbell Kickback	23
Dumbbell Kickback	33
Dumbbell Kickback	34
Dumbbell Kickback	39
Dumbbell Kickback	40
Dumbbell Kickback	45
Dumbbell Lying Triceps Extension	10
Dumbbell Lying Triceps Extension	12
Dumbbell Lying Triceps Extension	23
Dumbbell Lying Triceps Extension	27
Dumbbell Lying Triceps Extension	28
Dumbbell Lying Triceps Extension	29
Dumbbell Lying Triceps Extension	39
Dumbbell Lying Triceps Extension	40
Dumbbell Decline Triceps Extension	10
Dumbbell Decline Triceps Extension	12
Dumbbell Decline Triceps Extension	23
Dumbbell Decline Triceps Extension	28
Dumbbell Decline Triceps Extension	29
Dumbbell Decline Triceps Extension	39
Dumbbell Decline Triceps Extension	40
Dumbbell Incline Triceps Extension	10
Dumbbell Incline Triceps Extension	12
Dumbbell Incline Triceps Extension	23
Dumbbell Incline Triceps Extension	27
Dumbbell Incline Triceps Extension	28
Dumbbell Incline Triceps Extension	29
Dumbbell Incline Triceps Extension	39
Dumbbell Incline Triceps Extension	40
Dumbbell One Arm Triceps Extension	39
Dumbbell One Arm Triceps Extension	40
Dumbbell One Arm Reclined Triceps Extension	39
Dumbbell One Arm Reclined Triceps Extension	40
Dumbbell Triceps Extension	10
Dumbbell Triceps Extension	27
Dumbbell Triceps Extension	40
Dumbbell Reclined Triceps Extension	10
Dumbbell Reclined Triceps Extension	27
Dumbbell Reclined Triceps Extension	40
Weighted Incline Leg Raise	12
Weighted Incline Leg Raise	23
Weighted Incline Leg Raise	25
Weighted Incline Leg Raise	28
Weighted Incline Leg Raise	29
Weighted Incline Leg Raise	38
Weighted Incline Leg Raise	44
Lever Incline Triceps Extension	27
Lever Incline Triceps Extension	39
Lever Incline Triceps Extension	40
Lever Overhead Triceps Extension	10
Lever Overhead Triceps Extension	40
Lever Pushdown	12
Lever Pushdown	23
Lever Pushdown	28
Lever Pushdown	29
Lever Pushdown	33
Lever Pushdown	39
Lever Pushdown	40
Lever Pushdown	41
Lever Triceps Dip	33
Lever Overhand Triceps Dip	33
Sled Standing Triceps Dip	33
Weighted Incline Straight Leg Raise	6
Weighted Incline Straight Leg Raise	12
Weighted Incline Straight Leg Raise	23
Bench Dip	33
Weighted Incline Straight Leg Raise	25
Weighted Incline Straight Leg Raise	28
Close Grip Push-up	6
Close Grip Push-up	25
Close Grip Push-up	41
Close Grip Push-up	44
Close Grip Push-up	47
Close Grip Decline Pushup	6
Close Grip Decline Pushup	25
Close Grip Decline Pushup	44
Weighted Incline Straight Leg Raise	29
Weighted Incline Straight Leg Raise	38
Weighted Incline Straight Leg Raise	44
Triceps Dip	33
Weighted Lying Leg Raise	6
Weighted Lying Leg Raise	25
Suspended Triceps Dip	33
Weighted Lying Leg Raise	44
Suspended Triceps Extension	6
Suspended Triceps Extension	12
Suspended Triceps Extension	15
Suspended Triceps Extension	23
Suspended Triceps Extension	24
Suspended Triceps Extension	25
Suspended Triceps Extension	27
Suspended Triceps Extension	28
Suspended Triceps Extension	29
Suspended Triceps Extension	40
Suspended Triceps Extension	41
Suspended Triceps Extension	44
Suspended Triceps Extension	45
Suspended Triceps Extension	47
Weighted Seated Leg Raise	25
Barbell Curl	10
Barbell Curl	24
Barbell Curl	34
Barbell Curl	35
Barbell Curl	40
Barbell Drag Curl	24
Barbell Drag Curl	34
Barbell Drag Curl	35
Barbell Drag Curl	40
Cable Alternating Curl	24
Cable Alternating Curl	34
Cable Alternating Curl	35
Cable Alternating Curl	40
Cable Curl	10
Cable Curl	24
Cable Curl	34
Cable Curl	35
Cable Curl	40
Cable Bar Curl	10
Cable Bar Curl	24
Cable Bar Curl	34
Cable Bar Curl	35
Cable Bar Curl	40
Weighted Seated Leg Raise	44
Weighted Vertical Leg Raise	23
Weighted Vertical Leg Raise	25
Weighted Vertical Leg Raise	28
Cable Seated Curl	24
Cable Seated Curl	34
Cable Seated Curl	35
Cable Seated Curl	40
Cable One Arm Curl	10
Cable One Arm Curl	24
Cable One Arm Curl	34
Cable One Arm Curl	35
Cable One Arm Curl	40
Cable Supine Curl	10
Cable Supine Curl	24
Cable Supine Curl	34
Cable Supine Curl	35
Cable Supine Curl	40
Dumbbell Curl	10
Dumbbell Curl	24
Dumbbell Curl	34
Dumbbell Curl	35
Dumbbell Curl	40
Dumbbell Seated Curl	10
Dumbbell Seated Curl	40
Dumbbell Incline Curl	10
Dumbbell Incline Curl	40
Lever Curl	40
Lever Alternating Curl	40
Inverted Biceps Row	14
Inverted Biceps Row	16
Inverted Biceps Row	20
Barbell Preacher Curl	40
Barbell Standing Preacher Curl	40
Barbell Prone Incline Curl	34
Barbell Prone Incline Curl	40
Barbell Prone Incline Curl	45
Cable Concentration Curl	14
Cable Concentration Curl	24
Cable Concentration Curl	25
Cable Concentration Curl	34
Cable Concentration Curl	35
Cable Concentration Curl	40
Cable Preacher Curl	40
Cable Alternating Preacher Curl	40
Cable Standing Preacher Curl	40
Cable One Arm Standing Preacher Curl	40
Cable One Arm Preacher Curl	40
Cable Prone Incline Curl	34
Cable Prone Incline Curl	40
Cable Prone Incline Curl	45
Dumbbell Concentration Curl	14
Dumbbell Concentration Curl	24
Dumbbell Concentration Curl	25
Dumbbell Concentration Curl	34
Dumbbell Concentration Curl	35
Dumbbell Concentration Curl	40
Dumbbell Preacher Curl	40
Dumbbell Standing Preacher Curl	40
Weighted Vertical Leg Raise	33
Dumbbell Prone Incline Curl	34
Dumbbell Prone Incline Curl	40
Dumbbell Prone Incline Curl	45
Weighted Vertical Leg Raise	41
Weighted Vertical Leg Raise	44
Weighted Vertical Straight Leg Raise	6
Weighted Vertical Straight Leg Raise	23
Lever Preacher Curl	40
Lever Alternating Preacher Curl (arms high)	40
Lever Standing Preacher Curl	40
Suspended Arm Curl	14
Suspended Arm Curl	16
Suspended Arm Curl	20
Suspended Arm Curl	34
Suspended Arm Curl	40
Suspended Arm Curl	45
Barbell Bent-over Row	1
Barbell Bent-over Row	6
Barbell Bent-over Row	14
Barbell Bent-over Row	16
Barbell Bent-over Row	20
Barbell Close Grip Bent-over Row	1
Barbell Close Grip Bent-over Row	6
Barbell Close Grip Bent-over Row	14
Barbell Close Grip Bent-over Row	16
Barbell Close Grip Bent-over Row	20
Barbell Underhand Bent-over Row	1
Barbell Underhand Bent-over Row	6
Barbell Underhand Bent-over Row	14
Barbell Underhand Bent-over Row	16
Barbell Underhand Bent-over Row	20
Cable Incline Row	1
Cable Incline Row	16
Cable Incline Row	20
Cable Straight Back Incline Row	1
Cable Straight Back Incline Row	14
Cable Straight Back Incline Row	16
Cable Straight Back Incline Row	20
Cable One Arm Bent-over Row	16
Cable One Arm Bent-over Row	20
Cable One Arm Bent-over Row	25
Cable One Arm Bent-over Row	38
Cable One Arm Seated Row	1
Cable One Arm Seated Row	16
Cable One Arm Seated Row	20
Cable One Arm Seated Row	25
Cable Twisting Seated Row	1
Cable Twisting Seated Row	16
Cable Twisting Seated Row	20
Cable One Arm Seated High Row	1
Cable One Arm Seated High Row	16
Cable One Arm Seated High Row	20
Cable One Arm Seated High Row	25
Cable One Arm Seated High Row	43
Cable One Arm Straight Back Seated High Row	14
Cable One Arm Straight Back Seated High Row	25
Cable One Arm Straight Back Seated High Row	43
Cable Twisting Seated High Row	14
Cable Seated High Row	1
Cable Seated High Row	16
Cable Seated High Row	20
Cable Alternating Seated High Row	14
Cable Seated Row	1
Cable Seated Row	16
Cable Seated Row	20
Cable Straight Back Seated Row	1
Cable Straight Back Seated Row	14
Cable Straight Back Seated Row	16
Cable Straight Back Seated Row	20
Cable Wide Grip Seated Row	1
Cable Wide Grip Seated Row	16
Cable Wide Grip Seated Row	20
Cable Wide Grip Straight Back Seated Row	1
Cable Wide Grip Straight Back Seated Row	14
Cable Wide Grip Straight Back Seated Row	16
Cable Wide Grip Straight Back Seated Row	20
Cable Standing Row	38
Cable Standing Low Row	38
Cable Twisting Standing High Row	14
Weighted Vertical Straight Leg Raise	25
Weighted Vertical Straight Leg Raise	28
Weighted Vertical Straight Leg Raise	33
Weighted Vertical Straight Leg Raise	41
Weighted Vertical Straight Leg Raise	44
Weighted Glute-Ham Raise	14
Weighted Incline Crunch	31
Weighted Incline Sit-up	31
Weighted Sit-up	31
Weighted Incline Leg-Hip Raise	6
Weighted Incline Leg-Hip Raise	12
Weighted Incline Leg-Hip Raise	23
Weighted Incline Leg-Hip Raise	28
Weighted Incline Leg-Hip Raise	29
Weighted Incline Leg-Hip Raise	38
Weighted Lying Leg-Hip Raise	6
Weighted Lying Leg-Hip Raise	12
Weighted Lying Leg-Hip Raise	23
Smith Bent-over Row	1
Smith Bent-over Row	6
Smith Bent-over Row	14
Smith Bent-over Row	16
Smith Bent-over Row	20
Weighted Lying Leg-Hip Raise	28
Weighted Lying Leg-Hip Raise	29
Weighted Lying Leg-Hip Raise	38
Inverted Row	14
Inverted Row	16
Inverted Row	20
Weighted Vertical Leg-Hip Raise	23
Weighted Vertical Leg-Hip Raise	28
Weighted Vertical Leg-Hip Raise	33
Weighted Vertical Leg-Hip Raise	41
Weighted Incline Twisting Sit-up	31
Suspended Inverted Row	14
Suspended Inverted Row	16
Suspended Inverted Row	20
Weighted Twisting Sit-up	31
Suspended Row	14
Suspended Row	16
Suspended Row	20
Barbell Pullover	10
Barbell Pullover	27
Barbell Pullover	38
Barbell Pullover	40
Cable Kneeling Bent-over Pulldown	25
Cable Kneeling Bent-over Pulldown	44
Cable Pullover	10
Cable Pullover	27
Cable Pullover	38
Cable Pullover	40
Cable Bent-over Pullover	25
Cable Bent-over Pullover	27
Cable Bent-over Pullover	38
Cable Bent-over Pullover	40
Cable Bent-over Pullover	44
Weighted Lying Twist	1
Lever Pullover	33
Stability Ball Rollout	1
Stability Ball Rollout	21
Stability Ball Rollout	25
Stability Ball Rollout	26
Stability Ball Rollout	27
Stability Ball Rollout	38
Stability Ball Rollout	40
Stability Ball Rollout	41
Stability Ball Rollout	46
Stability Ball Rollout	47
Stability Ball Rollout	53
Suspended Kneeling Rollout	1
Suspended Kneeling Rollout	21
Suspended Kneeling Rollout	25
Suspended Kneeling Rollout	26
Suspended Kneeling Rollout	27
Suspended Kneeling Rollout	38
Suspended Kneeling Rollout	40
Suspended Kneeling Rollout	46
Suspended Kneeling Rollout	53
Barbell Shrug	14
Trap Bar Shrug	14
Cable Shrug	14
Cable Bar Shrug	14
Weighted Lying Twist	12
Weighted Lying Twist	33
Cable One Arm Shrug	14
Cable One Arm Shrug	25
Cable One Arm Shrug	43
Dumbbell Shrug	14
Weighted Lying Twist	34
Weighted Lying Twist	38
Weighted Lying Twist	45
Weighted Bent-knee Lying Twist	1
Lever Shrug	14
Sled Gripless Shrug	14
Smith Shrug	14
Cable Seated Shoulder External Rotation	11
Cable Seated Shoulder External Rotation	33
Cable Seated Shoulder External Rotation	39
Cable Seated Shoulder External Rotation	45
Cable Standing Shoulder External Rotation	11
Cable Standing Shoulder External Rotation	33
Cable Standing Shoulder External Rotation	39
Cable Standing Shoulder External Rotation	45
Cable Upright Shoulder External Rotation	33
Cable Upright Shoulder External Rotation	34
Cable Upright Shoulder External Rotation	39
Cable Upright Shoulder External Rotation	45
Cable Upright Shoulder External Rotation	47
Dumbbell Lying Shoulder External Rotation	33
Dumbbell Lying Shoulder External Rotation	39
Dumbbell Lying Shoulder External Rotation	45
Dumbbell Incline Shoulder External Rotation	33
Dumbbell Incline Shoulder External Rotation	39
Dumbbell Incline Shoulder External Rotation	45
Dumbbell Prone External Rotation	33
Dumbbell Prone External Rotation	34
Dumbbell Prone External Rotation	39
Dumbbell Prone External Rotation	45
Dumbbell Prone Incline External Rotation	33
Dumbbell Prone Incline External Rotation	34
Dumbbell Prone Incline External Rotation	35
Dumbbell Prone Incline External Rotation	39
Dumbbell Prone Incline External Rotation	45
Dumbbell Seated Shoulder External Rotation	39
Dumbbell Upright Shoulder External Rotation	10
Dumbbell Upright Shoulder External Rotation	11
Dumbbell Upright Shoulder External Rotation	33
Dumbbell Upright Shoulder External Rotation	34
Dumbbell Upright Shoulder External Rotation	35
Dumbbell Upright Shoulder External Rotation	39
Dumbbell Upright Shoulder External Rotation	47
Weighted Bent-knee Lying Twist	12
Weighted Bent-knee Lying Twist	33
Weighted Bent-knee Lying Twist	34
Lever Shoulder External Rotation	33
Lever Shoulder External Rotation	39
Lever Upright Shoulder External Rotation	39
Lever Upright Shoulder External Rotation	47
Suspended Shoulder External Rotation	14
Suspended Shoulder External Rotation	16
Suspended Shoulder External Rotation	20
Suspended Shoulder External Rotation	23
Suspended Shoulder External Rotation	29
Suspended Shoulder External Rotation	39
Suspended Shoulder External Rotation	45
Cable Seated Shoulder Internal Rotation	24
Cable Seated Shoulder Internal Rotation	40
Cable Seated Shoulder Internal Rotation	41
Cable Seated Shoulder Internal Rotation	45
Cable Standing Shoulder Internal Rotation	24
Cable Standing Shoulder Internal Rotation	40
Cable Standing Shoulder Internal Rotation	41
Cable Standing Shoulder Internal Rotation	45
Lever Bent-over Fly	4
Lever Bent-over Fly	5
Lever Bent-over Fly	25
Lever Shoulder Internal Rotation	40
Lever Upright Shoulder Internal Rotation	40
Lever Upright Shoulder Internal Rotation	47
Lever Bent-over Fly	38
Lever Bent-over Fly	40
Lever Bent-over Fly	44
Weighted Bent-knee Lying Twist	38
Cable Chest Dip	33
Cable Decline Fly	4
Cable Decline Fly	5
Cable Decline Fly	38
Cable Decline Fly	40
Cable Lying Fly	4
Cable Lying Fly	5
Cable Lying Fly	38
Cable Lying Fly	40
Cable Seated Fly	4
Cable Seated Fly	5
Cable Seated Fly	38
Cable Seated Fly	40
Cable Standing Fly	4
Cable Standing Fly	5
Cable Standing Fly	25
Cable Standing Fly	38
Cable Standing Fly	40
Cable Standing Fly	44
Cable Standing Chest Press	41
Cable Standing Chest Press	47
Cable Twisting Chest Press	44
Cable Twisting Standing Chest Press	44
Dumbbell Decline Fly	4
Dumbbell Decline Fly	5
Dumbbell Decline Fly	38
Dumbbell Decline Fly	40
Dumbbell Fly	4
Dumbbell Fly	5
Dumbbell Fly	38
Dumbbell Fly	40
Dumbbell Pullover	10
Dumbbell Pullover	27
Dumbbell Pullover	38
Dumbbell Pullover	40
Weighted Bent-knee Lying Twist	45
Weighted Russian Twist (on stability ball)	11
Weighted Russian Twist (on stability ball)	12
Weighted Russian Twist (on stability ball)	14
Weighted Russian Twist (on stability ball)	16
Lever Chest Dip	33
Lever Seated Fly	4
Lever Seated Fly	40
Lever Seated Iron Cross Fly	4
Lever Seated Iron Cross Fly	5
Lever Seated Iron Cross Fly	25
Lever Seated Iron Cross Fly	40
Lever Seated Iron Cross Fly	44
Sled Standing Chest Dip	33
Sled Horizontal Grip Standing Chest Dip	33
Weighted Russian Twist (on stability ball)	27
Weighted Russian Twist (on stability ball)	28
Weighted Russian Twist (on stability ball)	33
Weighted Russian Twist (on stability ball)	34
Weighted Russian Twist (on stability ball)	38
Weighted Russian Twist (on stability ball)	41
Weighted Russian Twist (on stability ball)	45
Chest Dip	33
Push-up	6
Push-up	25
Push-up	41
Push-up	44
Push-up	47
Incline Push-up	6
Incline Push-up	15
Incline Push-up	25
Incline Push-up	41
Incline Push-up	44
Incline Push-up	47
Incline Push-up	48
Push-up (on knees)	25
Push-up (on knees)	41
Push-up (on knees)	44
Push-up (on knees)	47
Suspended Chest Dip	33
Suspended Chest Press	6
Suspended Chest Press	15
Suspended Chest Press	25
Suspended Chest Press	41
Suspended Chest Press	44
Suspended Chest Press	47
Suspended Chest Press	48
Suspended Fly	4
Suspended Fly	5
Suspended Fly	6
Suspended Fly	15
Suspended Fly	25
Suspended Fly	38
Suspended Fly	40
Suspended Fly	41
Suspended Fly	44
Suspended Fly	47
Suspended Fly	48
Cable Standing Incline Chest Press	25
Cable Standing Incline Chest Press	44
Cable Bar Standing Incline Chest Press	25
Cable Bar Standing Incline Chest Press	44
Cable One Arm Standing Incline Chest Press	44
Cable Incline Fly	4
Cable Incline Fly	5
Cable Incline Fly	38
Cable Incline Fly	40
Cable Standing Incline Fly	4
Cable Standing Incline Fly	5
Cable Standing Incline Fly	25
Cable Standing Incline Fly	38
Cable Standing Incline Fly	40
Cable Standing Incline Fly	44
Dumbbell Incline Fly	4
Dumbbell Incline Fly	5
Dumbbell Incline Fly	38
Dumbbell Incline Fly	40
Decline Push-up	6
Decline Push-up	25
Decline Push-up	44
Decline Push-up	47
Cable Incline Shoulder Raise	10
Cable Incline Shoulder Raise	38
Cable One Arm Incline Push	44
Dumbbell Incline Shoulder Raise	10
Dumbbell Incline Shoulder Raise	38
Lever Incline Shoulder Raise	10
Lever Incline Shoulder Raise	38
Smith Incline Shoulder Raise	10
Smith Incline Shoulder Raise	38
Push-up Plus	6
Push-up Plus	25
Push-up Plus	44
Barbell Reverse Curl	10
Barbell Reverse Curl	24
Barbell Reverse Curl	34
Barbell Reverse Curl	35
Barbell Reverse Curl	39
Barbell Reverse Preacher Curl	39
Barbell Standing Reverse Preacher Curl	39
Cable Hammer Curl	3
Cable Hammer Curl	10
Cable Hammer Curl	24
Cable Hammer Curl	34
Cable Hammer Curl	35
Cable Reverse Curl	10
Cable Reverse Curl	24
Cable Reverse Curl	34
Cable Reverse Curl	35
Cable Reverse Curl	39
Cable Bar Reverse Curl	10
Cable Bar Reverse Curl	24
Cable Bar Reverse Curl	34
Cable Bar Reverse Curl	35
Cable Bar Reverse Curl	39
Cable Reverse Preacher Curl	39
Cable Standing Reverse Preacher Curl	39
Dumbbell Hammer Curl	3
Dumbbell Hammer Curl	10
Dumbbell Hammer Curl	24
Dumbbell Hammer Curl	34
Dumbbell Hammer Curl	35
Lever Hammer Preacher Curl	3
Lever Hammer Preacher Curl	10
Lever Hammer Preacher Curl	24
Lever Hammer Preacher Curl	34
Lever Hammer Preacher Curl	35
Lever Reverse Curl	10
Lever Reverse Curl	40
Lever Reverse Preacher Curl	39
Barbell Seated Good-morning	14
Barbell Deadlift	24
Barbell Deadlift	34
Barbell Deadlift	35
Barbell Deadlift	45
Barbell Sumo Deadlift	24
Barbell Sumo Deadlift	34
Barbell Sumo Deadlift	35
Barbell Sumo Deadlift	45
Barbell Hip Thrust	14
Barbell Lunge	14
Barbell Lunge	17
Barbell Lunge	18
Barbell Lunge	25
Barbell Lunge	31
Barbell Lunge	43
Barbell Alternating Lunge To Rear Lunge	14
Barbell Alternating Lunge To Rear Lunge	17
Barbell Alternating Lunge To Rear Lunge	18
Barbell Alternating Lunge To Rear Lunge	25
Barbell Alternating Lunge To Rear Lunge	31
Barbell Alternating Lunge To Rear Lunge	43
Barbell Rear Lunge	14
Barbell Rear Lunge	17
Barbell Rear Lunge	18
Barbell Rear Lunge	25
Barbell Rear Lunge	43
Barbell Side Lunge	14
Barbell Side Lunge	17
Barbell Side Lunge	18
Barbell Side Lunge	25
Barbell Side Lunge	31
Barbell Side Lunge	43
Barbell Walking Lunge	14
Barbell Walking Lunge	17
Barbell Walking Lunge	18
Barbell Walking Lunge	25
Barbell Walking Lunge	31
Barbell Walking Lunge	43
Barbell Single Leg Split Squat	14
Barbell Single Leg Split Squat	17
Barbell Single Leg Split Squat	18
Barbell Side Split Squat	14
Barbell Side Split Squat	17
Barbell Side Split Squat	18
Barbell Single Leg Squat	17
Barbell Single Leg Squat	18
Barbell Single Leg Squat	25
Barbell Single Leg Squat	43
Barbell Single Leg Squat	44
Barbell Split Squat	14
Barbell Split Squat	17
Barbell Split Squat	18
Barbell Front Squat	10
Barbell Front Squat	11
Barbell Front Squat	14
Barbell Front Squat	24
Barbell Front Squat	27
Barbell Front Squat	33
Barbell Front Squat	34
Barbell Front Squat	35
Barbell Front Squat	47
Barbell Front Squat	52
Barbell Full Squat	14
Trap Bar Squat	14
Trap Bar Squat	24
Trap Bar Squat	34
Trap Bar Squat	35
Trap Bar Deadlift	24
Trap Bar Deadlift	34
Trap Bar Deadlift	35
Trap Bar Deadlift	45
Cable Glute Kickback	14
Cable Glute Kickback	17
Cable Glute Kickback	18
Cable Glute Kickback	25
Cable Glute Kickback	43
Cable Rear Lunge	14
Cable Rear Lunge	17
Cable Rear Lunge	18
Cable Rear Lunge	24
Cable Rear Lunge	25
Cable Rear Lunge	33
Cable Rear Lunge	35
Cable Rear Lunge	43
Cable Rear Step-down Lunge	14
Cable Rear Step-down Lunge	17
Cable Rear Step-down Lunge	18
Cable Rear Step-down Lunge	24
Cable Rear Step-down Lunge	25
Cable Rear Step-down Lunge	33
Cable Rear Step-down Lunge	35
Cable Rear Step-down Lunge	43
Cable Single Leg Split Squat	14
Cable Single Leg Split Squat	17
Cable Single Leg Split Squat	18
Cable Single Leg Split Squat	24
Cable Single Leg Split Squat	33
Cable Single Leg Split Squat	35
Cable One Arm Single Leg Split Squat	14
Cable One Arm Single Leg Split Squat	17
Cable One Arm Single Leg Split Squat	18
Cable One Arm Single Leg Split Squat	25
Cable Split Squat	14
Cable Split Squat	24
Cable Split Squat	25
Cable Split Squat	34
Cable Split Squat	35
Cable One Arm Split Squat	14
Cable One Arm Split Squat	25
Cable Squat	14
Cable Squat	24
Cable Squat	34
Cable Squat	35
Cable Bar Squat	14
Cable Standing Hip Extension	14
Cable Standing Hip Extension	17
Cable Standing Hip Extension	18
Cable Standing Hip Extension	25
Cable Standing Hip Extension	43
Cable Bent-over Hip Extension	14
Cable Bent-over Hip Extension	17
Cable Bent-over Hip Extension	18
Cable Bent-over Hip Extension	25
Cable Bent-over Hip Extension	43
Cable Step-up	14
Cable Step-up	17
Cable Step-up	18
Cable Step-up	24
Cable Step-up	25
Cable Step-up	34
Cable Step-up	35
Cable Step-up	43
Dumbbell Lunge	14
Dumbbell Lunge	17
Dumbbell Lunge	18
Dumbbell Lunge	24
Dumbbell Lunge	25
Dumbbell Lunge	31
Dumbbell Lunge	33
Dumbbell Lunge	35
Dumbbell Lunge	43
Dumbbell Alternating Side Lunge	14
Dumbbell Alternating Side Lunge	17
Dumbbell Alternating Side Lunge	18
Dumbbell Alternating Side Lunge	24
Dumbbell Alternating Side Lunge	25
Dumbbell Alternating Side Lunge	31
Dumbbell Alternating Side Lunge	34
Dumbbell Alternating Side Lunge	35
Dumbbell Alternating Side Lunge	43
Dumbbell Rear Lunge	14
Dumbbell Rear Lunge	17
Dumbbell Rear Lunge	18
Dumbbell Rear Lunge	24
Dumbbell Rear Lunge	25
Dumbbell Rear Lunge	33
Dumbbell Rear Lunge	35
Dumbbell Rear Lunge	43
Dumbbell Side Lunge	14
Dumbbell Side Lunge	17
Dumbbell Side Lunge	18
Dumbbell Side Lunge	24
Dumbbell Side Lunge	25
Dumbbell Side Lunge	31
Dumbbell Side Lunge	34
Dumbbell Side Lunge	35
Dumbbell Side Lunge	43
Dumbbell Walking Lunge	14
Dumbbell Walking Lunge	17
Dumbbell Walking Lunge	18
Dumbbell Walking Lunge	25
Dumbbell Walking Lunge	31
Dumbbell Walking Lunge	43
Dumbbell Single Leg Split Squat	17
Dumbbell Single Leg Split Squat	18
Dumbbell Single Leg Squat	17
Dumbbell Single Leg Squat	18
Dumbbell Single Leg Squat	25
Dumbbell Single Leg Squat	43
Dumbbell Single Leg Squat	44
Dumbbell Split Squat	14
Dumbbell Split Squat	17
Dumbbell Split Squat	18
Dumbbell Squat	14
Dumbbell Squat	24
Dumbbell Squat	34
Dumbbell Squat	35
Dumbbell Squat	45
Dumbbell Front Squat	14
Dumbbell Front Squat	24
Dumbbell Front Squat	34
Dumbbell Front Squat	35
Dumbbell Step-up	14
Dumbbell Step-up	17
Dumbbell Step-up	18
Dumbbell Step-up	24
Dumbbell Step-up	25
Dumbbell Step-up	34
Dumbbell Step-up	35
Dumbbell Step-up	43
Dumbbell Lateral Step-up	14
Dumbbell Lateral Step-up	17
Dumbbell Lateral Step-up	18
Dumbbell Lateral Step-up	25
Dumbbell Lateral Step-up	43
Dumbbell Step Down	14
Dumbbell Step Down	17
Dumbbell Step Down	18
Dumbbell Step Down	25
Dumbbell Step Down	43
Lever Hip Thrust	14
Lever Front Squat	14
Lever Front Squat	24
Lever Front Squat	34
Lever Front Squat	35
Lever Kneeling Hip Extension	14
Lever Kneeling Hip Extension	17
Lever Kneeling Hip Extension	18
Lever Kneeling Hip Extension	25
Lever Kneeling Hip Extension	43
Lever Alternating Kneeling Hip Extension	14
Lever Alternating Kneeling Hip Extension	17
Lever Alternating Kneeling Hip Extension	18
Lever Alternating Kneeling Hip Extension	25
Lever Alternating Kneeling Hip Extension	43
Lever Lying Hip Extension	14
Lever Alternating Lying Hip Extension	14
Lever Alternating Lying Hip Extension	25
Lever Standing Hip Extension	14
Lever Standing Hip Extension	17
Lever Standing Hip Extension	18
Lever Standing Hip Extension	25
Lever Standing Hip Extension	43
Lever Bent-over Glute Kickback	14
Lever Bent-over Glute Kickback	17
Lever Bent-over Glute Kickback	18
Lever Bent-over Glute Kickback	25
Lever Bent-over Glute Kickback	43
Lever Kneeling Glute Kickback	14
Lever Kneeling Glute Kickback	17
Lever Kneeling Glute Kickback	18
Lever Kneeling Glute Kickback	25
Lever Kneeling Glute Kickback	43
Lever Standing Glute Kickback	14
Lever Standing Glute Kickback	17
Lever Standing Glute Kickback	18
Lever Standing Glute Kickback	25
Lever Standing Glute Kickback	43
Lever Squat	14
Lever Squat	24
Lever Squat	34
Lever Squat	35
Lever Split V-Squat	17
Lever Split V-Squat	18
Lever Split V-Squat	25
Lever Split V-Squat	43
Lever Single Leg Split V-Squat	17
Lever Single Leg Split V-Squat	18
Lever Single Leg Split V-Squat	25
Lever Single Leg Split V-Squat	43
Lever Alternating Single Leg Split V-Squat	17
Lever Alternating Single Leg Split V-Squat	18
Lever Alternating Single Leg Split V-Squat	25
Lever Alternating Single Leg Split V-Squat	43
Sled Single Leg Lying Leg Press	17
Sled Single Leg Lying Leg Press	18
Sled Single Leg Lying Leg Press	25
Sled Single Leg Lying Leg Press	43
Sled Kneeling Glute Kickback	14
Sled Kneeling Glute Kickback	17
Sled Kneeling Glute Kickback	18
Sled Kneeling Glute Kickback	25
Sled Kneeling Glute Kickback	43
Sled Standing Glute Kickback	14
Sled Standing Glute Kickback	17
Sled Standing Glute Kickback	18
Sled Standing Glute Kickback	25
Sled Standing Glute Kickback	43
Sled Rear Lunge	14
Sled Rear Lunge	17
Sled Rear Lunge	18
Sled Single Leg Hack Squat	17
Sled Single Leg Hack Squat	18
Smith Bent Knee Good-morning	6
Smith Deadlift	24
Smith Deadlift	34
Smith Deadlift	35
Smith Deadlift	45
Smith Rear Lunge	14
Smith Rear Lunge	17
Smith Rear Lunge	18
Smith Rear Lunge	25
Smith Rear Lunge	43
Smith Single Leg Split Squat	14
Smith Single Leg Split Squat	17
Smith Single Leg Split Squat	18
Smith Split Squat	14
Smith Squat	14
Smith Single Leg Squat	14
Smith Single Leg Squat	17
Smith Single Leg Squat	18
Smith Single Leg Squat	25
Smith Single Leg Squat	43
Smith Front Squat	10
Smith Front Squat	11
Smith Front Squat	14
Smith Front Squat	24
Smith Front Squat	27
Smith Front Squat	33
Smith Front Squat	34
Smith Front Squat	35
Smith Front Squat	47
Smith Hack Squat	14
Smith Hack Squat	24
Smith Hack Squat	34
Smith Hack Squat	35
Smith Wide Squat	14
Lunge	17
Lunge	18
Lunge	25
Lunge	31
Lunge	43
Rear Lunge	17
Rear Lunge	18
Rear Lunge	25
Rear Lunge	43
Reverse Hyper-extension	14
Reverse Hyper-extension (on stability ball)	14
Single Leg Squat (pistol)	14
Single Leg Squat (pistol)	17
Single Leg Squat (pistol)	18
Single Leg Squat (pistol)	25
Single Leg Squat (pistol)	43
Single Leg Half Squat	14
Single Leg Half Squat	17
Single Leg Half Squat	18
Single Leg Half Squat	25
Single Leg Half Squat	43
Split Squat	17
Split Squat	18
Single Leg Split Squat	17
Single Leg Split Squat	18
Step-up	14
Step-up	17
Step-up	18
Step-up	24
Step-up	25
Step-up	34
Step-up	35
Step-up	43
Lateral Step-up	14
Lateral Step-up	17
Lateral Step-up	18
Lateral Step-up	25
Lateral Step-up	43
Step-down	14
Step-down	17
Step-down	18
Step-down	25
Step-down	43
Alternating Step-down	14
Alternating Step-down	17
Alternating Step-down	18
Alternating Step-down	25
Alternating Step-down	43
Suspended Hip Bridge	14
Suspended Hip Bridge	15
Suspended Hip Bridge	20
Suspended Hip Bridge	42
Suspended Hip Bridge	46
Suspended Single Leg Squat	17
Suspended Single Leg Squat	18
Suspended Single Leg Squat	25
Suspended Single Leg Squat	34
Suspended Single Leg Squat	43
Suspended Single Leg Squat	44
Suspended Single Leg Squat	45
Suspended Single Leg Split Squat	17
Suspended Single Leg Split Squat	18
Suspended Single Leg Split Squat	25
Suspended Single Leg Split Squat	43
Cable Hip Abduction	2
Cable Lying Hip Internal Rotation	2
Cable Lying Hip Internal Rotation	25
Cable Seated Hip Internal Rotation	1
Cable Seated Hip Internal Rotation	16
Cable Seated Hip Internal Rotation	19
Cable Seated Hip Internal Rotation	26
Dumbbell Lying Hip Abduction	2
Lever Standing Hip Abduction	2
Cable Twist	11
Cable Twist	12
Cable Twist	14
Cable Twist	27
Cable Twist	28
Cable Twist	33
Cable Twist	34
Cable Twist	38
Cable Twist	41
Cable Twist	44
Cable Twist	45
Side Bridge Hip Abduction	23
Side Bridge Hip Abduction	24
Side Bridge Hip Abduction	41
Angled Side Bridge Hip Abduction	23
Angled Side Bridge Hip Abduction	38
Angled Side Bridge Hip Abduction	41
Bent Knee Side Bridge Hip Abduction	23
Bent Knee Side Bridge Hip Abduction	24
Bent Knee Side Bridge Hip Abduction	41
Suspended Hip Abduction	14
Suspended Hip Abduction	16
Suspended Hip Abduction	20
Angled Side Bridge	23
Angled Side Bridge	41
Bent Knee Side Bridge	23
Bent Knee Side Bridge	41
Side Bridge	23
Side Bridge	24
Side Bridge	27
Side Bridge	41
Suspended Side Bridge	23
Suspended Side Bridge	24
Suspended Side Bridge	41
Suspended Twist	11
Suspended Twist	12
Suspended Twist	14
Suspended Twist	16
Suspended Twist	20
Suspended Twist	27
Suspended Twist	28
Suspended Twist	33
Suspended Twist	34
Suspended Twist	38
Suspended Twist	41
Suspended Twist	45
Cable Lying Leg Raise	25
Cable Lying Leg Raise	44
Cable Lying Straight Leg Raise	25
Cable Lying Straight Leg Raise	44
Cable Standing Leg Raise	17
Cable Standing Leg Raise	18
Cable Standing Leg Raise	25
Cable Standing Leg Raise	43
Cable Standing Leg Raise	44
Cable Standing Straight Leg Raise	17
Cable Standing Straight Leg Raise	18
Cable Standing Straight Leg Raise	25
Cable Standing Straight Leg Raise	43
Cable Standing Straight Leg Raise	44
Lever Hip Flexion	17
Lever Hip Flexion	18
Lever Hip Flexion	25
Lever Hip Flexion	43
Lever Hip Flexion	44
Lever Lying Leg Raise	6
Lever Lying Leg Raise	25
Lever Lying Leg Raise	44
Lever Vertical Leg Raise	10
Lever Vertical Leg Raise	25
Lever Vertical Leg Raise	28
Lever Vertical Leg Raise	38
Lever Vertical Leg Raise	41
Lever Vertical Leg Raise	44
Hanging Leg Raise	25
Hanging Leg Raise	44
Hanging Straight Leg Raise	6
Hanging Straight Leg Raise	25
Hanging Straight Leg Raise	44
Incline Leg Raise	12
Incline Leg Raise	23
Incline Leg Raise	25
Incline Leg Raise	28
Incline Leg Raise	29
Incline Leg Raise	38
Incline Leg Raise	44
Incline Straight Leg Raise	6
Incline Straight Leg Raise	12
Incline Straight Leg Raise	23
Incline Straight Leg Raise	25
Incline Straight Leg Raise	28
Incline Straight Leg Raise	29
Incline Straight Leg Raise	38
Incline Straight Leg Raise	44
Lying Straight Leg Raise	6
Lying Straight Leg Raise	25
Lying Straight Leg Raise	44
Lying Simultaneous Alternating Straight Leg Raise	6
Lying Simultaneous Alternating Straight Leg Raise	25
Lying Simultaneous Alternating Straight Leg Raise	44
Seated Leg Raise	25
Seated Leg Raise	44
Vertical Leg Raise	23
Vertical Leg Raise	25
Vertical Leg Raise	28
Vertical Leg Raise	33
Vertical Leg Raise	41
Vertical Leg Raise	44
Vertical Straight Leg Raise	6
Vertical Straight Leg Raise	23
Vertical Straight Leg Raise	25
Vertical Straight Leg Raise	28
Vertical Straight Leg Raise	33
Vertical Straight Leg Raise	41
Vertical Straight Leg Raise	44
Jack-knife on Ball	6
Jack-knife on Ball	10
Jack-knife on Ball	25
Jack-knife on Ball	27
Jack-knife on Ball	28
Jack-knife on Ball	38
Jack-knife on Ball	44
Jack-knife on Ball	47
Lying Scissor Kick	6
Lying Scissor Kick	25
Lying Scissor Kick	44
Jack-knife on Power Wheel	6
Jack-knife on Power Wheel	10
Jack-knife on Power Wheel	25
Jack-knife on Power Wheel	27
Jack-knife on Power Wheel	28
Jack-knife on Power Wheel	38
Jack-knife on Power Wheel	41
Jack-knife on Power Wheel	44
Jack-knife on Power Wheel	47
Pike on Power Wheel	6
Pike on Power Wheel	10
Pike on Power Wheel	25
Pike on Power Wheel	27
Pike on Power Wheel	28
Pike on Power Wheel	38
Pike on Power Wheel	41
Pike on Power Wheel	44
Pike on Power Wheel	47
Pike on Discs	6
Pike on Discs	10
Pike on Discs	25
Pike on Discs	27
Pike on Discs	28
Pike on Discs	38
Pike on Discs	41
Pike on Discs	44
Pike on Discs	47
Suspended Mountain Climber	6
Suspended Mountain Climber	25
Suspended Mountain Climber	27
Suspended Mountain Climber	38
Suspended Mountain Climber	44
Suspended Mountain Climber	47
Suspended Pike	6
Suspended Pike	10
Suspended Pike	25
Suspended Pike	33
Suspended Pike	34
Suspended Pike	35
Suspended Pike	38
Suspended Pike	41
Suspended Pike	44
Suspended Pike	47
Cable Lying Hip External Rotation	1
Cable Lying Hip External Rotation	25
Cable Seated Hip External Rotation	8
Cable Seated Hip External Rotation	16
Cable Seated Hip External Rotation	17
Cable Seated Hip External Rotation	18
Trap Bar Straight Leg Deadlift (Romanian)	34
Barbell Front Raise	24
Barbell Front Raise	35
Barbell Front Raise	39
Barbell Incline Front Raise	39
Barbell Incline Front Raise	47
Barbell Military Press	24
Barbell Military Press	35
Barbell Seated Military Press	24
Barbell Seated Military Press	35
Barbell Shoulder Press	24
Barbell Shoulder Press	35
Barbell Reclined Shoulder Press	24
Barbell Reclined Shoulder Press	35
Cable Bar Behind Neck Press	24
Cable Bar Behind Neck Press	35
Cable Bar Front Raise	24
Cable Bar Front Raise	35
Cable Bar Front Raise	39
Cable Bar Military Press	24
Cable Bar Military Press	35
Cable Bar Shoulder Press	24
Cable Bar Shoulder Press	35
Cable Seated Front Raise	24
Cable Seated Front Raise	35
Cable Seated Front Raise	39
Cable Alternating Front Raise	24
Cable Alternating Front Raise	35
Cable Alternating Front Raise	39
Cable Alternating Seated Front Raise	24
Cable Alternating Seated Front Raise	35
Cable Alternating Seated Front Raise	39
Cable One Arm Front Raise	24
Cable One Arm Front Raise	35
Cable One Arm Front Raise	39
Cable Standing Shoulder Press	24
Cable Standing Shoulder Press	35
Cable Shoulder Press	24
Cable Shoulder Press	35
Cable Twisting Overhead Press	14
Cable Twisting Overhead Press	24
Cable Twisting Overhead Press	25
Cable Twisting Overhead Press	35
Dumbbell Arnold Press	24
Dumbbell Arnold Press	35
Dumbbell Front Raise	24
Dumbbell Front Raise	35
Dumbbell Front Raise	39
Dumbbell Alternating Front Raise	24
Dumbbell Alternating Front Raise	35
Dumbbell Alternating Front Raise	39
Dumbbell Alternating Incline Front Raise	39
Dumbbell Alternating Incline Front Raise	47
Dumbbell Alternating Seated Front Raise	24
Dumbbell Alternating Seated Front Raise	35
Dumbbell Alternating Seated Front Raise	39
Dumbbell Seated Front Raise	24
Dumbbell Seated Front Raise	35
Dumbbell Seated Front Raise	39
Dumbbell Shoulder Press	24
Dumbbell Shoulder Press	35
Dumbbell One Arm Shoulder Press	24
Dumbbell One Arm Shoulder Press	35
Dumbbell Reclined Shoulder Press	24
Dumbbell Reclined Shoulder Press	35
Lever One Arm Front Raise	39
Lever Reclined Shoulder Press	24
Lever Reclined Shoulder Press	35
Lever Reclined Parallel Grip Shoulder Press	24
Lever Reclined Parallel Grip Shoulder Press	35
Lever Shoulder Press	24
Lever Shoulder Press	35
Lever Alternating Shoulder Press	24
Lever Alternating Shoulder Press	35
Sled Shoulder Press	24
Sled Shoulder Press	35
Smith Behind Neck Press	24
Smith Behind Neck Press	35
Smith Shoulder Press	24
Smith Shoulder Press	35
Pike Press	6
Pike Press	21
Pike Press	24
Pike Press	25
Pike Press	35
Pike Press	44
Pike Press	46
Pike Press	47
Pike Press	53
Elevated Pike Press	6
Elevated Pike Press	21
Elevated Pike Press	24
Elevated Pike Press	25
Elevated Pike Press	35
Elevated Pike Press	44
Elevated Pike Press	46
Elevated Pike Press	53
Suspended Front Raise	14
Suspended Front Raise	16
Suspended Front Raise	20
Suspended Front Raise	24
Suspended Front Raise	35
Suspended Front Raise	39
Barbell Upright Row	24
Barbell Upright Row	35
Barbell Wide Grip Upright Row	24
Barbell Wide Grip Upright Row	35
Cable Lateral Raise	24
Cable Lateral Raise	35
Cable Lateral Raise	39
Cable One Arm Lateral Raise	24
Cable One Arm Lateral Raise	35
Cable One Arm Lateral Raise	39
Cable Seated Lateral Raise	24
Cable Seated Lateral Raise	35
Cable Seated Lateral Raise	39
Cable Upright Row	24
Cable Upright Row	35
Cable Bar Upright Row	24
Cable Bar Upright Row	35
Cable One Arm Upright Row	24
Cable One Arm Upright Row	35
Cable Wide Grip Upright Row	24
Cable Wide Grip Upright Row	35
Cable Y Raise	14
Cable Y Raise	16
Cable Y Raise	20
Cable Y Raise	24
Cable Y Raise	35
Cable Y Raise	39
Cable Seated Y Raise	1
Cable Seated Y Raise	14
Cable Seated Y Raise	16
Cable Seated Y Raise	20
Cable Seated Y Raise	24
Cable Seated Y Raise	35
Cable Seated Y Raise	39
Dumbbell Incline Lateral Raise	24
Dumbbell Incline Lateral Raise	35
Dumbbell Incline Lateral Raise	39
Dumbbell Incline Y Raise	24
Dumbbell Incline Y Raise	35
Dumbbell Incline Y Raise	39
Dumbbell Lateral Raise	24
Dumbbell Lateral Raise	35
Dumbbell Lateral Raise	39
Dumbbell One Arm Lateral Raise	24
Dumbbell One Arm Lateral Raise	35
Dumbbell One Arm Lateral Raise	39
Dumbbell One Arm Seated Lateral Raise	24
Dumbbell One Arm Seated Lateral Raise	35
Dumbbell One Arm Seated Lateral Raise	39
Dumbbell Seated Lateral Raise	24
Dumbbell Seated Lateral Raise	35
Dumbbell Seated Lateral Raise	39
Dumbbell Lying Lateral Raise	24
Dumbbell Lying Lateral Raise	35
Dumbbell Lying Lateral Raise	39
Dumbbell Raise	24
Dumbbell Raise	35
Dumbbell Upright Row	24
Dumbbell Upright Row	35
Dumbbell One Arm Upright Row	24
Dumbbell One Arm Upright Row	35
Dumbbell Seated Upright Row	24
Dumbbell Seated Upright Row	35
Dumbbell Seated Upright Row	38
Lever Lateral Raise	24
Lever Lateral Raise	35
Lever Extended Arm Lateral Raise	24
Lever Extended Arm Lateral Raise	35
Lever Extended Arm Lateral Raise	39
Smith Upright Row	24
Smith Upright Row	35
Smith Wide Grip Upright Row	24
Smith Wide Grip Upright Row	35
Suspended Y Lateral Raise	14
Suspended Y Lateral Raise	16
Suspended Y Lateral Raise	20
Suspended Y Lateral Raise	24
Suspended Y Lateral Raise	35
Suspended Y Lateral Raise	39
Barbell Rear Delt Row	1
Barbell Rear Delt Row	6
Barbell Rear Delt Row	14
Barbell Rear Delt Row	16
Barbell Rear Delt Row	20
Cable Reverse Fly	14
Cable Reverse Fly	38
Cable Reverse Fly	39
Cable Seated Reverse Fly	1
Cable Seated Reverse Fly	14
Cable Seated Reverse Fly	16
Cable Seated Reverse Fly	38
Cable Seated Reverse Fly	39
Cable One Arm Reverse Fly	14
Cable One Arm Reverse Fly	25
Cable One Arm Reverse Fly	38
Cable One Arm Reverse Fly	39
Cable Supine Reverse Fly	38
Cable Supine Reverse Fly	39
Cable Rear Delt Row	1
Cable Rear Delt Row	14
Cable Rear Delt Row	16
Cable Rear Delt Row	20
Cable One Arm Rear Delt Row	1
Cable One Arm Rear Delt Row	14
Cable One Arm Rear Delt Row	16
Cable One Arm Rear Delt Row	20
Cable One Arm Rear Delt Row	25
Cable Rear Lateral Raise	1
Cable Rear Lateral Raise	6
Cable Rear Lateral Raise	14
Cable Rear Lateral Raise	16
Cable Rear Lateral Raise	20
Cable Rear Lateral Raise	38
Cable Rear Lateral Raise	39
Cable One Arm Rear Lateral Raise	1
Cable One Arm Rear Lateral Raise	14
Cable One Arm Rear Lateral Raise	16
Cable One Arm Rear Lateral Raise	20
Cable One Arm Rear Lateral Raise	25
Cable One Arm Rear Lateral Raise	38
Cable One Arm Rear Lateral Raise	39
Cable Seated Rear Lateral Raise	38
Cable Seated Rear Lateral Raise	39
Cable One Arm Standing Cross Row	14
Cable One Arm Standing Cross Row	25
Dumbbell Lying One Arm Rear Lateral Raise	3
Dumbbell Rear Lateral Raise	1
Dumbbell Rear Lateral Raise	6
Dumbbell Rear Lateral Raise	14
Dumbbell Rear Lateral Raise	16
Dumbbell Rear Lateral Raise	20
Dumbbell Rear Lateral Raise	38
Dumbbell Rear Lateral Raise	39
Dumbbell Rear Delt Row	38
Dumbbell Seated Rear Lateral Raise	38
Dumbbell Side Lying Rear Delt Raise	38
Barbell Straight Leg Deadlift (Romanian)	23
Barbell Straight Leg Deadlift (Romanian)	24
Lever Seated Rear Delt Row	11
Lever Seated Reverse Fly (parallel grip)	38
Lever Seated Reverse Fly (parallel grip)	39
Lever Seated Reverse Fly (overhand grip)	38
Lever Seated Reverse Fly (overhand grip)	39
Lever Seated Reverse Fly (pronated parallel grip)	38
Lever Seated Reverse Fly (pronated parallel grip)	39
Smith Rear Delt Row	1
Smith Rear Delt Row	6
Smith Rear Delt Row	14
Smith Rear Delt Row	16
Smith Rear Delt Row	20
Rear Delt Inverted Row	11
Rear Delt Inverted Row	14
Rear Delt Inverted Row	16
Rear Delt Inverted Row	20
Suspended Rear Delt Row	11
Suspended Rear Delt Row	14
Suspended Rear Delt Row	16
Suspended Rear Delt Row	20
Suspended Reverse Fly	11
Suspended Reverse Fly	14
Suspended Reverse Fly	16
Suspended Reverse Fly	20
Cable Front Lateral Raise	35
Cable Front Lateral Raise	39
Cable Seated Front Lateral Raise	35
Cable Seated Front Lateral Raise	39
Dumbbell Front Lateral Raise	35
Dumbbell Front Lateral Raise	39
Dumbbell Seated Front Lateral Raise	35
Dumbbell Seated Front Lateral Raise	39
Barbell Squat	14
Cable Belt Half Squat	14
Cable Belt Half Squat	24
Cable Belt Half Squat	34
Cable Belt Half Squat	35
Cable Standing Leg Extension	17
Cable Standing Leg Extension	18
Cable Standing Leg Extension	25
Cable Standing Leg Extension	43
Cable Standing Leg Extension	44
Cable Step Down	17
Cable Step Down	18
Cable Step Down	25
Cable Step Down	43
Barbell Straight Leg Deadlift (Romanian)	33
Barbell Straight Leg Deadlift (Romanian)	34
Barbell Straight Leg Deadlift (Romanian)	35
Barbell Straight Leg Deadlift (Romanian)	45
Cable Straight Leg Deadlift (Romanian)	23
Cable Straight Leg Deadlift (Romanian)	24
Trap Bar Straight Leg Deadlift (Romanian)	23
Trap Bar Straight Leg Deadlift (Romanian)	24
Trap Bar Straight Leg Deadlift (Romanian)	33
Sled Squat	14
Sled Squat	24
Sled Squat	34
Sled Squat	35
Smith Step Down	14
Smith Step Down	17
Smith Step Down	18
Smith Step Down	25
Smith Step Down	43
Barbell Good-morning	14
Barbell Glute-Ham Raise	14
Cable Bent-over Leg Curl	17
Cable Bent-over Leg Curl	18
Cable Standing Leg Curl	17
Cable Standing Leg Curl	18
Cable Standing Leg Curl	25
Cable Standing Leg Curl	43
Trap Bar Straight Leg Deadlift (Romanian)	35
Trap Bar Straight Leg Deadlift (Romanian)	45
Lever Rear Lateral Raise	1
Lever Rear Lateral Raise	6
Lever Rear Lateral Raise	14
Lever Rear Lateral Raise	16
Lever Rear Lateral Raise	20
Cable Straight Leg Deadlift (Romanian)	33
Cable Straight Leg Deadlift (Romanian)	34
Cable Straight Leg Deadlift (Romanian)	35
Cable Straight Leg Deadlift (Romanian)	45
Dumbbell Straight Leg Deadlift (Romanian)	23
Dumbbell Straight Leg Deadlift (Romanian)	24
Dumbbell Straight Leg Deadlift (Romanian)	33
Dumbbell Straight Leg Deadlift (Romanian)	34
Dumbbell Straight Leg Deadlift (Romanian)	35
Dumbbell Straight Leg Deadlift (Romanian)	45
Smith Straight Leg Deadlift (Romanian)	23
Smith Straight Leg Deadlift (Romanian)	24
Smith Straight Leg Deadlift (Romanian)	33
Smith Straight Leg Deadlift (Romanian)	34
Lever Bent-over Leg Curl	17
Lever Bent-over Leg Curl	18
Lever Alternating Bent-over Leg Curl	17
Lever Alternating Bent-over Leg Curl	18
Lever Kneeling Leg Curl	16
Lever Kneeling Leg Curl	17
Lever Straight-leg Lying Hip Extension	14
Lever Straight-leg Lying Hip Extension	24
Lever Straight-leg Lying Hip Extension	33
Lever Straight-leg Lying Hip Extension	34
Lever Straight-leg Lying Hip Extension	35
Lever Straight-leg Lying Hip Extension	45
Smith Good-morning	14
Smith Straight Leg Deadlift (Romanian)	35
Glute-Ham Raise (hands behind neck)	14
Glute-Ham Raise (hands behind hips)	14
Hanging Hamstring Bridge	14
Hanging Hamstring Bridge	33
Hanging Hamstring Bridge	34
Hanging Hamstring Bridge	45
Single Leg Hanging Hamstring Bridge	33
Single Leg Hanging Hamstring Bridge	34
Single Leg Hanging Hamstring Bridge	45
Hanging Hamstring Bridge Curl	14
Hanging Hamstring Bridge Curl	33
Hanging Hamstring Bridge Curl	34
Hanging Hamstring Bridge Curl	45
Single Leg Hanging Hamstring Bridge Curl	14
Single Leg Hanging Hamstring Bridge Curl	33
Single Leg Hanging Hamstring Bridge Curl	34
Single Leg Hanging Hamstring Bridge Curl	45
Hanging Leg Curl	14
Hanging Leg Curl	16
Hanging Leg Curl	33
Hanging Leg Curl	34
Hanging Leg Curl	45
Hanging Straight Hip Leg Curl	14
Hanging Straight Hip Leg Curl	16
Hanging Straight Hip Leg Curl	33
Hanging Straight Hip Leg Curl	34
Hanging Straight Hip Leg Curl	45
Straight Hip Leg Curl (on stability ball)	14
Straight Hip Leg Curl (on stability ball)	16
Single Leg Straight Hip Leg Curl (on stability ball)	6
Single Leg Straight Hip Leg Curl (on stability ball)	14
Single Leg Straight Hip Leg Curl (on stability ball)	16
Smith Straight Leg Deadlift (Romanian)	45
Suspended Straight Hip Leg Curl	14
Suspended Straight Hip Leg Curl	16
Cable Hip Adduction	1
Cable Lying Hip Adduction	21
Cable Lying Hip Adduction	25
Cable Lying Hip Adduction	44
Cable Lying Hip Adduction	46
Cable Lying Hip Adduction	53
Barbell Push Sit-up	10
Barbell Push Sit-up	11
Barbell Push Sit-up	27
Barbell Push Sit-up	28
Barbell Push Sit-up	31
Barbell Push Sit-up	38
Barbell Push Sit-up	41
Barbell Push Sit-up	47
Cable Lying Crunch (on stability ball)	12
Cable Lying Crunch (on stability ball)	23
Cable Lying Crunch (on stability ball)	27
Cable Lying Crunch (on stability ball)	28
Cable Lying Crunch (on stability ball)	29
Cable Lying Crunch (on stability ball)	33
Cable Lying Crunch (on stability ball)	38
Cable Lying Crunch (on stability ball)	41
Cable Lying Crunch (on stability ball)	45
Cable Lying Crunch (on stability ball)	47
Cable Kneeling Crunch	12
Cable Kneeling Crunch	21
Cable Kneeling Crunch	23
Cable Kneeling Crunch	27
Cable Kneeling Crunch	28
Cable Kneeling Crunch	29
Cable Kneeling Crunch	33
Cable Kneeling Crunch	38
Cable Kneeling Crunch	41
Cable Kneeling Crunch	44
Cable Kneeling Crunch	45
Cable Kneeling Crunch	46
Cable Kneeling Crunch	47
Cable Kneeling Crunch	53
Cable Overhead Seated Crunch	12
Cable Overhead Seated Crunch	23
Cable Overhead Seated Crunch	29
Cable Overhead Seated Crunch	41
Cable Overhead Seated Crunch	45
Cable Standing Overhead Crunch	12
Cable Standing Overhead Crunch	21
Cable Standing Overhead Crunch	23
Cable Standing Overhead Crunch	27
Cable Standing Overhead Crunch	28
Cable Standing Overhead Crunch	29
Cable Standing Overhead Crunch	33
Cable Standing Overhead Crunch	38
Cable Standing Overhead Crunch	41
Cable Standing Overhead Crunch	44
Cable Standing Overhead Crunch	45
Cable Standing Overhead Crunch	46
Cable Standing Overhead Crunch	47
Cable Standing Overhead Crunch	53
Dumbbell Push Sit-up	10
Dumbbell Push Sit-up	11
Dumbbell Push Sit-up	27
Dumbbell Push Sit-up	28
Dumbbell Push Sit-up	31
Dumbbell Push Sit-up	38
Dumbbell Push Sit-up	41
Dumbbell Push Sit-up	47
Lever Lying Crunch	12
Lever Lying Crunch	23
Lever Lying Crunch	28
Lever Lying Crunch	29
Lever Lying Crunch	38
Lever Lying Leg-Hip Raise	6
Lever Lying Leg-Hip Raise	12
Lever Lying Leg-Hip Raise	23
Lever Lying Leg-Hip Raise	28
Lever Lying Leg-Hip Raise	29
Lever Lying Leg-Hip Raise	38
Lever Push Crunch	6
Lever Push Crunch	10
Lever Push Crunch	16
Lever Push Crunch	28
Lever Push Crunch	38
Lever Push Crunch	41
Lever Seated Crunch	12
Lever Seated Crunch	23
Lever Seated Crunch	28
Lever Seated Crunch	29
Lever Seated Crunch	38
Lever Seated Leg Raise Crunch	12
Lever Seated Leg Raise Crunch	23
Lever Seated Leg Raise Crunch	26
Lever Seated Leg Raise Crunch	28
Lever Seated Leg Raise Crunch	29
Lever Seated Leg Raise Crunch	38
Lever Seated Leg Raise Crunch	44
Lever Seated Leg Raise Crunch	46
Lever Seated Leg Raise Crunch	53
Lever Side Lying Leg Hip Raise	12
Lever Side Lying Leg Hip Raise	20
Lever Side Lying Leg Hip Raise	23
Lever Side Lying Leg Hip Raise	28
Lever Side Lying Leg Hip Raise	29
Lever Side Lying Leg Hip Raise	38
Crunch Up	40
Incline Crunch	31
Incline Leg-Hip Raise	6
Incline Leg-Hip Raise	12
Incline Leg-Hip Raise	23
Incline Leg-Hip Raise	28
Incline Leg-Hip Raise	29
Incline Leg-Hip Raise	38
Lying Leg-Hip Raise	6
Lying Leg-Hip Raise	12
Lying Leg-Hip Raise	23
Lying Leg-Hip Raise	28
Lying Leg-Hip Raise	29
Lying Leg-Hip Raise	38
Leg-Hip Raise (on stability ball)	6
Leg-Hip Raise (on stability ball)	12
Leg-Hip Raise (on stability ball)	23
Leg-Hip Raise (on stability ball)	28
Leg-Hip Raise (on stability ball)	29
Leg-Hip Raise (on stability ball)	38
Vertical Leg-Hip Raise	23
Vertical Leg-Hip Raise	28
Vertical Leg-Hip Raise	33
Vertical Leg-Hip Raise	41
Vertical Straight Leg-Hip Raise (parallel bars)	10
Vertical Straight Leg-Hip Raise (parallel bars)	12
Vertical Straight Leg-Hip Raise (parallel bars)	23
Vertical Straight Leg-Hip Raise (parallel bars)	28
Vertical Straight Leg-Hip Raise (parallel bars)	33
Vertical Straight Leg-Hip Raise (parallel bars)	38
Vertical Straight Leg-Hip Raise (parallel bars)	41
Incline Sit-up	31
Sit-up	31
Suspended Jack-knife	6
Suspended Jack-knife	10
Suspended Jack-knife	27
Suspended Jack-knife	38
Suspended Jack-knife	44
Suspended Jack-knife	47
Suspended Jack-knife Pike	6
Suspended Jack-knife Pike	10
Suspended Jack-knife Pike	27
Suspended Jack-knife Pike	33
Suspended Jack-knife Pike	34
Suspended Jack-knife Pike	35
Suspended Jack-knife Pike	38
Suspended Jack-knife Pike	44
Suspended Jack-knife Pike	47
Suspended Standing Rollout	1
Suspended Standing Rollout	6
Suspended Standing Rollout	21
Suspended Standing Rollout	25
Suspended Standing Rollout	26
Suspended Standing Rollout	27
Suspended Standing Rollout	38
Suspended Standing Rollout	40
Suspended Standing Rollout	44
Suspended Standing Rollout	46
Suspended Standing Rollout	53
Cable Kneeling Twisting Crunch	12
Cable Kneeling Twisting Crunch	21
Cable Kneeling Twisting Crunch	23
Cable Kneeling Twisting Crunch	27
Cable Kneeling Twisting Crunch	28
Cable Kneeling Twisting Crunch	29
Cable Kneeling Twisting Crunch	33
Cable Kneeling Twisting Crunch	38
Cable Kneeling Twisting Crunch	41
Cable Kneeling Twisting Crunch	44
Cable Kneeling Twisting Crunch	45
Cable Kneeling Twisting Crunch	46
Cable Kneeling Twisting Crunch	47
Cable Kneeling Twisting Crunch	53
Cable Side Bend	17
Cable Side Bend	18
Cable Side Bend	24
Cable Side Bend	34
Cable Side Bend	35
Cable Side Crunch	3
Cable Side Crunch	4
Cable Side Crunch	5
Cable Side Crunch	23
Cable Side Crunch	24
Cable Side Crunch	28
Cable Side Crunch	29
Cable Side Crunch	33
Cable Side Crunch	38
Cable Side Crunch	41
Cable Side Crunch	45
Cable Seated Twist	1
Cable Seated Twist	10
Cable Seated Twist	11
Cable Seated Twist	12
Cable Seated Twist	14
Cable Seated Twist	27
Cable Seated Twist	28
Cable Seated Twist	33
Cable Seated Twist	34
Cable Seated Twist	38
Cable Seated Twist	41
Cable Seated Twist	44
Cable Seated Twist	45
Cable Seated Cross Arm Twist	1
Cable Seated Cross Arm Twist	12
Cable Seated Cross Arm Twist	28
Cable Seated Cross Arm Twist	33
Cable Seated Cross Arm Twist	34
Cable Seated Cross Arm Twist	41
Cable Seated Cross Arm Twist	45
Cable Seated Cross Arm Twist	47
Dumbbell Russian Twist (on stability ball)	11
Dumbbell Russian Twist (on stability ball)	12
Dumbbell Russian Twist (on stability ball)	14
Dumbbell Russian Twist (on stability ball)	16
Dumbbell Russian Twist (on stability ball)	27
Dumbbell Russian Twist (on stability ball)	28
Dumbbell Russian Twist (on stability ball)	33
Dumbbell Russian Twist (on stability ball)	34
Dumbbell Russian Twist (on stability ball)	38
Dumbbell Russian Twist (on stability ball)	41
Dumbbell Russian Twist (on stability ball)	45
Dumbbell Side Bend	17
Dumbbell Side Bend	18
Dumbbell Side Bend	24
Dumbbell Side Bend	34
Dumbbell Side Bend	35
Lever Seated Side Bend	23
Lever Seated Side Bend	24
Lever Seated Side Bend	28
Lever Seated Side Bend	29
Lever Seated Side Bend	45
Lever Seated Twist	8
Lever Seated Twist	9
Lever Seated Twist	10
Lever Seated Twist	16
Lever Seated Twist	17
Lever Seated Twist	18
Lever Seated Twist	27
Lever Seated Twist	28
Lever Seated Side Crunch	12
Lever Seated Side Crunch	23
Lever Seated Side Crunch	28
Lever Seated Side Crunch	29
Lever Seated Side Crunch	38
Lever Standing Side Bend	17
Lever Standing Side Bend	18
Lever Standing Side Bend	24
Lever Standing Side Bend	34
Lever Standing Side Bend	35
Lying Twist	1
Lying Twist	12
Lying Twist	33
Lying Twist	34
Lying Twist	38
Lying Twist	45
Bent-knee Lying Twist	1
Bent-knee Lying Twist	12
Bent-knee Lying Twist	33
Bent-knee Lying Twist	34
Bent-knee Lying Twist	38
Bent-knee Lying Twist	45
Hanging Twisting Leg Raise	44
Vertical Twisting Leg Raise	23
Vertical Twisting Leg Raise	25
Vertical Twisting Leg Raise	28
Vertical Twisting Leg Raise	33
Vertical Twisting Leg Raise	41
Vertical Twisting Leg Raise	44
Vertical Twisting Leg Raise (on dip bar)	10
Vertical Twisting Leg Raise (on dip bar)	12
Vertical Twisting Leg Raise (on dip bar)	23
Vertical Twisting Leg Raise (on dip bar)	25
Vertical Twisting Leg Raise (on dip bar)	28
Vertical Twisting Leg Raise (on dip bar)	33
Vertical Twisting Leg Raise (on dip bar)	38
Vertical Twisting Leg Raise (on dip bar)	41
Vertical Twisting Leg Raise (on dip bar)	44
Incline Twisting Sit-up	31
Twisting Sit-up	31
Incline Twisting Crunch	31
Hanging Windshield Wiper	1
Hanging Windshield Wiper	12
Hanging Windshield Wiper	21
Hanging Windshield Wiper	23
Hanging Windshield Wiper	26
Hanging Windshield Wiper	27
Hanging Windshield Wiper	28
Hanging Windshield Wiper	29
Hanging Windshield Wiper	33
Hanging Windshield Wiper	34
Hanging Windshield Wiper	38
Hanging Windshield Wiper	41
Hanging Windshield Wiper	44
Hanging Windshield Wiper	45
Hanging Windshield Wiper	46
Hanging Windshield Wiper	53
Suspended Pendulum	6
Suspended Pendulum	27
Suspended Pendulum	28
Suspended Pendulum	38
Suspended Pendulum	41
Suspended Pendulum	44
Suspended Pendulum	47
Suspended Pendulum	56
Suspended Twisting Jack-knife	6
Suspended Twisting Jack-knife	10
Suspended Twisting Jack-knife	27
Suspended Twisting Jack-knife	38
Suspended Twisting Jack-knife	44
Suspended Twisting Jack-knife	47
Lever Back Extension	1
Lever Back Extension	6
Lever Back Extension	16
Lever Back Extension	20
Back Extension (on stability ball, arms crossed)	49
Bird Dog	8
Bird Dog	9
Bird Dog	17
Bird Dog	18
Bird Dog	27
Bird Dog	28
Bird Dog	38
Bird Dog	47
Alternating Bird Dog	8
Alternating Bird Dog	9
Alternating Bird Dog	17
Alternating Bird Dog	18
Alternating Bird Dog	27
Alternating Bird Dog	28
Alternating Bird Dog	38
Alternating Bird Dog	47
Bird Dog (on stability ball)	27
Bird Dog (on stability ball)	28
Bird Dog (on stability ball)	38
Bird Dog (on stability ball)	47
Rear Bridge	16
Rear Bridge	23
Rear Bridge	24
Rear Bridge	33
Rear Bridge	34
Rear Bridge	38
Rear Bridge	45
Decline Rear Bridge	16
Single Leg Decline Rear Bridge	6
Single Leg Decline Rear Bridge	16
Incline Rear Bridge	16
Incline Rear Bridge	20
Incline Rear Bridge	23
Incline Rear Bridge	24
Incline Rear Bridge	33
Incline Rear Bridge	34
Incline Rear Bridge	38
Incline Rear Bridge	45
\.


--
-- Data for Name: _synergist; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public._synergist ("A", "B") FROM stdin;
Weighted Bench Dip	10
Weighted Bench Dip	23
Weighted Bench Dip	24
Weighted Bench Dip	27
Weighted Bench Dip	28
Weighted Bench Dip	41
Weighted Bench Dip	45
Weighted Close Grip Push-up	10
Weighted Close Grip Push-up	27
Weighted Close Grip Push-up	28
Weighted Triceps Dip	10
Weighted Triceps Dip	23
Weighted Triceps Dip	24
Weighted Triceps Dip	27
Barbell Close Grip Bench Press	10
Barbell Close Grip Bench Press	27
Barbell Close Grip Bench Press	28
Barbell Close Grip Incline Bench Press	10
Barbell Close Grip Incline Bench Press	27
Weighted Triceps Dip	28
Weighted Triceps Dip	41
Weighted Triceps Dip	45
Cable Triceps Dip	10
Cable Triceps Dip	23
Cable Triceps Dip	24
Cable Triceps Dip	27
Cable Triceps Dip	28
Cable Triceps Dip	41
Cable Triceps Dip	45
Weighted Neutral Grip Chin-up	3
Weighted Neutral Grip Chin-up	5
Weighted Neutral Grip Chin-up	12
Weighted Neutral Grip Chin-up	24
Weighted Neutral Grip Chin-up	28
Weighted Neutral Grip Chin-up	29
Weighted Neutral Grip Chin-up	33
Weighted Neutral Grip Chin-up	34
Weighted Neutral Grip Chin-up	41
Weighted Neutral Grip Chin-up	45
Weighted Parallel Close Grip Pull-up	3
Weighted Parallel Close Grip Pull-up	5
Weighted Parallel Close Grip Pull-up	12
Lever Seated Close Grip Press	10
Lever Seated Close Grip Press	27
Lever Seated Close Grip Press	28
Lever Close Grip Incline Bench Press	10
Lever Close Grip Incline Bench Press	27
Lever Triceps Dip	10
Lever Triceps Dip	23
Lever Triceps Dip	24
Lever Triceps Dip	27
Lever Triceps Dip	28
Lever Triceps Dip	41
Lever Triceps Dip	45
Lever Overhand Triceps Dip	10
Lever Overhand Triceps Dip	23
Lever Overhand Triceps Dip	24
Lever Overhand Triceps Dip	27
Lever Overhand Triceps Dip	28
Lever Overhand Triceps Dip	41
Lever Overhand Triceps Dip	45
Sled Standing Triceps Dip	10
Sled Standing Triceps Dip	23
Sled Standing Triceps Dip	24
Sled Standing Triceps Dip	27
Sled Standing Triceps Dip	28
Sled Standing Triceps Dip	41
Sled Standing Triceps Dip	45
Smith Close Grip Bench Press	10
Smith Close Grip Bench Press	27
Smith Close Grip Bench Press	28
Smith Close Grip Incline Bench Press	10
Smith Close Grip Incline Bench Press	27
Weighted Parallel Close Grip Pull-up	24
Weighted Parallel Close Grip Pull-up	28
Weighted Parallel Close Grip Pull-up	29
Weighted Parallel Close Grip Pull-up	33
Weighted Parallel Close Grip Pull-up	34
Weighted Parallel Close Grip Pull-up	41
Weighted Parallel Close Grip Pull-up	45
Weighted Inverted Row	3
Weighted Inverted Row	5
Weighted Inverted Row	12
Weighted Inverted Row	22
Weighted Inverted Row	23
Weighted Inverted Row	28
Weighted Inverted Row	29
Weighted Inverted Row	30
Weighted Inverted Row	33
Weighted Inverted Row	34
Weighted Inverted Row	45
Weighted Pull-up	3
Weighted Pull-up	4
Weighted Pull-up	5
Weighted Pull-up	12
Weighted Pull-up	22
Weighted Pull-up	24
Bench Dip	10
Bench Dip	23
Bench Dip	24
Bench Dip	27
Bench Dip	28
Bench Dip	41
Bench Dip	45
Weighted Pull-up	29
Weighted Pull-up	30
Weighted Pull-up	33
Weighted Pull-up	34
Weighted Pull-up	41
Weighted Pull-up	45
Weighted Neutral Grip Pull-up	3
Weighted Neutral Grip Pull-up	4
Weighted Neutral Grip Pull-up	5
Weighted Neutral Grip Pull-up	24
Weighted Neutral Grip Pull-up	28
Weighted Neutral Grip Pull-up	29
Weighted Neutral Grip Pull-up	33
Weighted Neutral Grip Pull-up	41
Close Grip Push-up	10
Close Grip Push-up	27
Close Grip Push-up	28
Close Grip Decline Pushup	10
Close Grip Decline Pushup	27
Close Grip Decline Pushup	28
Weighted Neutral Grip Pull-up	45
Weighted Chin-up	3
Weighted Chin-up	5
Weighted Chin-up	12
Weighted Chin-up	24
Weighted Chin-up	28
Weighted Chin-up	29
Weighted Chin-up	33
Weighted Chin-up	34
Weighted Chin-up	41
Weighted Chin-up	45
Triceps Dip	10
Triceps Dip	23
Triceps Dip	24
Triceps Dip	27
Triceps Dip	28
Triceps Dip	41
Triceps Dip	45
Weighted Rear Pull-up	3
Weighted Rear Pull-up	4
Weighted Rear Pull-up	5
Weighted Rear Pull-up	24
Weighted Rear Pull-up	28
Weighted Rear Pull-up	29
Weighted Rear Pull-up	33
Suspended Triceps Dip	10
Suspended Triceps Dip	23
Suspended Triceps Dip	24
Suspended Triceps Dip	27
Suspended Triceps Dip	28
Suspended Triceps Dip	41
Suspended Triceps Dip	45
Weighted Rear Pull-up	41
Weighted Rear Pull-up	45
Weighted Chest Dip	10
Weighted Chest Dip	23
Weighted Chest Dip	24
Weighted Chest Dip	27
Weighted Chest Dip	29
Weighted Chest Dip	38
Weighted Chest Dip	41
Weighted Chest Dip	45
Weighted Push-up	10
Weighted Push-up	27
Weighted Push-up	38
Barbell Curl	3
Barbell Curl	5
Barbell Drag Curl	3
Barbell Drag Curl	5
Barbell Drag Curl	10
Barbell Drag Curl	12
Cable Alternating Curl	3
Cable Alternating Curl	5
Cable Curl	3
Cable Curl	5
Cable Bar Curl	3
Cable Bar Curl	5
Cable Seated Curl	3
Cable Seated Curl	5
Cable One Arm Curl	3
Cable One Arm Curl	5
Cable Supine Curl	3
Cable Supine Curl	5
Dumbbell Curl	3
Dumbbell Curl	5
Dumbbell Seated Curl	3
Dumbbell Seated Curl	5
Dumbbell Incline Curl	3
Dumbbell Incline Curl	5
Lever Curl	3
Lever Curl	5
Lever Alternating Curl	3
Lever Alternating Curl	5
Chin-up	3
Chin-up	5
Chin-up	12
Chin-up	24
Chin-up	28
Chin-up	29
Chin-up	33
Chin-up	34
Chin-up	41
Chin-up	45
Inverted Biceps Row	3
Inverted Biceps Row	5
Inverted Biceps Row	12
Inverted Biceps Row	22
Inverted Biceps Row	23
Inverted Biceps Row	28
Inverted Biceps Row	29
Inverted Biceps Row	30
Inverted Biceps Row	33
Inverted Biceps Row	34
Inverted Biceps Row	45
Barbell Preacher Curl	3
Barbell Preacher Curl	4
Barbell Standing Preacher Curl	3
Barbell Standing Preacher Curl	4
Barbell Prone Incline Curl	3
Barbell Prone Incline Curl	4
Cable Concentration Curl	3
Cable Concentration Curl	4
Cable Preacher Curl	3
Cable Preacher Curl	4
Cable Alternating Preacher Curl	3
Cable Alternating Preacher Curl	4
Cable Standing Preacher Curl	3
Cable Standing Preacher Curl	4
Cable One Arm Standing Preacher Curl	3
Cable One Arm Standing Preacher Curl	4
Cable One Arm Preacher Curl	3
Cable One Arm Preacher Curl	4
Cable Prone Incline Curl	3
Cable Prone Incline Curl	4
Dumbbell Concentration Curl	3
Dumbbell Concentration Curl	4
Dumbbell Preacher Curl	3
Dumbbell Preacher Curl	4
Dumbbell Standing Preacher Curl	3
Dumbbell Standing Preacher Curl	4
Dumbbell Prone Incline Curl	3
Weighted Reverse Hyper-extension	20
Weighted Single Leg Squat	1
Dumbbell Prone Incline Curl	4
Weighted Single Leg Squat	14
Weighted Single Leg Squat	16
Weighted Single Leg Squat	48
Weighted Lying Hip Abduction	17
Weighted Lying Hip Abduction	18
Weighted Lying Hip Abduction	53
Weighted Hanging Leg Raise	1
Weighted Hanging Leg Raise	26
Lever Preacher Curl	3
Lever Preacher Curl	4
Lever Alternating Preacher Curl (arms high)	3
Lever Alternating Preacher Curl (arms high)	4
Lever Standing Preacher Curl	3
Lever Standing Preacher Curl	4
Suspended Arm Curl	3
Suspended Arm Curl	4
Barbell Bent-over Row	3
Barbell Bent-over Row	5
Barbell Bent-over Row	12
Barbell Bent-over Row	22
Barbell Bent-over Row	23
Barbell Bent-over Row	28
Barbell Bent-over Row	29
Barbell Bent-over Row	30
Barbell Bent-over Row	33
Barbell Bent-over Row	34
Barbell Bent-over Row	45
Barbell Close Grip Bent-over Row	3
Barbell Close Grip Bent-over Row	5
Barbell Close Grip Bent-over Row	12
Barbell Close Grip Bent-over Row	22
Barbell Close Grip Bent-over Row	23
Barbell Close Grip Bent-over Row	28
Barbell Close Grip Bent-over Row	29
Barbell Close Grip Bent-over Row	30
Barbell Close Grip Bent-over Row	33
Barbell Close Grip Bent-over Row	34
Barbell Close Grip Bent-over Row	45
Barbell Underhand Bent-over Row	3
Barbell Underhand Bent-over Row	5
Barbell Underhand Bent-over Row	12
Barbell Underhand Bent-over Row	22
Barbell Underhand Bent-over Row	23
Barbell Underhand Bent-over Row	28
Barbell Underhand Bent-over Row	29
Barbell Underhand Bent-over Row	30
Barbell Underhand Bent-over Row	33
Barbell Underhand Bent-over Row	34
Barbell Underhand Bent-over Row	45
Weighted Hanging Leg Raise	46
Weighted Hanging Leg Raise	53
Weighted Hanging Straight Leg Raise	1
Weighted Hanging Straight Leg Raise	26
Weighted Hanging Straight Leg Raise	44
Weighted Hanging Straight Leg Raise	46
Weighted Hanging Straight Leg Raise	53
Weighted Incline Leg Raise	1
Weighted Incline Leg Raise	26
Weighted Incline Leg Raise	46
Weighted Incline Leg Raise	53
Cable Incline Row	3
Cable Incline Row	5
Cable Incline Row	12
Cable Incline Row	14
Cable Incline Row	22
Cable Incline Row	23
Cable Incline Row	28
Cable Incline Row	29
Cable Incline Row	30
Cable Incline Row	33
Cable Incline Row	34
Cable Incline Row	45
Cable Straight Back Incline Row	3
Cable Straight Back Incline Row	5
Cable Straight Back Incline Row	12
Cable Straight Back Incline Row	22
Cable Straight Back Incline Row	23
Cable Straight Back Incline Row	28
Cable Straight Back Incline Row	29
Cable Straight Back Incline Row	30
Cable Straight Back Incline Row	33
Cable Straight Back Incline Row	34
Cable Straight Back Incline Row	45
Cable Kneeling Row	3
Cable Kneeling Row	5
Cable Kneeling Row	12
Cable Kneeling Row	22
Cable Kneeling Row	23
Cable Kneeling Row	28
Cable Kneeling Row	29
Cable Kneeling Row	30
Cable Kneeling Row	33
Cable Kneeling Row	34
Cable Kneeling Row	45
Cable Lying Row	3
Cable Lying Row	5
Cable Lying Row	12
Cable Lying Row	22
Cable Lying Row	23
Cable Lying Row	28
Cable Lying Row	29
Cable Lying Row	30
Cable Lying Row	33
Cable Lying Row	34
Cable Lying Row	45
Cable One Arm Bent-over Row	3
Cable One Arm Bent-over Row	5
Cable One Arm Bent-over Row	12
Cable One Arm Bent-over Row	22
Cable One Arm Bent-over Row	23
Cable One Arm Bent-over Row	28
Cable One Arm Bent-over Row	29
Cable One Arm Bent-over Row	30
Cable One Arm Bent-over Row	33
Cable One Arm Bent-over Row	34
Cable One Arm Bent-over Row	45
Cable One Arm Seated Row	3
Cable One Arm Seated Row	5
Cable One Arm Seated Row	12
Cable One Arm Seated Row	14
Cable One Arm Seated Row	22
Cable One Arm Seated Row	23
Cable One Arm Seated Row	28
Cable One Arm Seated Row	29
Cable One Arm Seated Row	30
Cable One Arm Seated Row	33
Cable One Arm Seated Row	34
Cable One Arm Seated Row	45
Cable Twisting Seated Row	3
Cable Twisting Seated Row	5
Cable Twisting Seated Row	12
Cable Twisting Seated Row	14
Cable Twisting Seated Row	22
Cable Twisting Seated Row	23
Cable Twisting Seated Row	25
Cable Twisting Seated Row	28
Cable Twisting Seated Row	29
Cable Twisting Seated Row	30
Cable Twisting Seated Row	33
Cable Twisting Seated Row	34
Cable Twisting Seated Row	43
Cable Twisting Seated Row	45
Cable Twisting Seated Row	56
Cable Twisting Seated Row	57
Cable Twisting Seated Row	58
Cable One Arm Seated High Row	3
Cable One Arm Seated High Row	5
Cable One Arm Seated High Row	12
Cable One Arm Seated High Row	14
Cable One Arm Seated High Row	22
Cable One Arm Seated High Row	23
Cable One Arm Seated High Row	28
Cable One Arm Seated High Row	29
Cable One Arm Seated High Row	30
Cable One Arm Seated High Row	33
Cable One Arm Seated High Row	34
Cable One Arm Seated High Row	45
Cable One Arm Straight Back Seated High Row	3
Cable One Arm Straight Back Seated High Row	5
Cable One Arm Straight Back Seated High Row	12
Cable One Arm Straight Back Seated High Row	22
Cable One Arm Straight Back Seated High Row	23
Cable One Arm Straight Back Seated High Row	28
Cable One Arm Straight Back Seated High Row	29
Cable One Arm Straight Back Seated High Row	30
Cable One Arm Straight Back Seated High Row	33
Cable One Arm Straight Back Seated High Row	34
Cable One Arm Straight Back Seated High Row	45
Cable Twisting Seated High Row	3
Cable Twisting Seated High Row	5
Cable Twisting Seated High Row	12
Cable Twisting Seated High Row	22
Cable Twisting Seated High Row	23
Cable Twisting Seated High Row	25
Cable Twisting Seated High Row	28
Cable Twisting Seated High Row	29
Cable Twisting Seated High Row	30
Cable Twisting Seated High Row	33
Cable Twisting Seated High Row	34
Cable Twisting Seated High Row	43
Cable Twisting Seated High Row	45
Cable Twisting Seated High Row	56
Cable Twisting Seated High Row	57
Cable Twisting Seated High Row	58
Cable Seated High Row	3
Cable Seated High Row	5
Cable Seated High Row	12
Cable Seated High Row	14
Cable Seated High Row	22
Cable Seated High Row	23
Cable Seated High Row	28
Cable Seated High Row	29
Cable Seated High Row	30
Cable Seated High Row	33
Cable Seated High Row	34
Cable Seated High Row	45
Cable Alternating Seated High Row	3
Cable Alternating Seated High Row	5
Cable Alternating Seated High Row	12
Cable Alternating Seated High Row	22
Cable Alternating Seated High Row	23
Cable Alternating Seated High Row	25
Cable Alternating Seated High Row	28
Cable Alternating Seated High Row	29
Cable Alternating Seated High Row	30
Cable Alternating Seated High Row	33
Cable Alternating Seated High Row	34
Cable Alternating Seated High Row	43
Cable Alternating Seated High Row	45
Cable Seated Row	3
Cable Seated Row	5
Cable Seated Row	12
Cable Seated Row	14
Cable Seated Row	22
Cable Seated Row	23
Cable Seated Row	28
Cable Seated Row	29
Cable Seated Row	30
Cable Seated Row	33
Cable Seated Row	34
Cable Seated Row	45
Cable Straight Back Seated Row	3
Cable Straight Back Seated Row	5
Cable Straight Back Seated Row	12
Cable Straight Back Seated Row	22
Cable Straight Back Seated Row	23
Cable Straight Back Seated Row	28
Cable Straight Back Seated Row	29
Cable Straight Back Seated Row	30
Cable Straight Back Seated Row	33
Cable Straight Back Seated Row	34
Cable Straight Back Seated Row	45
Cable Wide Grip Seated Row	3
Cable Wide Grip Seated Row	5
Cable Wide Grip Seated Row	12
Cable Wide Grip Seated Row	14
Cable Wide Grip Seated Row	22
Cable Wide Grip Seated Row	23
Cable Wide Grip Seated Row	28
Cable Wide Grip Seated Row	29
Cable Wide Grip Seated Row	30
Cable Wide Grip Seated Row	33
Cable Wide Grip Seated Row	34
Cable Wide Grip Seated Row	45
Cable Wide Grip Straight Back Seated Row	3
Cable Wide Grip Straight Back Seated Row	5
Cable Wide Grip Straight Back Seated Row	12
Cable Wide Grip Straight Back Seated Row	22
Cable Wide Grip Straight Back Seated Row	23
Cable Wide Grip Straight Back Seated Row	28
Cable Wide Grip Straight Back Seated Row	29
Cable Wide Grip Straight Back Seated Row	30
Cable Wide Grip Straight Back Seated Row	33
Cable Wide Grip Straight Back Seated Row	34
Cable Wide Grip Straight Back Seated Row	45
Cable Standing Row	3
Cable Standing Row	5
Cable Standing Row	12
Cable Standing Row	22
Cable Standing Row	23
Cable Standing Row	28
Cable Standing Row	29
Cable Standing Row	30
Cable Standing Row	33
Cable Standing Row	34
Cable Standing Row	45
Cable Standing Low Row	3
Cable Standing Low Row	5
Cable Standing Low Row	12
Cable Standing Low Row	22
Cable Standing Low Row	23
Cable Standing Low Row	28
Cable Standing Low Row	29
Cable Standing Low Row	30
Cable Standing Low Row	33
Cable Standing Low Row	34
Cable Standing Low Row	45
Cable Twisting Standing High Row	3
Cable Twisting Standing High Row	5
Cable Twisting Standing High Row	12
Cable Twisting Standing High Row	22
Cable Twisting Standing High Row	23
Cable Twisting Standing High Row	25
Cable Twisting Standing High Row	28
Cable Twisting Standing High Row	29
Cable Twisting Standing High Row	30
Cable Twisting Standing High Row	33
Cable Twisting Standing High Row	34
Cable Twisting Standing High Row	43
Cable Twisting Standing High Row	45
Cable Twisting Standing High Row	56
Cable Twisting Standing High Row	57
Cable Twisting Standing High Row	58
Dumbbell Incline Row	3
Dumbbell Incline Row	5
Dumbbell Incline Row	12
Dumbbell Incline Row	22
Dumbbell Incline Row	23
Dumbbell Incline Row	28
Dumbbell Incline Row	29
Dumbbell Incline Row	30
Dumbbell Incline Row	33
Dumbbell Incline Row	34
Dumbbell Incline Row	45
Weighted Incline Straight Leg Raise	1
Weighted Incline Straight Leg Raise	26
Weighted Incline Straight Leg Raise	44
Weighted Incline Straight Leg Raise	46
Weighted Incline Straight Leg Raise	53
Weighted Lying Leg Raise	1
Weighted Lying Leg Raise	26
Weighted Lying Leg Raise	46
Weighted Lying Leg Raise	53
Weighted Seated Leg Raise	1
Weighted Seated Leg Raise	26
Weighted Seated Leg Raise	46
Weighted Seated Leg Raise	53
Weighted Vertical Leg Raise	1
Weighted Vertical Leg Raise	26
Weighted Vertical Leg Raise	46
Weighted Vertical Leg Raise	53
Weighted Vertical Straight Leg Raise	1
Weighted Vertical Straight Leg Raise	26
Weighted Vertical Straight Leg Raise	44
Weighted Vertical Straight Leg Raise	46
Weighted Vertical Straight Leg Raise	53
Weighted Glute-Ham Raise	1
Weighted Glute-Ham Raise	15
Weighted Glute-Ham Raise	16
Weighted Glute-Ham Raise	19
Weighted Glute-Ham Raise	42
Weighted Glute-Ham Raise	46
Weighted Crunch	25
Weighted Crunch (on stability ball)	25
Weighted Overhead Crunch (on stability ball)	25
Weighted Incline Crunch	25
Weighted Incline Sit-up	21
Weighted Incline Sit-up	25
Weighted Incline Sit-up	44
Weighted Incline Sit-up	46
Weighted Incline Sit-up	53
Weighted Sit-up	21
Weighted Sit-up	25
Weighted Sit-up	44
Weighted Sit-up	46
Weighted Sit-up	53
Weighted Hanging Leg-Hip Raise	1
Weighted Hanging Leg-Hip Raise	21
Weighted Hanging Leg-Hip Raise	25
Weighted Hanging Leg-Hip Raise	26
Weighted Hanging Leg-Hip Raise	46
Weighted Hanging Leg-Hip Raise	53
Weighted Incline Leg-Hip Raise	1
Weighted Incline Leg-Hip Raise	21
Weighted Incline Leg-Hip Raise	25
Weighted Incline Leg-Hip Raise	26
Weighted Incline Leg-Hip Raise	46
Weighted Incline Leg-Hip Raise	53
Weighted Lying Leg-Hip Raise	1
Weighted Lying Leg-Hip Raise	21
Weighted Lying Leg-Hip Raise	25
Weighted Lying Leg-Hip Raise	26
Weighted Lying Leg-Hip Raise	46
Weighted Lying Leg-Hip Raise	53
Weighted Vertical Leg-Hip Raise	1
Weighted Vertical Leg-Hip Raise	21
Weighted Vertical Leg-Hip Raise	25
Weighted Vertical Leg-Hip Raise	26
Weighted Vertical Leg-Hip Raise	44
Weighted Vertical Leg-Hip Raise	46
Weighted Vertical Leg-Hip Raise	53
Weighted V-up	1
Weighted V-up	21
Weighted V-up	25
Weighted V-up	26
Weighted V-up	44
Weighted V-up	46
Weighted V-up	53
Weighted Side Crunch	44
Weighted Side Crunch (on stability ball)	44
Weighted Twisting Crunch	44
Weighted Twisting Crunch	56
Weighted Twisting Crunch (on stability ball)	44
Weighted Incline Twisting Sit-up	21
Weighted Incline Twisting Sit-up	44
Weighted Incline Twisting Sit-up	46
Weighted Incline Twisting Sit-up	53
Weighted Twisting Sit-up	21
Weighted Twisting Sit-up	44
Weighted Twisting Sit-up	46
Weighted Twisting Sit-up	53
Weighted Lying Twist	43
Weighted Lying Twist	56
Weighted Lying Twist	57
Weighted Lying Twist	58
Weighted Bent-knee Lying Twist	43
Weighted Bent-knee Lying Twist	56
Weighted Bent-knee Lying Twist	57
Weighted Bent-knee Lying Twist	58
Weighted Russian Twist (on stability ball)	13
Weighted Russian Twist (on stability ball)	43
Weighted Russian Twist (on stability ball)	56
Weighted Russian Twist (on stability ball)	57
Weighted Russian Twist (on stability ball)	58
Weighted Side Bend (on stability ball)	43
Weighted Side Bend (on stability ball)	56
Weighted Side Bend (on stability ball)	57
Weighted Side Bend (on stability ball)	58
Weighted Hyperextension	1
Weighted Hyperextension	16
Weighted Hyperextension	20
Lever Seated High Row	3
Lever Seated High Row	5
Lever Seated High Row	12
Lever Seated High Row	14
Lever Seated High Row	22
Lever Seated High Row	23
Lever Seated High Row	28
Lever Seated High Row	29
Lever Seated High Row	30
Lever Seated High Row	33
Lever Seated High Row	34
Lever Seated High Row	45
Lever Alternating Seated High Row	3
Lever Alternating Seated High Row	5
Lever Alternating Seated High Row	12
Lever Alternating Seated High Row	22
Lever Alternating Seated High Row	23
Lever Alternating Seated High Row	28
Lever Alternating Seated High Row	29
Lever Alternating Seated High Row	30
Lever Alternating Seated High Row	33
Lever Alternating Seated High Row	34
Lever Alternating Seated High Row	45
Lever Seated Row	3
Lever Seated Row	5
Lever Seated Row	12
Lever Seated Row	22
Lever Seated Row	23
Lever Seated Row	28
Lever Seated Row	29
Lever Seated Row	30
Lever Seated Row	33
Lever Seated Row	34
Lever Seated Row	45
Lever Wide Grip Seated Row	3
Lever Wide Grip Seated Row	5
Lever Wide Grip Seated Row	12
Lever Wide Grip Seated Row	22
Lever Wide Grip Seated Row	23
Lever Wide Grip Seated Row	28
Lever Wide Grip Seated Row	29
Lever Wide Grip Seated Row	30
Lever Wide Grip Seated Row	33
Lever Wide Grip Seated Row	34
Lever Wide Grip Seated Row	45
Lever Underhand Seated Row	3
Lever Underhand Seated Row	5
Lever Underhand Seated Row	12
Lever Underhand Seated Row	22
Lever Underhand Seated Row	23
Lever Underhand Seated Row	28
Lever Underhand Seated Row	29
Lever Underhand Seated Row	30
Lever Underhand Seated Row	33
Lever Underhand Seated Row	34
Lever Underhand Seated Row	45
Lever Alternating Underhand Seated Row	3
Lever Alternating Underhand Seated Row	5
Lever Alternating Underhand Seated Row	12
Lever Alternating Underhand Seated Row	22
Lever Alternating Underhand Seated Row	23
Lever Alternating Underhand Seated Row	28
Lever Alternating Underhand Seated Row	29
Lever Alternating Underhand Seated Row	30
Lever Alternating Underhand Seated Row	33
Lever Alternating Underhand Seated Row	34
Lever Alternating Underhand Seated Row	45
Smith Bent-over Row	3
Smith Bent-over Row	5
Smith Bent-over Row	12
Smith Bent-over Row	22
Smith Bent-over Row	23
Smith Bent-over Row	28
Smith Bent-over Row	29
Smith Bent-over Row	30
Smith Bent-over Row	33
Smith Bent-over Row	34
Smith Bent-over Row	45
Inverted Row	3
Inverted Row	5
Inverted Row	12
Inverted Row	22
Inverted Row	23
Inverted Row	28
Inverted Row	29
Inverted Row	30
Inverted Row	33
Inverted Row	34
Inverted Row	45
Suspended Inverted Row	3
Suspended Inverted Row	5
Suspended Inverted Row	12
Suspended Inverted Row	22
Suspended Inverted Row	23
Suspended Inverted Row	28
Suspended Inverted Row	29
Suspended Inverted Row	30
Suspended Inverted Row	33
Suspended Inverted Row	34
Suspended Inverted Row	45
Suspended Row	3
Suspended Row	5
Suspended Row	12
Suspended Row	22
Suspended Row	23
Suspended Row	28
Suspended Row	29
Suspended Row	30
Suspended Row	33
Suspended Row	34
Suspended Row	45
Barbell Pullover	12
Barbell Pullover	24
Barbell Pullover	28
Barbell Pullover	29
Barbell Pullover	38
Barbell Pullover	41
Barbell Pullover	45
Cable Close Grip Pulldown	3
Cable Close Grip Pulldown	5
Cable Close Grip Pulldown	12
Cable Close Grip Pulldown	24
Cable Close Grip Pulldown	28
Cable Close Grip Pulldown	29
Cable Close Grip Pulldown	33
Cable Close Grip Pulldown	34
Cable Close Grip Pulldown	41
Cable Close Grip Pulldown	45
Cable Alternating Close Grip Pulldown	3
Cable Alternating Close Grip Pulldown	5
Cable Alternating Close Grip Pulldown	12
Cable Alternating Close Grip Pulldown	24
Cable Alternating Close Grip Pulldown	28
Cable Alternating Close Grip Pulldown	29
Cable Alternating Close Grip Pulldown	33
Cable Alternating Close Grip Pulldown	34
Cable Alternating Close Grip Pulldown	41
Cable Alternating Close Grip Pulldown	45
Cable One Arm Pulldown	3
Cable One Arm Pulldown	5
Cable One Arm Pulldown	12
Cable One Arm Pulldown	24
Cable One Arm Pulldown	28
Cable One Arm Pulldown	29
Cable One Arm Pulldown	33
Cable One Arm Pulldown	34
Cable One Arm Pulldown	41
Cable One Arm Pulldown	45
Cable One Arm Kneeling Pulldown	3
Cable One Arm Kneeling Pulldown	5
Cable One Arm Kneeling Pulldown	12
Cable One Arm Kneeling Pulldown	24
Cable One Arm Kneeling Pulldown	28
Cable One Arm Kneeling Pulldown	29
Cable One Arm Kneeling Pulldown	33
Cable One Arm Kneeling Pulldown	34
Cable One Arm Kneeling Pulldown	41
Cable One Arm Kneeling Pulldown	45
Cable Kneeling Bent-over Pulldown	3
Cable Kneeling Bent-over Pulldown	4
Cable Kneeling Bent-over Pulldown	5
Cable Kneeling Bent-over Pulldown	12
Cable Kneeling Bent-over Pulldown	24
Cable Kneeling Bent-over Pulldown	28
Cable Kneeling Bent-over Pulldown	29
Cable Kneeling Bent-over Pulldown	38
Cable Kneeling Bent-over Pulldown	41
Cable Kneeling Bent-over Pulldown	45
Cable Pulldown	3
Cable Pulldown	4
Cable Pulldown	5
Cable Pulldown	12
Cable Pulldown	22
Cable Pulldown	24
Cable Pulldown	29
Cable Pulldown	30
Cable Pulldown	33
Cable Pulldown	34
Cable Pulldown	41
Cable Pulldown	45
Cable Alternating Pulldown	3
Cable Alternating Pulldown	4
Cable Alternating Pulldown	5
Cable Alternating Pulldown	12
Cable Alternating Pulldown	22
Cable Alternating Pulldown	24
Cable Alternating Pulldown	29
Cable Alternating Pulldown	30
Cable Alternating Pulldown	33
Cable Alternating Pulldown	34
Cable Alternating Pulldown	41
Cable Alternating Pulldown	45
Cable Parallel Grip Pulldown	3
Cable Parallel Grip Pulldown	5
Cable Parallel Grip Pulldown	12
Cable Parallel Grip Pulldown	24
Cable Parallel Grip Pulldown	28
Cable Parallel Grip Pulldown	29
Cable Parallel Grip Pulldown	33
Cable Parallel Grip Pulldown	34
Cable Parallel Grip Pulldown	41
Cable Parallel Grip Pulldown	45
Cable Pullover	12
Cable Pullover	24
Cable Pullover	28
Cable Pullover	29
Cable Pullover	38
Cable Pullover	41
Cable Pullover	45
Cable Bent-over Pullover	12
Cable Bent-over Pullover	24
Cable Bent-over Pullover	28
Cable Bent-over Pullover	29
Cable Bent-over Pullover	38
Cable Bent-over Pullover	41
Cable Bent-over Pullover	45
Cable Chin-up	3
Cable Chin-up	5
Cable Chin-up	12
Cable Chin-up	24
Cable Chin-up	28
Cable Chin-up	29
Cable Chin-up	33
Cable Chin-up	34
Cable Chin-up	41
Cable Chin-up	45
Cable Parallel Close Grip Pull-up	3
Cable Parallel Close Grip Pull-up	5
Cable Parallel Close Grip Pull-up	12
Cable Parallel Close Grip Pull-up	24
Cable Parallel Close Grip Pull-up	28
Cable Parallel Close Grip Pull-up	29
Cable Parallel Close Grip Pull-up	33
Cable Parallel Close Grip Pull-up	34
Cable Parallel Close Grip Pull-up	41
Cable Parallel Close Grip Pull-up	45
Cable Pull-up	3
Cable Pull-up	4
Cable Pull-up	5
Cable Pull-up	12
Cable Pull-up	22
Cable Pull-up	24
Cable Pull-up	29
Cable Pull-up	30
Cable Pull-up	33
Cable Pull-up	34
Cable Pull-up	41
Cable Pull-up	45
Cable Rear Pull-up	3
Cable Rear Pull-up	4
Cable Rear Pull-up	5
Cable Rear Pull-up	24
Cable Rear Pull-up	28
Cable Rear Pull-up	29
Cable Rear Pull-up	33
Cable Rear Pull-up	41
Cable Rear Pull-up	45
Cable Rear Pulldown	3
Cable Rear Pulldown	4
Cable Rear Pulldown	5
Cable Rear Pulldown	24
Cable Rear Pulldown	28
Cable Rear Pulldown	29
Cable Rear Pulldown	33
Cable Rear Pulldown	41
Cable Rear Pulldown	45
Cable Alternating Standing Pulldown	3
Cable Alternating Standing Pulldown	4
Cable Alternating Standing Pulldown	5
Cable Alternating Standing Pulldown	12
Cable Alternating Standing Pulldown	22
Cable Alternating Standing Pulldown	24
Cable Alternating Standing Pulldown	29
Cable Alternating Standing Pulldown	30
Cable Alternating Standing Pulldown	33
Cable Alternating Standing Pulldown	34
Cable Alternating Standing Pulldown	41
Cable Alternating Standing Pulldown	45
Cable Twisting Standing Overhead Pull	3
Cable Twisting Standing Overhead Pull	5
Cable Twisting Standing Overhead Pull	12
Cable Twisting Standing Overhead Pull	24
Cable Twisting Standing Overhead Pull	25
Cable Twisting Standing Overhead Pull	28
Cable Twisting Standing Overhead Pull	29
Cable Twisting Standing Overhead Pull	33
Cable Twisting Standing Overhead Pull	34
Cable Twisting Standing Overhead Pull	41
Cable Twisting Standing Overhead Pull	43
Cable Twisting Standing Overhead Pull	45
Cable Twisting Standing Overhead Pull	56
Cable Twisting Standing Overhead Pull	57
Cable Twisting Standing Overhead Pull	58
Cable Underhand Pulldown	3
Cable Underhand Pulldown	5
Cable Underhand Pulldown	12
Cable Underhand Pulldown	24
Cable Underhand Pulldown	28
Cable Underhand Pulldown	29
Cable Underhand Pulldown	33
Cable Underhand Pulldown	34
Cable Underhand Pulldown	41
Cable Underhand Pulldown	45
Lever Close Grip Pulldown	3
Lever Close Grip Pulldown	5
Lever Close Grip Pulldown	12
Lever Close Grip Pulldown	24
Lever Close Grip Pulldown	28
Lever Close Grip Pulldown	29
Lever Close Grip Pulldown	33
Lever Close Grip Pulldown	34
Lever Close Grip Pulldown	41
Lever Close Grip Pulldown	45
Lever Front Pulldown	3
Lever Front Pulldown	4
Lever Front Pulldown	5
Lever Front Pulldown	12
Lever Front Pulldown	22
Lever Front Pulldown	24
Lever Front Pulldown	29
Lever Front Pulldown	30
Lever Front Pulldown	33
Lever Front Pulldown	34
Lever Front Pulldown	41
Lever Front Pulldown	45
Lever Iron Cross	24
Lever Iron Cross	28
Lever Iron Cross	29
Lever Iron Cross	33
Lever Iron Cross	41
Lever Iron Cross	45
Lever Pulldown (parallel grip)	3
Lever Pulldown (parallel grip)	4
Lever Pulldown (parallel grip)	5
Lever Pulldown (parallel grip)	24
Lever Pulldown (parallel grip)	28
Lever Pulldown (parallel grip)	29
Lever Pulldown (parallel grip)	33
Lever Pulldown (parallel grip)	41
Lever Pulldown (parallel grip)	45
Lever Pullover	12
Lever Pullover	24
Lever Pullover	28
Lever Pullover	29
Lever Pullover	38
Lever Pullover	41
Lever Pullover	45
Lever Underhand Pulldown	3
Lever Underhand Pulldown	5
Lever Underhand Pulldown	12
Lever Underhand Pulldown	24
Lever Underhand Pulldown	28
Lever Underhand Pulldown	29
Lever Underhand Pulldown	33
Lever Underhand Pulldown	34
Lever Underhand Pulldown	41
Lever Underhand Pulldown	45
Lever Alternating Underhand Pulldown	3
Lever Alternating Underhand Pulldown	5
Lever Alternating Underhand Pulldown	12
Lever Alternating Underhand Pulldown	24
Lever Alternating Underhand Pulldown	28
Lever Alternating Underhand Pulldown	29
Lever Alternating Underhand Pulldown	33
Lever Alternating Underhand Pulldown	34
Lever Alternating Underhand Pulldown	41
Lever Alternating Underhand Pulldown	45
Neutral Grip Chin-up	3
Neutral Grip Chin-up	5
Neutral Grip Chin-up	12
Neutral Grip Chin-up	24
Neutral Grip Chin-up	28
Neutral Grip Chin-up	29
Neutral Grip Chin-up	33
Neutral Grip Chin-up	34
Neutral Grip Chin-up	41
Neutral Grip Chin-up	45
Parallel Close Grip Pull-up	3
Parallel Close Grip Pull-up	5
Parallel Close Grip Pull-up	12
Parallel Close Grip Pull-up	24
Parallel Close Grip Pull-up	28
Parallel Close Grip Pull-up	29
Parallel Close Grip Pull-up	33
Parallel Close Grip Pull-up	34
Parallel Close Grip Pull-up	41
Parallel Close Grip Pull-up	45
Pull-up	3
Pull-up	4
Pull-up	5
Pull-up	12
Pull-up	22
Pull-up	24
Pull-up	29
Pull-up	30
Pull-up	33
Pull-up	34
Pull-up	41
Pull-up	45
Neutral Grip Pull-up	3
Neutral Grip Pull-up	4
Neutral Grip Pull-up	5
Neutral Grip Pull-up	24
Neutral Grip Pull-up	28
Neutral Grip Pull-up	29
Neutral Grip Pull-up	33
Neutral Grip Pull-up	41
Neutral Grip Pull-up	45
Rear Pull-up	3
Rear Pull-up	4
Rear Pull-up	5
Rear Pull-up	24
Rear Pull-up	28
Rear Pull-up	29
Rear Pull-up	33
Rear Pull-up	41
Rear Pull-up	45
Suspended Pull-up	3
Suspended Pull-up	4
Suspended Pull-up	5
Suspended Pull-up	24
Suspended Pull-up	28
Suspended Pull-up	29
Suspended Pull-up	33
Suspended Pull-up	41
Suspended Pull-up	45
Stability Ball Rollout	12
Stability Ball Rollout	23
Stability Ball Rollout	28
Stability Ball Rollout	29
Stability Ball Rollout	41
Stability Ball Rollout	45
Suspended Kneeling Rollout	12
Suspended Kneeling Rollout	23
Suspended Kneeling Rollout	28
Suspended Kneeling Rollout	29
Suspended Kneeling Rollout	41
Suspended Kneeling Rollout	45
Barbell Shrug	24
Barbell Shrug	34
Trap Bar Shrug	24
Trap Bar Shrug	34
Cable Shrug	24
Cable Shrug	34
Cable Bar Shrug	24
Cable Bar Shrug	34
Cable One Arm Shrug	24
Cable One Arm Shrug	34
Dumbbell Shrug	24
Dumbbell Shrug	34
Lever Seated Gripless Shrug	24
Lever Seated Gripless Shrug	34
Lever Shrug	24
Lever Shrug	34
Sled Gripless Shrug	24
Sled Gripless Shrug	34
Smith Shrug	24
Smith Shrug	34
Cable Seated Shoulder External Rotation	12
Cable Seated Shoulder External Rotation	30
Cable Standing Shoulder External Rotation	12
Cable Standing Shoulder External Rotation	30
Cable Upright Shoulder External Rotation	12
Cable Upright Shoulder External Rotation	22
Cable Upright Shoulder External Rotation	52
Dumbbell Lying Shoulder External Rotation	12
Dumbbell Lying Shoulder External Rotation	30
Dumbbell Incline Shoulder External Rotation	12
Dumbbell Incline Shoulder External Rotation	30
Dumbbell Prone External Rotation	12
Dumbbell Prone External Rotation	30
Dumbbell Prone Incline External Rotation	12
Dumbbell Prone Incline External Rotation	30
Dumbbell Seated Shoulder External Rotation	12
Dumbbell Seated Shoulder External Rotation	22
Dumbbell Upright Shoulder External Rotation	12
Dumbbell Upright Shoulder External Rotation	22
Dumbbell Upright Shoulder External Rotation	52
Lever Shoulder External Rotation	12
Lever Shoulder External Rotation	30
Lever Upright Shoulder External Rotation	12
Lever Upright Shoulder External Rotation	22
Lever Upright Shoulder External Rotation	52
Suspended Shoulder External Rotation	12
Suspended Shoulder External Rotation	30
Suspended Shoulder External Rotation	33
Suspended Shoulder External Rotation	34
Suspended Shoulder External Rotation	45
Cable Seated Shoulder Internal Rotation	10
Cable Seated Shoulder Internal Rotation	23
Cable Seated Shoulder Internal Rotation	27
Cable Seated Shoulder Internal Rotation	28
Cable Seated Shoulder Internal Rotation	29
Cable Standing Shoulder Internal Rotation	10
Cable Standing Shoulder Internal Rotation	23
Cable Standing Shoulder Internal Rotation	27
Cable Standing Shoulder Internal Rotation	28
Cable Standing Shoulder Internal Rotation	29
Lever Shoulder Internal Rotation	10
Lever Shoulder Internal Rotation	23
Lever Shoulder Internal Rotation	27
Lever Shoulder Internal Rotation	28
Lever Shoulder Internal Rotation	29
Lever Upright Shoulder Internal Rotation	23
Lever Upright Shoulder Internal Rotation	28
Lever Upright Shoulder Internal Rotation	29
Barbell Bench Press	10
Barbell Bench Press	27
Barbell Bench Press	38
Barbell Decline Bench Press	10
Barbell Decline Bench Press	27
Barbell Decline Bench Press	38
Cable Chest Dip	10
Cable Chest Dip	23
Cable Chest Dip	24
Cable Chest Dip	27
Cable Chest Dip	29
Cable Chest Dip	38
Cable Chest Dip	41
Cable Chest Dip	45
Cable Decline Fly	4
Cable Decline Fly	10
Cable Decline Fly	27
Cable Lying Fly	4
Cable Lying Fly	10
Cable Lying Fly	27
Cable Seated Fly	4
Cable Seated Fly	10
Cable Seated Fly	27
Cable Standing Fly	23
Cable Standing Fly	24
Cable Standing Fly	27
Cable Standing Fly	41
Cable Standing Fly	45
Cable Bench Press	10
Cable Bench Press	27
Cable Bench Press	38
Cable Bar Bench Press	10
Cable Bar Bench Press	27
Cable Bar Bench Press	38
Cable Chest Press	10
Cable Chest Press	27
Cable Chest Press	38
Cable One Arm Chest Press	10
Cable One Arm Chest Press	27
Cable One Arm Chest Press	38
Cable Standing Chest Press	10
Cable Standing Chest Press	27
Cable Standing Chest Press	38
Cable Bar Standing Chest Press	10
Cable Bar Standing Chest Press	27
Cable Bar Standing Chest Press	38
Cable Bar Standing Chest Press	41
Cable Twisting Chest Press	10
Cable Twisting Chest Press	25
Cable Twisting Chest Press	27
Cable Twisting Chest Press	38
Cable Twisting Chest Press	47
Cable Decline Chest Press	10
Cable Decline Chest Press	27
Cable Decline Chest Press	38
Cable Bar Standing Decline Chest Press	10
Cable Bar Standing Decline Chest Press	27
Cable Bar Standing Decline Chest Press	38
Cable Bar Standing Decline Chest Press	41
Cable Standing Decline Chest Press	10
Cable Standing Decline Chest Press	27
Cable Standing Decline Chest Press	38
Cable Standing Decline Chest Press	41
Cable Twisting Standing Chest Press	1
Cable Twisting Standing Chest Press	10
Cable Twisting Standing Chest Press	16
Cable Twisting Standing Chest Press	17
Cable Twisting Standing Chest Press	25
Cable Twisting Standing Chest Press	27
Cable Twisting Standing Chest Press	38
Cable Twisting Standing Chest Press	43
Cable Twisting Standing Chest Press	47
Cable Twisting Standing Chest Press	53
Cable Twisting Standing Chest Press	56
Cable Twisting Standing Chest Press	57
Cable Twisting Standing Chest Press	58
Dumbbell Bench Press	10
Dumbbell Bench Press	27
Dumbbell Bench Press	38
Dumbbell Decline Bench Press	10
Dumbbell Decline Bench Press	27
Dumbbell Decline Bench Press	38
Dumbbell Decline Fly	4
Dumbbell Decline Fly	10
Dumbbell Decline Fly	27
Dumbbell Fly	4
Dumbbell Fly	10
Dumbbell Fly	27
Dumbbell Pullover	12
Dumbbell Pullover	23
Dumbbell Pullover	24
Dumbbell Pullover	29
Dumbbell Pullover	38
Dumbbell Pullover	41
Dumbbell Pullover	45
Lever Bent-over Fly	4
Lever Bent-over Fly	27
Lever Bent-over Fly	41
Lever Chest Dip	10
Lever Chest Dip	23
Lever Chest Dip	24
Lever Chest Dip	27
Lever Chest Dip	29
Lever Chest Dip	38
Lever Chest Dip	41
Lever Chest Dip	45
Lever Lying Fly	10
Lever Lying Fly	27
Lever Lying Fly	41
Lever Lying Fly	47
Lever Pec Deck Fly	27
Lever Pec Deck Fly	41
Lever Pec Deck Fly	47
Lever Decline Pec Deck Fly	27
Lever Decline Pec Deck Fly	41
Lever Seated Fly	4
Lever Seated Fly	10
Lever Seated Fly	27
Lever Seated Fly	41
Lever Seated Fly	47
Lever Seated Iron Cross Fly	23
Lever Seated Iron Cross Fly	24
Lever Seated Iron Cross Fly	27
Lever Seated Iron Cross Fly	41
Lever Seated Iron Cross Fly	45
Lever Bench Press	10
Lever Bench Press	27
Lever Bench Press	38
Lever Chest Press	10
Lever Chest Press	27
Lever Chest Press	38
Lever Alternating Chest Press	10
Lever Alternating Chest Press	27
Lever Alternating Chest Press	38
Lever Parallel Grip Chest Press	10
Lever Parallel Grip Chest Press	27
Lever Parallel Grip Chest Press	38
Lever Decline Chest Press	10
Lever Decline Chest Press	27
Lever Decline Chest Press	38
Lever Alternating Decline Chest Press	10
Lever Alternating Decline Chest Press	27
Lever Alternating Decline Chest Press	38
Lever Decline Bench Press	10
Lever Decline Bench Press	27
Lever Decline Bench Press	38
Sled Standing Chest Dip	10
Sled Standing Chest Dip	23
Sled Standing Chest Dip	24
Sled Standing Chest Dip	27
Sled Standing Chest Dip	29
Sled Standing Chest Dip	38
Sled Standing Chest Dip	41
Sled Standing Chest Dip	45
Sled Horizontal Grip Standing Chest Dip	10
Sled Horizontal Grip Standing Chest Dip	23
Sled Horizontal Grip Standing Chest Dip	24
Sled Horizontal Grip Standing Chest Dip	27
Sled Horizontal Grip Standing Chest Dip	29
Sled Horizontal Grip Standing Chest Dip	38
Sled Horizontal Grip Standing Chest Dip	41
Sled Horizontal Grip Standing Chest Dip	45
Smith Bench Press	10
Smith Bench Press	27
Smith Bench Press	38
Smith Decline Bench Press	10
Smith Decline Bench Press	27
Smith Decline Bench Press	38
Chest Dip	10
Chest Dip	23
Chest Dip	24
Chest Dip	27
Chest Dip	29
Chest Dip	38
Chest Dip	41
Chest Dip	45
Push-up	10
Push-up	27
Push-up	38
Incline Push-up	10
Incline Push-up	27
Incline Push-up	38
Push-up (on knees)	10
Push-up (on knees)	27
Push-up (on knees)	38
Suspended Chest Dip	10
Suspended Chest Dip	23
Suspended Chest Dip	24
Suspended Chest Dip	27
Suspended Chest Dip	29
Suspended Chest Dip	38
Suspended Chest Dip	41
Suspended Chest Dip	45
Suspended Chest Press	10
Suspended Chest Press	27
Suspended Chest Press	38
Suspended Fly	4
Suspended Fly	10
Suspended Fly	27
Cable Incline Bench Press	10
Cable Incline Bench Press	28
Cable Incline Bench Press	38
Cable Bar Incline Bench Press	10
Cable Bar Incline Bench Press	28
Cable Bar Incline Bench Press	38
Cable Incline Chest Press	10
Cable Incline Chest Press	28
Cable Incline Chest Press	38
Cable Standing Incline Chest Press	10
Cable Standing Incline Chest Press	28
Cable Standing Incline Chest Press	38
Cable Standing Incline Chest Press	47
Cable Bar Standing Incline Chest Press	10
Cable Bar Standing Incline Chest Press	28
Cable Bar Standing Incline Chest Press	38
Cable Bar Standing Incline Chest Press	47
Cable One Arm Standing Incline Chest Press	1
Cable One Arm Standing Incline Chest Press	10
Cable One Arm Standing Incline Chest Press	25
Cable One Arm Standing Incline Chest Press	28
Cable One Arm Standing Incline Chest Press	38
Cable One Arm Standing Incline Chest Press	43
Cable One Arm Standing Incline Chest Press	47
Cable One Arm Standing Incline Chest Press	56
Cable One Arm Standing Incline Chest Press	57
Cable One Arm Standing Incline Chest Press	58
Cable Incline Fly	4
Cable Incline Fly	10
Cable Incline Fly	28
Cable Standing Incline Fly	4
Cable Standing Incline Fly	10
Cable Standing Incline Fly	28
Dumbbell Incline Bench Press	10
Dumbbell Incline Bench Press	28
Dumbbell Incline Bench Press	38
Dumbbell Incline Fly	4
Dumbbell Incline Fly	10
Dumbbell Incline Fly	28
Lever Incline Bench Press	10
Lever Incline Bench Press	28
Lever Incline Bench Press	38
Lever Parallel Grip Incline Bench Press	10
Lever Parallel Grip Incline Bench Press	28
Lever Parallel Grip Incline Bench Press	38
Lever Incline Chest Press	10
Lever Incline Chest Press	28
Lever Incline Chest Press	38
Lever Alternating Incline Chest Press	10
Lever Alternating Incline Chest Press	28
Lever Alternating Incline Chest Press	38
Lever Parallel Grip Incline Chest Press	10
Lever Parallel Grip Incline Chest Press	28
Lever Parallel Grip Incline Chest Press	38
Lever Incline Fly	4
Lever Incline Fly	10
Lever Incline Fly	28
Smith Incline Bench Press	10
Smith Incline Bench Press	28
Smith Incline Bench Press	38
Decline Push-up	10
Decline Push-up	28
Decline Push-up	38
Pike Push-up	10
Pike Push-up	28
Pike Push-up	33
Pike Push-up	34
Pike Push-up	38
Pike Push-up	47
Cable Incline Shoulder Raise	27
Cable One Arm Incline Push	10
Cable One Arm Incline Push	25
Cable One Arm Incline Push	27
Cable One Arm Incline Push	38
Dumbbell Incline Shoulder Raise	27
Lever Incline Shoulder Raise	27
Smith Incline Shoulder Raise	27
Push-up Plus	10
Push-up Plus	27
Push-up Plus	28
Push-up Plus	38
Push-up Plus	41
Barbell Reverse Curl	4
Barbell Reverse Curl	5
Barbell Reverse Preacher Curl	4
Barbell Reverse Preacher Curl	5
Barbell Standing Reverse Preacher Curl	4
Barbell Standing Reverse Preacher Curl	5
Cable Hammer Curl	4
Cable Hammer Curl	5
Cable Reverse Curl	4
Cable Reverse Curl	5
Cable Bar Reverse Curl	4
Cable Bar Reverse Curl	5
Cable Reverse Preacher Curl	4
Cable Reverse Preacher Curl	5
Cable Standing Reverse Preacher Curl	4
Cable Standing Reverse Preacher Curl	5
Dumbbell Hammer Curl	4
Dumbbell Hammer Curl	5
Lever Hammer Preacher Curl	4
Lever Hammer Preacher Curl	5
Lever Reverse Curl	3
Lever Reverse Curl	5
Lever Reverse Preacher Curl	4
Lever Reverse Preacher Curl	5
Dumbbell Lying Supination	4
Dumbbell Seated Supination	4
Lever Seated Forearm Supination	4
Lever Standing Forearm Supination	4
Barbell Seated Good-morning	1
Barbell Seated Good-morning	20
Barbell Deadlift	1
Barbell Deadlift	6
Barbell Deadlift	16
Barbell Deadlift	20
Barbell Deadlift	48
Barbell Sumo Deadlift	1
Barbell Sumo Deadlift	6
Barbell Sumo Deadlift	16
Barbell Sumo Deadlift	48
Barbell Hip Thrust	6
Barbell Lunge	1
Barbell Lunge	16
Barbell Lunge	48
Barbell Alternating Lunge To Rear Lunge	1
Barbell Alternating Lunge To Rear Lunge	16
Barbell Alternating Lunge To Rear Lunge	48
Barbell Rear Lunge	1
Barbell Rear Lunge	16
Barbell Rear Lunge	48
Barbell Side Lunge	1
Barbell Side Lunge	16
Barbell Side Lunge	48
Barbell Walking Lunge	1
Barbell Walking Lunge	16
Barbell Walking Lunge	48
Barbell Single Leg Split Squat	1
Barbell Single Leg Split Squat	16
Barbell Single Leg Split Squat	48
Barbell Side Split Squat	1
Barbell Side Split Squat	16
Barbell Side Split Squat	48
Barbell Single Leg Squat	1
Barbell Single Leg Squat	14
Barbell Single Leg Squat	16
Barbell Single Leg Squat	48
Barbell Split Squat	1
Barbell Split Squat	16
Barbell Split Squat	48
Barbell Front Squat	1
Barbell Front Squat	16
Barbell Front Squat	48
Barbell Full Squat	1
Barbell Full Squat	16
Barbell Full Squat	48
Trap Bar Squat	1
Trap Bar Squat	16
Trap Bar Squat	48
Trap Bar Deadlift	1
Trap Bar Deadlift	6
Trap Bar Deadlift	16
Trap Bar Deadlift	48
Cable Glute Kickback	1
Cable Rear Lunge	1
Cable Rear Lunge	16
Cable Rear Lunge	48
Cable Rear Step-down Lunge	1
Cable Rear Step-down Lunge	16
Cable Rear Step-down Lunge	48
Cable Single Leg Split Squat	1
Cable Single Leg Split Squat	16
Cable Single Leg Split Squat	48
Cable One Arm Single Leg Split Squat	1
Cable One Arm Single Leg Split Squat	16
Cable One Arm Single Leg Split Squat	48
Cable Split Squat	1
Cable Split Squat	16
Cable Split Squat	48
Cable One Arm Split Squat	1
Cable One Arm Split Squat	16
Cable One Arm Split Squat	48
Cable Squat	1
Cable Squat	16
Cable Squat	48
Cable Bar Squat	1
Cable Bar Squat	16
Cable Bar Squat	48
Cable Belt Squat	1
Cable Belt Squat	16
Cable Belt Squat	48
Cable Standing Hip Extension	20
Cable Bent-over Hip Extension	20
Cable Step-up	1
Cable Step-up	15
Cable Step-up	16
Cable Step-up	48
Dumbbell Lunge	1
Dumbbell Lunge	16
Dumbbell Lunge	48
Dumbbell Alternating Side Lunge	1
Dumbbell Alternating Side Lunge	16
Dumbbell Alternating Side Lunge	48
Dumbbell Rear Lunge	1
Dumbbell Rear Lunge	16
Dumbbell Rear Lunge	48
Dumbbell Side Lunge	1
Dumbbell Side Lunge	16
Dumbbell Side Lunge	48
Dumbbell Walking Lunge	1
Dumbbell Walking Lunge	16
Dumbbell Walking Lunge	48
Dumbbell Single Leg Split Squat	1
Dumbbell Single Leg Split Squat	16
Dumbbell Single Leg Split Squat	48
Dumbbell Single Leg Squat	1
Dumbbell Single Leg Squat	14
Dumbbell Single Leg Squat	16
Dumbbell Single Leg Squat	48
Dumbbell Split Squat	1
Dumbbell Split Squat	16
Dumbbell Split Squat	48
Dumbbell Squat	1
Dumbbell Squat	16
Dumbbell Squat	48
Dumbbell Front Squat	1
Dumbbell Front Squat	16
Dumbbell Front Squat	48
Dumbbell Step-up	1
Dumbbell Step-up	15
Dumbbell Step-up	16
Dumbbell Step-up	48
Dumbbell Lateral Step-up	1
Dumbbell Lateral Step-up	15
Dumbbell Lateral Step-up	16
Dumbbell Lateral Step-up	48
Dumbbell Step Down	1
Dumbbell Step Down	15
Dumbbell Step Down	16
Dumbbell Step Down	48
Lever Hip Thrust	6
Lever Single Leg 45° Leg Press	1
Lever Single Leg 45° Leg Press	16
Lever Single Leg 45° Leg Press	48
Lever Front Squat	1
Lever Front Squat	6
Lever Front Squat	48
Lever Kneeling Hip Extension	1
Lever Alternating Kneeling Hip Extension	1
Lever Lying Hip Extension	1
Lever Standing Hip Extension	1
Lever Standing Hip Extension	20
Lever Alternating Lying Leg Press	1
Lever Alternating Lying Leg Press	16
Lever Alternating Lying Leg Press	48
Lever Seated Leg Press	1
Lever Seated Leg Press	16
Lever Seated Leg Press	48
Lever Single Leg Seated Leg Press	1
Lever Single Leg Seated Leg Press	16
Lever Single Leg Seated Leg Press	48
Lever Bent-over Glute Kickback	1
Lever Kneeling Glute Kickback	1
Lever Standing Glute Kickback	1
Lever Standing Glute Kickback	6
Lever Squat	1
Lever Squat	16
Lever Squat	48
Lever V-Squat	1
Lever V-Squat	16
Lever V-Squat	48
Lever Split V-Squat	1
Lever Split V-Squat	16
Lever Split V-Squat	48
Lever Single Leg Split V-Squat	1
Lever Single Leg Split V-Squat	16
Lever Single Leg Split V-Squat	48
Lever Alternating Single Leg Split V-Squat	1
Lever Alternating Single Leg Split V-Squat	16
Lever Alternating Single Leg Split V-Squat	48
Sled 45° Leg Press	1
Sled 45° Leg Press	16
Sled 45° Leg Press	48
Sled Alternating 45° Leg Press	1
Sled Alternating 45° Leg Press	16
Sled Alternating 45° Leg Press	48
Sled Single Leg 45° Leg Press	1
Sled Single Leg 45° Leg Press	16
Sled Single Leg 45° Leg Press	48
Sled Hack Press	1
Sled Hack Press	16
Sled Hack Press	48
Sled Lying Leg Press	1
Sled Lying Leg Press	16
Sled Lying Leg Press	48
Sled Single Leg Lying Leg Press	1
Sled Single Leg Lying Leg Press	16
Sled Single Leg Lying Leg Press	48
Sled Seated Leg Press	1
Sled Seated Leg Press	16
Sled Seated Leg Press	48
Sled Vertical Leg Press	1
Sled Vertical Leg Press	16
Sled Vertical Leg Press	48
Sled Single Leg Vertical Leg Press	1
Sled Single Leg Vertical Leg Press	16
Sled Single Leg Vertical Leg Press	48
Sled Kneeling Glute Kickback	1
Sled Standing Glute Kickback	1
Sled Standing Glute Kickback	6
Sled Rear Lunge	1
Sled Rear Lunge	16
Sled Rear Lunge	48
Sled Hack Squat	1
Sled Hack Squat	16
Sled Hack Squat	48
Sled Single Leg Hack Squat	1
Sled Single Leg Hack Squat	16
Sled Single Leg Hack Squat	48
Smith Bent Knee Good-morning	1
Smith Bent Knee Good-morning	16
Smith Bent Knee Good-morning	20
Smith Deadlift	1
Smith Deadlift	6
Smith Deadlift	16
Smith Deadlift	20
Smith Deadlift	48
Smith Rear Lunge	1
Smith Rear Lunge	16
Smith Rear Lunge	48
Smith Single Leg Split Squat	1
Smith Single Leg Split Squat	16
Smith Single Leg Split Squat	48
Smith Split Squat	1
Smith Split Squat	16
Smith Split Squat	48
Smith Squat	1
Smith Squat	16
Smith Squat	48
Smith Single Leg Squat	1
Smith Single Leg Squat	16
Smith Single Leg Squat	48
Smith Front Squat	1
Smith Front Squat	16
Smith Front Squat	48
Smith Hack Squat	1
Smith Hack Squat	16
Smith Hack Squat	48
Smith Wide Squat	1
Smith Wide Squat	16
Smith Wide Squat	48
Lunge	1
Lunge	16
Lunge	48
Rear Lunge	1
Rear Lunge	16
Rear Lunge	48
Reverse Hyper-extension	20
Single Leg Squat (pistol)	1
Single Leg Squat (pistol)	16
Single Leg Squat (pistol)	48
Single Leg Half Squat	1
Single Leg Half Squat	16
Single Leg Half Squat	48
Split Squat	1
Split Squat	16
Split Squat	48
Single Leg Split Squat	1
Single Leg Split Squat	16
Single Leg Split Squat	48
Squat	1
Squat	16
Squat	48
Half Squat	1
Half Squat	16
Half Squat	48
Step-up	1
Step-up	15
Step-up	16
Step-up	48
Lateral Step-up	1
Lateral Step-up	15
Lateral Step-up	16
Lateral Step-up	48
Step-down	1
Step-down	15
Step-down	16
Step-down	48
Alternating Step-down	1
Alternating Step-down	6
Alternating Step-down	15
Alternating Step-down	48
Suspended Reclining Squat	1
Suspended Reclining Squat	16
Suspended Reclining Squat	48
Suspended Single Leg Squat	1
Suspended Single Leg Squat	14
Suspended Single Leg Squat	16
Suspended Single Leg Squat	48
Suspended Single Leg Split Squat	1
Suspended Single Leg Split Squat	16
Suspended Single Leg Split Squat	48
Cable Hip Abduction	17
Cable Hip Abduction	18
Cable Hip Abduction	53
Cable Lying Hip Internal Rotation	17
Cable Lying Hip Internal Rotation	18
Cable Lying Hip Internal Rotation	53
Cable Seated Hip Internal Rotation	8
Cable Seated Hip Internal Rotation	17
Cable Seated Hip Internal Rotation	18
Cable Seated Hip Internal Rotation	53
Dumbbell Lying Hip Abduction	17
Dumbbell Lying Hip Abduction	18
Dumbbell Lying Hip Abduction	53
Lever Lying Hip Abduction	17
Lever Lying Hip Abduction	18
Lever Lying Hip Abduction	53
Lever Seated Hip Abduction	8
Lever Seated Hip Abduction	9
Lever Seated Hip Abduction	16
Lever Seated Hip Abduction	17
Lever Seated Hip Abduction	18
Lever Standing Hip Abduction	17
Lever Standing Hip Abduction	18
Lever Standing Hip Abduction	53
Cable Twist	1
Cable Twist	16
Cable Twist	17
Cable Twist	43
Cable Twist	53
Cable Twist	56
Cable Twist	57
Cable Twist	58
Side Bridge Hip Abduction	25
Side Bridge Hip Abduction	43
Side Bridge Hip Abduction	56
Side Bridge Hip Abduction	57
Side Bridge Hip Abduction	58
Angled Side Bridge Hip Abduction	11
Angled Side Bridge Hip Abduction	24
Angled Side Bridge Hip Abduction	25
Angled Side Bridge Hip Abduction	43
Angled Side Bridge Hip Abduction	56
Angled Side Bridge Hip Abduction	57
Angled Side Bridge Hip Abduction	58
Bent Knee Side Bridge Hip Abduction	25
Bent Knee Side Bridge Hip Abduction	43
Bent Knee Side Bridge Hip Abduction	56
Bent Knee Side Bridge Hip Abduction	57
Bent Knee Side Bridge Hip Abduction	58
Suspended Hip Abduction	17
Suspended Hip Abduction	18
Suspended Hip Abduction	53
Angled Side Bridge	1
Angled Side Bridge	11
Angled Side Bridge	16
Angled Side Bridge	17
Angled Side Bridge	18
Angled Side Bridge	19
Angled Side Bridge	24
Angled Side Bridge	26
Angled Side Bridge	33
Angled Side Bridge	34
Angled Side Bridge	43
Angled Side Bridge	47
Angled Side Bridge	52
Angled Side Bridge	53
Angled Side Bridge	56
Angled Side Bridge	57
Angled Side Bridge	58
Bent Knee Side Bridge	1
Bent Knee Side Bridge	11
Bent Knee Side Bridge	16
Bent Knee Side Bridge	17
Bent Knee Side Bridge	18
Bent Knee Side Bridge	24
Bent Knee Side Bridge	26
Bent Knee Side Bridge	33
Bent Knee Side Bridge	34
Bent Knee Side Bridge	43
Bent Knee Side Bridge	47
Bent Knee Side Bridge	52
Bent Knee Side Bridge	53
Bent Knee Side Bridge	56
Bent Knee Side Bridge	57
Bent Knee Side Bridge	58
Side Bridge	1
Side Bridge	11
Side Bridge	16
Side Bridge	17
Side Bridge	18
Side Bridge	19
Side Bridge	26
Side Bridge	33
Side Bridge	34
Side Bridge	43
Side Bridge	47
Side Bridge	52
Side Bridge	53
Side Bridge	56
Side Bridge	57
Side Bridge	58
Suspended Side Bend	1
Suspended Side Bend	16
Suspended Side Bend	17
Suspended Side Bend	18
Suspended Side Bend	19
Suspended Side Bend	26
Suspended Side Bend	43
Suspended Side Bend	53
Suspended Side Bend	56
Suspended Side Bend	57
Suspended Side Bend	58
Suspended Side Bridge	1
Suspended Side Bridge	11
Suspended Side Bridge	16
Suspended Side Bridge	17
Suspended Side Bridge	18
Suspended Side Bridge	19
Suspended Side Bridge	26
Suspended Side Bridge	33
Suspended Side Bridge	34
Suspended Side Bridge	43
Suspended Side Bridge	47
Suspended Side Bridge	52
Suspended Side Bridge	53
Suspended Side Bridge	56
Suspended Side Bridge	57
Suspended Side Bridge	58
Cable Lying Leg Raise	1
Cable Lying Leg Raise	26
Cable Lying Leg Raise	46
Cable Lying Leg Raise	53
Cable Lying Straight Leg Raise	1
Cable Lying Straight Leg Raise	26
Cable Lying Straight Leg Raise	44
Cable Lying Straight Leg Raise	46
Cable Lying Straight Leg Raise	53
Cable Standing Leg Raise	1
Cable Standing Leg Raise	26
Cable Standing Leg Raise	46
Cable Standing Leg Raise	53
Cable Standing Straight Leg Raise	1
Cable Standing Straight Leg Raise	26
Cable Standing Straight Leg Raise	44
Cable Standing Straight Leg Raise	46
Cable Standing Straight Leg Raise	53
Lever Hip Flexion	1
Lever Hip Flexion	26
Lever Hip Flexion	46
Lever Hip Flexion	53
Lever Lying Leg Raise	1
Lever Lying Leg Raise	26
Lever Lying Leg Raise	46
Lever Lying Leg Raise	53
Lever Vertical Leg Raise	1
Lever Vertical Leg Raise	26
Lever Vertical Leg Raise	46
Lever Vertical Leg Raise	53
Hanging Leg Raise	1
Hanging Leg Raise	26
Hanging Leg Raise	46
Hanging Leg Raise	53
Hanging Straight Leg Raise	1
Hanging Straight Leg Raise	26
Hanging Straight Leg Raise	44
Hanging Straight Leg Raise	46
Hanging Straight Leg Raise	53
Incline Leg Raise	1
Incline Leg Raise	26
Incline Leg Raise	46
Incline Leg Raise	53
Incline Straight Leg Raise	1
Incline Straight Leg Raise	26
Incline Straight Leg Raise	44
Incline Straight Leg Raise	46
Incline Straight Leg Raise	53
Lying Straight Leg Raise	1
Lying Straight Leg Raise	26
Lying Straight Leg Raise	44
Lying Straight Leg Raise	46
Lying Straight Leg Raise	53
Lying Simultaneous Alternating Straight Leg Raise	1
Lying Simultaneous Alternating Straight Leg Raise	26
Lying Simultaneous Alternating Straight Leg Raise	44
Lying Simultaneous Alternating Straight Leg Raise	46
Lying Simultaneous Alternating Straight Leg Raise	53
Seated Leg Raise	1
Seated Leg Raise	26
Seated Leg Raise	46
Seated Leg Raise	53
Vertical Leg Raise	1
Vertical Leg Raise	26
Vertical Leg Raise	46
Vertical Leg Raise	53
Vertical Straight Leg Raise	1
Vertical Straight Leg Raise	26
Vertical Straight Leg Raise	44
Vertical Straight Leg Raise	46
Vertical Straight Leg Raise	53
Jack-knife on Ball	1
Jack-knife on Ball	16
Jack-knife on Ball	26
Jack-knife on Ball	46
Jack-knife on Ball	53
Lying Scissor Kick	1
Lying Scissor Kick	26
Lying Scissor Kick	44
Lying Scissor Kick	46
Lying Scissor Kick	53
Jack-knife on Power Wheel	1
Jack-knife on Power Wheel	16
Jack-knife on Power Wheel	26
Jack-knife on Power Wheel	46
Jack-knife on Power Wheel	53
Pike on Power Wheel	1
Pike on Power Wheel	26
Pike on Power Wheel	46
Pike on Power Wheel	53
Pike on Discs	1
Pike on Discs	26
Pike on Discs	46
Pike on Discs	53
Suspended Mountain Climber	1
Suspended Mountain Climber	26
Suspended Mountain Climber	46
Suspended Mountain Climber	53
Suspended Pike	1
Suspended Pike	26
Suspended Pike	44
Suspended Pike	46
Suspended Pike	53
Cable Lying Hip External Rotation	6
Cable Lying Hip External Rotation	8
Cable Lying Hip External Rotation	9
Cable Lying Hip External Rotation	10
Cable Lying Hip External Rotation	16
Cable Lying Hip External Rotation	17
Cable Lying Hip External Rotation	46
Cable Seated Hip External Rotation	6
Cable Seated Hip External Rotation	9
Cable Seated Hip External Rotation	10
Cable Seated Hip External Rotation	16
Cable Seated Hip External Rotation	17
Cable Seated Hip External Rotation	46
Barbell Front Raise	11
Barbell Front Raise	27
Barbell Front Raise	33
Barbell Front Raise	34
Barbell Front Raise	47
Barbell Incline Front Raise	11
Barbell Incline Front Raise	27
Barbell Incline Front Raise	33
Barbell Incline Front Raise	34
Barbell Incline Front Raise	47
Barbell Military Press	11
Barbell Military Press	27
Barbell Military Press	33
Barbell Military Press	34
Barbell Military Press	38
Barbell Military Press	47
Barbell Seated Military Press	11
Barbell Seated Military Press	33
Barbell Seated Military Press	34
Barbell Seated Military Press	38
Barbell Seated Military Press	47
Barbell Seated Military Press	52
Barbell Shoulder Press	11
Barbell Shoulder Press	33
Barbell Shoulder Press	34
Barbell Shoulder Press	38
Barbell Shoulder Press	47
Barbell Shoulder Press	52
Barbell Reclined Shoulder Press	27
Barbell Reclined Shoulder Press	33
Barbell Reclined Shoulder Press	34
Barbell Reclined Shoulder Press	38
Barbell Reclined Shoulder Press	47
Barbell Reclined Shoulder Press	52
Cable Bar Behind Neck Press	11
Cable Bar Behind Neck Press	33
Cable Bar Behind Neck Press	34
Cable Bar Behind Neck Press	38
Cable Bar Behind Neck Press	47
Cable Bar Behind Neck Press	52
Cable Bar Front Raise	11
Cable Bar Front Raise	27
Cable Bar Front Raise	33
Cable Bar Front Raise	34
Cable Bar Front Raise	47
Cable Bar Military Press	11
Cable Bar Military Press	27
Cable Bar Military Press	33
Cable Bar Military Press	34
Cable Bar Military Press	38
Cable Bar Military Press	47
Cable Bar Shoulder Press	11
Cable Bar Shoulder Press	33
Cable Bar Shoulder Press	34
Cable Bar Shoulder Press	38
Cable Bar Shoulder Press	47
Cable Bar Shoulder Press	52
Cable Seated Front Raise	11
Cable Seated Front Raise	27
Cable Seated Front Raise	33
Cable Seated Front Raise	34
Cable Seated Front Raise	47
Cable Alternating Front Raise	11
Cable Alternating Front Raise	27
Cable Alternating Front Raise	33
Cable Alternating Front Raise	34
Cable Alternating Front Raise	47
Cable Alternating Seated Front Raise	11
Cable Alternating Seated Front Raise	27
Cable Alternating Seated Front Raise	33
Cable Alternating Seated Front Raise	34
Cable Alternating Seated Front Raise	47
Cable One Arm Front Raise	11
Cable One Arm Front Raise	27
Cable One Arm Front Raise	33
Cable One Arm Front Raise	34
Cable One Arm Front Raise	47
Cable Standing Shoulder Press	11
Cable Standing Shoulder Press	33
Cable Standing Shoulder Press	34
Cable Standing Shoulder Press	38
Cable Standing Shoulder Press	47
Cable Standing Shoulder Press	52
Cable Shoulder Press	11
Cable Shoulder Press	33
Cable Shoulder Press	34
Cable Shoulder Press	38
Cable Shoulder Press	47
Cable Shoulder Press	52
Cable Twisting Overhead Press	1
Cable Twisting Overhead Press	6
Cable Twisting Overhead Press	11
Cable Twisting Overhead Press	16
Cable Twisting Overhead Press	17
Cable Twisting Overhead Press	25
Cable Twisting Overhead Press	27
Cable Twisting Overhead Press	33
Cable Twisting Overhead Press	34
Cable Twisting Overhead Press	38
Cable Twisting Overhead Press	43
Cable Twisting Overhead Press	47
Cable Twisting Overhead Press	48
Cable Twisting Overhead Press	52
Cable Twisting Overhead Press	53
Cable Twisting Overhead Press	56
Cable Twisting Overhead Press	57
Cable Twisting Overhead Press	58
Dumbbell Arnold Press	11
Dumbbell Arnold Press	33
Dumbbell Arnold Press	34
Dumbbell Arnold Press	38
Dumbbell Arnold Press	47
Dumbbell Arnold Press	52
Dumbbell Front Raise	11
Dumbbell Front Raise	27
Dumbbell Front Raise	33
Dumbbell Front Raise	34
Dumbbell Front Raise	47
Dumbbell Alternating Front Raise	11
Dumbbell Alternating Front Raise	27
Dumbbell Alternating Front Raise	33
Dumbbell Alternating Front Raise	34
Dumbbell Alternating Front Raise	47
Dumbbell Alternating Incline Front Raise	11
Dumbbell Alternating Incline Front Raise	27
Dumbbell Alternating Incline Front Raise	33
Dumbbell Alternating Incline Front Raise	34
Dumbbell Alternating Incline Front Raise	47
Dumbbell Alternating Seated Front Raise	11
Dumbbell Alternating Seated Front Raise	27
Dumbbell Alternating Seated Front Raise	33
Dumbbell Alternating Seated Front Raise	34
Dumbbell Alternating Seated Front Raise	47
Dumbbell Seated Front Raise	11
Dumbbell Seated Front Raise	27
Dumbbell Seated Front Raise	33
Dumbbell Seated Front Raise	34
Dumbbell Seated Front Raise	47
Dumbbell Shoulder Press	11
Dumbbell Shoulder Press	27
Dumbbell Shoulder Press	33
Dumbbell Shoulder Press	34
Dumbbell Shoulder Press	38
Dumbbell Shoulder Press	47
Dumbbell Shoulder Press	52
Dumbbell One Arm Shoulder Press	11
Dumbbell One Arm Shoulder Press	25
Dumbbell One Arm Shoulder Press	27
Dumbbell One Arm Shoulder Press	33
Dumbbell One Arm Shoulder Press	34
Dumbbell One Arm Shoulder Press	38
Dumbbell One Arm Shoulder Press	47
Dumbbell One Arm Shoulder Press	52
Dumbbell One Arm Shoulder Press	56
Dumbbell One Arm Shoulder Press	57
Dumbbell One Arm Shoulder Press	58
Dumbbell Reclined Shoulder Press	27
Dumbbell Reclined Shoulder Press	33
Dumbbell Reclined Shoulder Press	34
Dumbbell Reclined Shoulder Press	38
Dumbbell Reclined Shoulder Press	47
Dumbbell Reclined Shoulder Press	52
Lever One Arm Front Raise	11
Lever One Arm Front Raise	27
Lever One Arm Front Raise	33
Lever One Arm Front Raise	34
Lever One Arm Front Raise	47
Lever Reclined Shoulder Press	11
Lever Reclined Shoulder Press	33
Lever Reclined Shoulder Press	34
Lever Reclined Shoulder Press	38
Lever Reclined Shoulder Press	47
Lever Reclined Shoulder Press	52
Lever Reclined Parallel Grip Shoulder Press	11
Lever Reclined Parallel Grip Shoulder Press	27
Lever Reclined Parallel Grip Shoulder Press	33
Lever Reclined Parallel Grip Shoulder Press	34
Lever Reclined Parallel Grip Shoulder Press	38
Lever Reclined Parallel Grip Shoulder Press	47
Lever Shoulder Press	11
Lever Shoulder Press	27
Lever Shoulder Press	33
Lever Shoulder Press	34
Lever Shoulder Press	38
Lever Shoulder Press	47
Lever Shoulder Press	52
Lever Alternating Shoulder Press	11
Lever Alternating Shoulder Press	27
Lever Alternating Shoulder Press	33
Lever Alternating Shoulder Press	34
Lever Alternating Shoulder Press	38
Lever Alternating Shoulder Press	47
Lever Alternating Shoulder Press	52
Sled Shoulder Press	11
Sled Shoulder Press	27
Sled Shoulder Press	33
Sled Shoulder Press	34
Sled Shoulder Press	38
Sled Shoulder Press	47
Sled Shoulder Press	52
Smith Behind Neck Press	11
Smith Behind Neck Press	33
Smith Behind Neck Press	34
Smith Behind Neck Press	38
Smith Behind Neck Press	47
Smith Behind Neck Press	52
Smith Shoulder Press	11
Smith Shoulder Press	27
Smith Shoulder Press	33
Smith Shoulder Press	34
Smith Shoulder Press	38
Smith Shoulder Press	47
Pike Press	11
Pike Press	27
Pike Press	33
Pike Press	34
Pike Press	38
Pike Press	47
Elevated Pike Press	11
Elevated Pike Press	27
Elevated Pike Press	33
Elevated Pike Press	34
Elevated Pike Press	38
Elevated Pike Press	47
Suspended Front Raise	11
Suspended Front Raise	27
Suspended Front Raise	33
Suspended Front Raise	34
Suspended Front Raise	47
Barbell Upright Row	3
Barbell Upright Row	4
Barbell Upright Row	5
Barbell Upright Row	10
Barbell Upright Row	22
Barbell Upright Row	30
Barbell Upright Row	33
Barbell Upright Row	34
Barbell Upright Row	47
Barbell Upright Row	52
Barbell Wide Grip Upright Row	3
Barbell Wide Grip Upright Row	4
Barbell Wide Grip Upright Row	5
Barbell Wide Grip Upright Row	10
Barbell Wide Grip Upright Row	22
Barbell Wide Grip Upright Row	30
Barbell Wide Grip Upright Row	33
Barbell Wide Grip Upright Row	34
Barbell Wide Grip Upright Row	47
Barbell Wide Grip Upright Row	52
Cable Lateral Raise	10
Cable Lateral Raise	33
Cable Lateral Raise	34
Cable Lateral Raise	47
Cable Lateral Raise	52
Cable One Arm Lateral Raise	10
Cable One Arm Lateral Raise	33
Cable One Arm Lateral Raise	34
Cable One Arm Lateral Raise	47
Cable One Arm Lateral Raise	52
Cable Seated Lateral Raise	10
Cable Seated Lateral Raise	33
Cable Seated Lateral Raise	34
Cable Seated Lateral Raise	47
Cable Seated Lateral Raise	52
Cable Upright Row	3
Cable Upright Row	4
Cable Upright Row	5
Cable Upright Row	10
Cable Upright Row	22
Cable Upright Row	30
Cable Upright Row	33
Cable Upright Row	34
Cable Upright Row	47
Cable Upright Row	52
Cable Bar Upright Row	3
Cable Bar Upright Row	4
Cable Bar Upright Row	5
Cable Bar Upright Row	10
Cable Bar Upright Row	22
Cable Bar Upright Row	30
Cable Bar Upright Row	33
Cable Bar Upright Row	34
Cable Bar Upright Row	47
Cable Bar Upright Row	52
Cable One Arm Upright Row	3
Cable One Arm Upright Row	4
Cable One Arm Upright Row	5
Cable One Arm Upright Row	10
Cable One Arm Upright Row	22
Cable One Arm Upright Row	30
Cable One Arm Upright Row	33
Cable One Arm Upright Row	34
Cable One Arm Upright Row	47
Cable One Arm Upright Row	52
Cable Wide Grip Upright Row	3
Cable Wide Grip Upright Row	4
Cable Wide Grip Upright Row	5
Cable Wide Grip Upright Row	10
Cable Wide Grip Upright Row	22
Cable Wide Grip Upright Row	30
Cable Wide Grip Upright Row	33
Cable Wide Grip Upright Row	34
Cable Wide Grip Upright Row	47
Cable Wide Grip Upright Row	52
Cable Y Raise	10
Cable Y Raise	12
Cable Y Raise	22
Cable Y Raise	30
Cable Y Raise	33
Cable Y Raise	34
Cable Y Raise	47
Cable Y Raise	52
Cable Seated Y Raise	10
Cable Seated Y Raise	12
Cable Seated Y Raise	22
Cable Seated Y Raise	30
Cable Seated Y Raise	33
Cable Seated Y Raise	34
Cable Seated Y Raise	47
Cable Seated Y Raise	52
Dumbbell Incline Lateral Raise	12
Dumbbell Incline Lateral Raise	33
Dumbbell Incline Lateral Raise	34
Dumbbell Incline Lateral Raise	47
Dumbbell Incline Lateral Raise	52
Dumbbell Incline Y Raise	10
Dumbbell Incline Y Raise	12
Dumbbell Incline Y Raise	22
Dumbbell Incline Y Raise	30
Dumbbell Incline Y Raise	33
Dumbbell Incline Y Raise	34
Dumbbell Incline Y Raise	47
Dumbbell Incline Y Raise	52
Dumbbell Lateral Raise	10
Dumbbell Lateral Raise	33
Dumbbell Lateral Raise	34
Dumbbell Lateral Raise	47
Dumbbell Lateral Raise	52
Dumbbell One Arm Lateral Raise	10
Dumbbell One Arm Lateral Raise	33
Dumbbell One Arm Lateral Raise	34
Dumbbell One Arm Lateral Raise	47
Dumbbell One Arm Lateral Raise	52
Dumbbell One Arm Seated Lateral Raise	10
Dumbbell One Arm Seated Lateral Raise	33
Dumbbell One Arm Seated Lateral Raise	34
Dumbbell One Arm Seated Lateral Raise	47
Dumbbell One Arm Seated Lateral Raise	52
Dumbbell Seated Lateral Raise	10
Dumbbell Seated Lateral Raise	33
Dumbbell Seated Lateral Raise	34
Dumbbell Seated Lateral Raise	47
Dumbbell Seated Lateral Raise	52
Dumbbell Lying Lateral Raise	12
Dumbbell Lying Lateral Raise	33
Dumbbell Lying Lateral Raise	34
Dumbbell Lying Lateral Raise	47
Dumbbell Lying Lateral Raise	52
Dumbbell Raise	3
Dumbbell Raise	4
Dumbbell Raise	5
Dumbbell Raise	12
Dumbbell Raise	22
Dumbbell Raise	30
Dumbbell Raise	33
Dumbbell Raise	34
Dumbbell Raise	47
Dumbbell Raise	52
Dumbbell Upright Row	3
Dumbbell Upright Row	4
Dumbbell Upright Row	5
Dumbbell Upright Row	10
Dumbbell Upright Row	22
Dumbbell Upright Row	30
Dumbbell Upright Row	33
Dumbbell Upright Row	34
Dumbbell Upright Row	47
Dumbbell Upright Row	52
Dumbbell One Arm Upright Row	3
Dumbbell One Arm Upright Row	4
Dumbbell One Arm Upright Row	5
Dumbbell One Arm Upright Row	10
Dumbbell One Arm Upright Row	22
Dumbbell One Arm Upright Row	30
Dumbbell One Arm Upright Row	33
Dumbbell One Arm Upright Row	34
Dumbbell One Arm Upright Row	47
Dumbbell One Arm Upright Row	52
Dumbbell Seated Upright Row	3
Dumbbell Seated Upright Row	4
Dumbbell Seated Upright Row	5
Dumbbell Seated Upright Row	10
Dumbbell Seated Upright Row	22
Dumbbell Seated Upright Row	30
Dumbbell Seated Upright Row	33
Dumbbell Seated Upright Row	34
Dumbbell Seated Upright Row	47
Dumbbell Seated Upright Row	52
Lever Lateral Raise	10
Lever Lateral Raise	33
Lever Lateral Raise	34
Lever Lateral Raise	47
Lever Lateral Raise	52
Lever Extended Arm Lateral Raise	10
Lever Extended Arm Lateral Raise	33
Lever Extended Arm Lateral Raise	34
Lever Extended Arm Lateral Raise	47
Lever Extended Arm Lateral Raise	52
Smith Upright Row	3
Smith Upright Row	4
Smith Upright Row	5
Smith Upright Row	10
Smith Upright Row	22
Smith Upright Row	30
Smith Upright Row	33
Smith Upright Row	34
Smith Upright Row	47
Smith Upright Row	52
Smith Wide Grip Upright Row	3
Smith Wide Grip Upright Row	4
Smith Wide Grip Upright Row	5
Smith Wide Grip Upright Row	10
Smith Wide Grip Upright Row	22
Smith Wide Grip Upright Row	30
Smith Wide Grip Upright Row	33
Smith Wide Grip Upright Row	34
Smith Wide Grip Upright Row	47
Smith Wide Grip Upright Row	52
Suspended Y Lateral Raise	10
Suspended Y Lateral Raise	22
Suspended Y Lateral Raise	30
Suspended Y Lateral Raise	33
Suspended Y Lateral Raise	34
Suspended Y Lateral Raise	47
Suspended Y Lateral Raise	52
Barbell Rear Delt Row	3
Barbell Rear Delt Row	5
Barbell Rear Delt Row	11
Barbell Rear Delt Row	22
Barbell Rear Delt Row	30
Barbell Rear Delt Row	33
Barbell Rear Delt Row	34
Barbell Rear Delt Row	45
Barbell Lying Rear Delt Row	3
Barbell Lying Rear Delt Row	5
Barbell Lying Rear Delt Row	11
Barbell Lying Rear Delt Row	22
Barbell Lying Rear Delt Row	30
Barbell Lying Rear Delt Row	33
Barbell Lying Rear Delt Row	34
Barbell Lying Rear Delt Row	45
Cable Reverse Fly	11
Cable Reverse Fly	22
Cable Reverse Fly	30
Cable Reverse Fly	33
Cable Reverse Fly	34
Cable Reverse Fly	45
Cable Seated Reverse Fly	11
Cable Seated Reverse Fly	22
Cable Seated Reverse Fly	30
Cable Seated Reverse Fly	33
Cable Seated Reverse Fly	34
Cable Seated Reverse Fly	45
Cable One Arm Reverse Fly	11
Cable One Arm Reverse Fly	22
Cable One Arm Reverse Fly	30
Cable One Arm Reverse Fly	33
Cable One Arm Reverse Fly	34
Cable One Arm Reverse Fly	43
Cable One Arm Reverse Fly	45
Cable Supine Reverse Fly	11
Cable Supine Reverse Fly	22
Cable Supine Reverse Fly	30
Cable Supine Reverse Fly	33
Cable Supine Reverse Fly	34
Cable Supine Reverse Fly	45
Cable Rear Delt Row	3
Cable Rear Delt Row	5
Cable Rear Delt Row	11
Cable Rear Delt Row	22
Cable Rear Delt Row	30
Cable Rear Delt Row	33
Cable Rear Delt Row	34
Cable Rear Delt Row	45
Cable One Arm Rear Delt Row	3
Cable One Arm Rear Delt Row	5
Cable One Arm Rear Delt Row	11
Cable One Arm Rear Delt Row	22
Cable One Arm Rear Delt Row	30
Cable One Arm Rear Delt Row	33
Cable One Arm Rear Delt Row	34
Cable One Arm Rear Delt Row	45
Cable Rear Lateral Raise	11
Cable Rear Lateral Raise	22
Cable Rear Lateral Raise	30
Cable Rear Lateral Raise	33
Cable Rear Lateral Raise	34
Cable Rear Lateral Raise	45
Cable One Arm Rear Lateral Raise	11
Cable One Arm Rear Lateral Raise	22
Cable One Arm Rear Lateral Raise	30
Cable One Arm Rear Lateral Raise	33
Cable One Arm Rear Lateral Raise	34
Cable One Arm Rear Lateral Raise	45
Cable Seated Rear Lateral Raise	11
Cable Seated Rear Lateral Raise	22
Cable Seated Rear Lateral Raise	30
Cable Seated Rear Lateral Raise	33
Cable Seated Rear Lateral Raise	34
Cable Seated Rear Lateral Raise	45
Cable Standing Cross Row	3
Cable Standing Cross Row	5
Cable Standing Cross Row	11
Cable Standing Cross Row	22
Cable Standing Cross Row	30
Cable Standing Cross Row	33
Cable Standing Cross Row	34
Cable Standing Cross Row	45
Cable One Arm Standing Cross Row	3
Cable One Arm Standing Cross Row	5
Cable One Arm Standing Cross Row	11
Cable One Arm Standing Cross Row	22
Cable One Arm Standing Cross Row	30
Cable One Arm Standing Cross Row	33
Cable One Arm Standing Cross Row	34
Cable One Arm Standing Cross Row	45
Dumbbell Lying One Arm Rear Lateral Raise	11
Dumbbell Lying One Arm Rear Lateral Raise	22
Dumbbell Lying One Arm Rear Lateral Raise	30
Dumbbell Lying One Arm Rear Lateral Raise	33
Dumbbell Lying One Arm Rear Lateral Raise	34
Dumbbell Lying One Arm Rear Lateral Raise	45
Dumbbell Lying One Arm Rear Lateral Raise	52
Dumbbell Rear Lateral Raise	11
Dumbbell Rear Lateral Raise	22
Dumbbell Rear Lateral Raise	30
Dumbbell Rear Lateral Raise	33
Dumbbell Rear Lateral Raise	34
Dumbbell Rear Lateral Raise	45
Dumbbell Rear Delt Row	3
Dumbbell Rear Delt Row	5
Dumbbell Rear Delt Row	11
Dumbbell Rear Delt Row	22
Dumbbell Rear Delt Row	30
Dumbbell Rear Delt Row	33
Dumbbell Rear Delt Row	34
Dumbbell Rear Delt Row	45
Dumbbell Seated Rear Lateral Raise	11
Dumbbell Seated Rear Lateral Raise	22
Dumbbell Seated Rear Lateral Raise	30
Dumbbell Seated Rear Lateral Raise	33
Dumbbell Seated Rear Lateral Raise	34
Dumbbell Seated Rear Lateral Raise	45
Dumbbell Side Lying Rear Delt Raise	11
Dumbbell Side Lying Rear Delt Raise	22
Dumbbell Side Lying Rear Delt Raise	30
Dumbbell Side Lying Rear Delt Raise	33
Dumbbell Side Lying Rear Delt Raise	34
Dumbbell Side Lying Rear Delt Raise	45
Lever Rear Lateral Raise	22
Lever Rear Lateral Raise	30
Lever Rear Lateral Raise	33
Lever Rear Lateral Raise	34
Lever Rear Lateral Raise	45
Lever Seated Rear Delt Row	3
Lever Seated Rear Delt Row	5
Lever Seated Rear Delt Row	22
Lever Seated Rear Delt Row	23
Lever Seated Rear Delt Row	30
Lever Seated Rear Delt Row	33
Lever Seated Rear Delt Row	34
Lever Seated Rear Delt Row	45
Lever Seated Reverse Fly (parallel grip)	11
Lever Seated Reverse Fly (parallel grip)	22
Lever Seated Reverse Fly (parallel grip)	30
Lever Seated Reverse Fly (parallel grip)	33
Lever Seated Reverse Fly (parallel grip)	34
Lever Seated Reverse Fly (parallel grip)	45
Lever Seated Reverse Fly (on pec deck)	22
Lever Seated Reverse Fly (on pec deck)	30
Lever Seated Reverse Fly (on pec deck)	33
Lever Seated Reverse Fly (on pec deck)	34
Lever Seated Reverse Fly (on pec deck)	45
Lever Seated Reverse Fly (overhand grip)	11
Lever Seated Reverse Fly (overhand grip)	22
Lever Seated Reverse Fly (overhand grip)	30
Lever Seated Reverse Fly (overhand grip)	33
Lever Seated Reverse Fly (overhand grip)	34
Lever Seated Reverse Fly (overhand grip)	45
Lever Seated Reverse Fly (pronated parallel grip)	11
Lever Seated Reverse Fly (pronated parallel grip)	22
Lever Seated Reverse Fly (pronated parallel grip)	30
Lever Seated Reverse Fly (pronated parallel grip)	33
Lever Seated Reverse Fly (pronated parallel grip)	34
Lever Seated Reverse Fly (pronated parallel grip)	45
Smith Rear Delt Row	3
Smith Rear Delt Row	5
Smith Rear Delt Row	11
Smith Rear Delt Row	22
Smith Rear Delt Row	30
Smith Rear Delt Row	33
Smith Rear Delt Row	34
Smith Rear Delt Row	45
Rear Delt Inverted Row	3
Rear Delt Inverted Row	5
Rear Delt Inverted Row	22
Rear Delt Inverted Row	30
Rear Delt Inverted Row	33
Rear Delt Inverted Row	34
Rear Delt Inverted Row	45
Suspended Rear Delt Row	3
Suspended Rear Delt Row	5
Suspended Rear Delt Row	22
Suspended Rear Delt Row	30
Suspended Rear Delt Row	33
Suspended Rear Delt Row	34
Suspended Rear Delt Row	45
Suspended Reverse Fly	22
Suspended Reverse Fly	30
Suspended Reverse Fly	33
Suspended Reverse Fly	34
Suspended Reverse Fly	45
Cable Front Lateral Raise	10
Cable Front Lateral Raise	11
Cable Front Lateral Raise	33
Cable Front Lateral Raise	34
Cable Front Lateral Raise	47
Cable Seated Front Lateral Raise	10
Cable Seated Front Lateral Raise	11
Cable Seated Front Lateral Raise	33
Cable Seated Front Lateral Raise	34
Cable Seated Front Lateral Raise	47
Dumbbell Front Lateral Raise	10
Dumbbell Front Lateral Raise	11
Dumbbell Front Lateral Raise	33
Dumbbell Front Lateral Raise	34
Dumbbell Front Lateral Raise	47
Dumbbell Seated Front Lateral Raise	10
Dumbbell Seated Front Lateral Raise	11
Dumbbell Seated Front Lateral Raise	33
Dumbbell Seated Front Lateral Raise	34
Dumbbell Seated Front Lateral Raise	47
Barbell Squat	1
Barbell Squat	16
Barbell Squat	48
Cable Belt Half Squat	16
Cable Belt Half Squat	48
Cable Standing Leg Extension	21
Cable Standing Leg Extension	46
Cable Standing Leg Extension	53
Cable Step Down	1
Cable Step Down	16
Cable Step Down	48
Sled Squat	1
Sled Squat	16
Sled Squat	48
Smith Step Down	1
Smith Step Down	16
Smith Step Down	48
Barbell Good-morning	1
Barbell Good-morning	16
Barbell Glute-Ham Raise	1
Barbell Glute-Ham Raise	15
Barbell Glute-Ham Raise	16
Barbell Glute-Ham Raise	19
Barbell Glute-Ham Raise	42
Barbell Glute-Ham Raise	46
Cable Bent-over Leg Curl	15
Cable Bent-over Leg Curl	19
Cable Bent-over Leg Curl	21
Cable Bent-over Leg Curl	42
Cable Bent-over Leg Curl	46
Cable Bent-over Leg Curl	53
Cable Lying Leg Curl	15
Cable Lying Leg Curl	19
Cable Lying Leg Curl	42
Cable Lying Leg Curl	46
Cable Standing Leg Curl	15
Cable Standing Leg Curl	19
Cable Standing Leg Curl	42
Cable Standing Leg Curl	46
Cable Standing Overhead Crunch	25
Barbell Straight Leg Deadlift (Romanian)	1
Barbell Straight Leg Deadlift (Romanian)	16
Barbell Straight Leg Deadlift (Romanian)	20
Cable Straight Leg Deadlift (Romanian)	1
Cable Straight Leg Deadlift (Romanian)	16
Cable Straight Leg Deadlift (Romanian)	20
Dumbbell Straight Leg Deadlift (Romanian)	1
Dumbbell Straight Leg Deadlift (Romanian)	16
Dumbbell Straight Leg Deadlift (Romanian)	20
Trap Bar Straight Leg Deadlift (Romanian)	1
Trap Bar Straight Leg Deadlift (Romanian)	16
Trap Bar Straight Leg Deadlift (Romanian)	20
Lever Bent-over Leg Curl	15
Lever Bent-over Leg Curl	19
Lever Bent-over Leg Curl	46
Lever Alternating Bent-over Leg Curl	15
Lever Alternating Bent-over Leg Curl	19
Lever Alternating Bent-over Leg Curl	46
Lever Kneeling Leg Curl	15
Lever Kneeling Leg Curl	19
Lever Kneeling Leg Curl	42
Lever Kneeling Leg Curl	46
Lever Lying Leg Curl	15
Lever Lying Leg Curl	19
Lever Lying Leg Curl	42
Lever Lying Leg Curl	46
Lever Alternating Lying Leg Curl	15
Lever Alternating Lying Leg Curl	19
Lever Alternating Lying Leg Curl	42
Lever Alternating Lying Leg Curl	46
Lever Single Leg Seated Leg Curl	15
Lever Single Leg Seated Leg Curl	19
Lever Single Leg Seated Leg Curl	42
Lever Single Leg Seated Leg Curl	46
Lever Straight-leg Lying Hip Extension	1
Lever Straight-leg Lying Hip Extension	16
Smith Good-morning	1
Smith Good-morning	16
Smith Straight Leg Deadlift (Romanian)	1
Smith Straight Leg Deadlift (Romanian)	16
Smith Straight Leg Deadlift (Romanian)	20
Glute-Ham Raise (hands behind neck)	1
Glute-Ham Raise (hands behind neck)	15
Glute-Ham Raise (hands behind neck)	16
Glute-Ham Raise (hands behind neck)	19
Glute-Ham Raise (hands behind neck)	42
Glute-Ham Raise (hands behind neck)	46
Glute-Ham Raise (hands behind hips)	1
Glute-Ham Raise (hands behind hips)	15
Glute-Ham Raise (hands behind hips)	16
Glute-Ham Raise (hands behind hips)	19
Glute-Ham Raise (hands behind hips)	42
Glute-Ham Raise (hands behind hips)	46
Hanging Hamstring Bridge	1
Hanging Hamstring Bridge	12
Hanging Hamstring Bridge	16
Hanging Hamstring Bridge	23
Hanging Hamstring Bridge	24
Hanging Hamstring Bridge	28
Hanging Hamstring Bridge	29
Hanging Hamstring Bridge	38
Hanging Hamstring Bridge	41
Hanging Hamstring Bridge	45
Single Leg Hanging Hamstring Bridge	1
Single Leg Hanging Hamstring Bridge	12
Single Leg Hanging Hamstring Bridge	16
Single Leg Hanging Hamstring Bridge	20
Single Leg Hanging Hamstring Bridge	23
Single Leg Hanging Hamstring Bridge	24
Single Leg Hanging Hamstring Bridge	28
Single Leg Hanging Hamstring Bridge	29
Single Leg Hanging Hamstring Bridge	38
Single Leg Hanging Hamstring Bridge	41
Single Leg Hanging Hamstring Bridge	45
Hanging Hamstring Bridge Curl	1
Hanging Hamstring Bridge Curl	12
Hanging Hamstring Bridge Curl	15
Hanging Hamstring Bridge Curl	16
Hanging Hamstring Bridge Curl	19
Hanging Hamstring Bridge Curl	23
Hanging Hamstring Bridge Curl	24
Hanging Hamstring Bridge Curl	28
Hanging Hamstring Bridge Curl	29
Hanging Hamstring Bridge Curl	38
Hanging Hamstring Bridge Curl	41
Hanging Hamstring Bridge Curl	42
Hanging Hamstring Bridge Curl	45
Hanging Hamstring Bridge Curl	46
Single Leg Hanging Hamstring Bridge Curl	1
Single Leg Hanging Hamstring Bridge Curl	12
Single Leg Hanging Hamstring Bridge Curl	15
Single Leg Hanging Hamstring Bridge Curl	16
Single Leg Hanging Hamstring Bridge Curl	19
Single Leg Hanging Hamstring Bridge Curl	23
Single Leg Hanging Hamstring Bridge Curl	24
Single Leg Hanging Hamstring Bridge Curl	28
Single Leg Hanging Hamstring Bridge Curl	29
Single Leg Hanging Hamstring Bridge Curl	38
Single Leg Hanging Hamstring Bridge Curl	41
Single Leg Hanging Hamstring Bridge Curl	42
Single Leg Hanging Hamstring Bridge Curl	45
Single Leg Hanging Hamstring Bridge Curl	46
Hanging Leg Curl	15
Hanging Leg Curl	19
Hanging Leg Curl	42
Hanging Leg Curl	46
Hanging Straight Hip Leg Curl	15
Hanging Straight Hip Leg Curl	19
Hanging Straight Hip Leg Curl	42
Hanging Straight Hip Leg Curl	46
Straight Hip Leg Curl (on stability ball)	15
Straight Hip Leg Curl (on stability ball)	19
Straight Hip Leg Curl (on stability ball)	42
Straight Hip Leg Curl (on stability ball)	46
Single Leg Straight Hip Leg Curl (on stability ball)	15
Single Leg Straight Hip Leg Curl (on stability ball)	19
Single Leg Straight Hip Leg Curl (on stability ball)	42
Single Leg Straight Hip Leg Curl (on stability ball)	46
Suspended Straight Hip Leg Curl	15
Suspended Straight Hip Leg Curl	19
Suspended Straight Hip Leg Curl	42
Suspended Straight Hip Leg Curl	46
Cable Hip Adduction	16
Cable Hip Adduction	19
Cable Hip Adduction	26
Cable Lying Hip Adduction	19
Cable Lying Hip Adduction	26
Lever Lying Hip Adduction	16
Lever Lying Hip Adduction	19
Lever Lying Hip Adduction	26
Lever Seated Hip Adduction	19
Lever Seated Hip Adduction	26
Barbell Push Sit-up	21
Barbell Push Sit-up	25
Barbell Push Sit-up	44
Barbell Push Sit-up	46
Barbell Push Sit-up	53
Cable Lying Crunch (on stability ball)	25
Cable Lying Leg-Hip Raise	1
Cable Lying Leg-Hip Raise	21
Cable Lying Leg-Hip Raise	25
Cable Lying Leg-Hip Raise	26
Cable Lying Leg-Hip Raise	46
Cable Lying Leg-Hip Raise	53
Cable Lying Straight Leg-Hip Raise	1
Cable Lying Straight Leg-Hip Raise	21
Cable Lying Straight Leg-Hip Raise	25
Cable Lying Straight Leg-Hip Raise	26
Cable Lying Straight Leg-Hip Raise	44
Cable Lying Straight Leg-Hip Raise	46
Cable Lying Straight Leg-Hip Raise	53
Cable Kneeling Crunch	25
Cable Overhead Seated Crunch	25
Cable Standing Crunch	25
Dumbbell Push Sit-up	21
Dumbbell Push Sit-up	25
Dumbbell Push Sit-up	44
Dumbbell Push Sit-up	46
Dumbbell Push Sit-up	53
Lever Lying Crunch	25
Lever Lying Leg-Hip Raise	1
Lever Lying Leg-Hip Raise	21
Lever Lying Leg-Hip Raise	25
Lever Lying Leg-Hip Raise	26
Lever Lying Leg-Hip Raise	44
Lever Lying Leg-Hip Raise	46
Lever Lying Leg-Hip Raise	53
Lever Push Crunch	25
Lever Seated Crunch	25
Lever Seated Leg Raise Crunch	25
Lever Side Lying Leg Hip Raise	1
Lever Side Lying Leg Hip Raise	25
Lever Side Lying Leg Hip Raise	26
Lever Side Lying Leg Hip Raise	46
Lever Side Lying Leg Hip Raise	53
Cable Standing Twisting Crunch	44
Cable Standing Twisting Crunch	56
Crunch	25
Crunch Up	25
Incline Crunch	25
Jack-knife Sit-up	1
Jack-knife Sit-up	21
Jack-knife Sit-up	25
Jack-knife Sit-up	26
Jack-knife Sit-up	46
Jack-knife Sit-up	53
Hanging Leg-Hip Raise	1
Hanging Leg-Hip Raise	21
Hanging Leg-Hip Raise	25
Hanging Leg-Hip Raise	26
Hanging Leg-Hip Raise	46
Hanging Leg-Hip Raise	53
Hanging Straight Leg-Hip Raise	1
Hanging Straight Leg-Hip Raise	6
Hanging Straight Leg-Hip Raise	21
Hanging Straight Leg-Hip Raise	25
Hanging Straight Leg-Hip Raise	26
Hanging Straight Leg-Hip Raise	44
Hanging Straight Leg-Hip Raise	46
Hanging Straight Leg-Hip Raise	53
Incline Leg-Hip Raise	1
Incline Leg-Hip Raise	21
Incline Leg-Hip Raise	25
Incline Leg-Hip Raise	26
Incline Leg-Hip Raise	46
Incline Leg-Hip Raise	53
Lying Leg-Hip Raise	1
Lying Leg-Hip Raise	21
Lying Leg-Hip Raise	25
Lying Leg-Hip Raise	26
Lying Leg-Hip Raise	46
Lying Leg-Hip Raise	53
Leg-Hip Raise (on stability ball)	1
Leg-Hip Raise (on stability ball)	21
Leg-Hip Raise (on stability ball)	25
Leg-Hip Raise (on stability ball)	26
Leg-Hip Raise (on stability ball)	46
Leg-Hip Raise (on stability ball)	53
Vertical Leg-Hip Raise	1
Vertical Leg-Hip Raise	21
Vertical Leg-Hip Raise	25
Vertical Leg-Hip Raise	26
Vertical Leg-Hip Raise	44
Vertical Leg-Hip Raise	46
Vertical Leg-Hip Raise	53
Vertical Straight Leg-Hip Raise (parallel bars)	1
Vertical Straight Leg-Hip Raise (parallel bars)	6
Vertical Straight Leg-Hip Raise (parallel bars)	21
Vertical Straight Leg-Hip Raise (parallel bars)	25
Vertical Straight Leg-Hip Raise (parallel bars)	26
Vertical Straight Leg-Hip Raise (parallel bars)	44
Vertical Straight Leg-Hip Raise (parallel bars)	46
Vertical Straight Leg-Hip Raise (parallel bars)	53
Incline Sit-up	21
Incline Sit-up	25
Incline Sit-up	44
Incline Sit-up	46
Incline Sit-up	53
Sit-up	21
Sit-up	25
Sit-up	44
Sit-up	46
Sit-up	53
V-up	1
V-up	21
V-up	25
V-up	26
V-up	44
V-up	46
V-up	53
Suspended Jack-knife	1
Suspended Jack-knife	21
Suspended Jack-knife	25
Suspended Jack-knife	26
Suspended Jack-knife	46
Suspended Jack-knife	53
Suspended Jack-knife Pike	1
Suspended Jack-knife Pike	21
Suspended Jack-knife Pike	25
Suspended Jack-knife Pike	26
Suspended Jack-knife Pike	46
Suspended Jack-knife Pike	53
Suspended Standing Rollout	12
Suspended Standing Rollout	23
Suspended Standing Rollout	28
Suspended Standing Rollout	29
Suspended Standing Rollout	41
Suspended Standing Rollout	45
Suspended Hanging Leg Hip Raise	1
Suspended Hanging Leg Hip Raise	21
Suspended Hanging Leg Hip Raise	25
Suspended Hanging Leg Hip Raise	26
Suspended Hanging Leg Hip Raise	46
Suspended Hanging Leg Hip Raise	53
Cable Kneeling Twisting Crunch	44
Cable Side Bend	43
Cable Side Bend	56
Cable Side Bend	57
Cable Side Bend	58
Cable Side Crunch	43
Cable Side Crunch	56
Cable Side Crunch	57
Cable Side Crunch	58
Cable Seated Twist	43
Cable Seated Twist	56
Cable Seated Twist	57
Cable Seated Twist	58
Cable Seated Cross Arm Twist	43
Cable Seated Cross Arm Twist	56
Cable Seated Cross Arm Twist	57
Cable Seated Cross Arm Twist	58
Dumbbell Russian Twist (on stability ball)	13
Dumbbell Russian Twist (on stability ball)	43
Dumbbell Russian Twist (on stability ball)	56
Dumbbell Russian Twist (on stability ball)	57
Dumbbell Russian Twist (on stability ball)	58
Dumbbell Side Bend	43
Dumbbell Side Bend	56
Dumbbell Side Bend	57
Dumbbell Side Bend	58
Lever Seated Side Bend	43
Lever Seated Side Bend	56
Lever Seated Side Bend	57
Lever Seated Side Bend	58
Lever Seated Twist	43
Lever Seated Twist	56
Lever Seated Twist	57
Lever Seated Twist	58
Lever Seated Side Crunch	44
Lever Standing Side Bend	43
Lever Standing Side Bend	56
Lever Standing Side Bend	57
Lever Standing Side Bend	58
Lying Twist	43
Lying Twist	56
Lying Twist	57
Lying Twist	58
Bent-knee Lying Twist	43
Bent-knee Lying Twist	56
Bent-knee Lying Twist	57
Bent-knee Lying Twist	58
Side Bend (on stability ball)	43
Side Bend (on stability ball)	56
Side Bend (on stability ball)	57
Side Bend (on stability ball)	58
Hanging Twisting Leg Raise	1
Hanging Twisting Leg Raise	21
Hanging Twisting Leg Raise	26
Hanging Twisting Leg Raise	46
Hanging Twisting Leg Raise	53
Vertical Twisting Leg Raise	1
Vertical Twisting Leg Raise	21
Vertical Twisting Leg Raise	26
Vertical Twisting Leg Raise	46
Vertical Twisting Leg Raise	53
Vertical Twisting Leg Raise (on dip bar)	1
Vertical Twisting Leg Raise (on dip bar)	21
Vertical Twisting Leg Raise (on dip bar)	26
Vertical Twisting Leg Raise (on dip bar)	46
Vertical Twisting Leg Raise (on dip bar)	53
Incline Twisting Sit-up	21
Incline Twisting Sit-up	44
Incline Twisting Sit-up	46
Incline Twisting Sit-up	53
Twisting Sit-up	21
Twisting Sit-up	44
Twisting Sit-up	46
Twisting Sit-up	53
Hyperextension	1
Hyperextension	16
Hyperextension	20
Incline Twisting Crunch	44
Incline Twisting Crunch	56
Side Crunch	44
Side Crunch (on stability ball)	44
Twisting Crunch	44
Twisting Crunch	56
Twisting Crunch (on stability ball)	44
Hanging Windshield Wiper	43
Hanging Windshield Wiper	56
Hanging Windshield Wiper	57
Hanging Windshield Wiper	58
Suspended Twisting Jack-knife	1
Suspended Twisting Jack-knife	21
Suspended Twisting Jack-knife	26
Suspended Twisting Jack-knife	43
Suspended Twisting Jack-knife	46
Suspended Twisting Jack-knife	53
Suspended Twisting Jack-knife	57
Suspended Twisting Jack-knife	58
Bird Dog	10
Bird Dog	11
Bird Dog	16
Bird Dog	33
Bird Dog	34
Alternating Bird Dog	10
Alternating Bird Dog	11
Alternating Bird Dog	16
Alternating Bird Dog	33
Alternating Bird Dog	34
Bird Dog (on stability ball)	10
Bird Dog (on stability ball)	11
Bird Dog (on stability ball)	16
Bird Dog (on stability ball)	20
Bird Dog (on stability ball)	33
Bird Dog (on stability ball)	34
\.


--
-- Data for Name: _target; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public._target ("A", "B") FROM stdin;
Weighted Bench Dip	38
Weighted Close Grip Push-up	38
Barbell Close Grip Bench Press	38
Barbell Close Grip Incline Bench Press	38
Barbell Lying Triceps Extension	38
Barbell Decline Triceps Extension	38
Barbell Incline Triceps Extension	38
Barbell Lying Triceps Extension "Skull Crusher"	38
Barbell Triceps Extension	38
Barbell Reclined Triceps Extension	38
Cable Bar Bent-over Triceps Extension	38
Cable Incline Triceps Extension	38
Cable Lying Triceps Extension	38
Cable Bar Lying Triceps Extension	38
Cable Decline Triceps Extension	38
Cable Pushdown	38
Cable Alternating Seated Pushdown	38
Cable Bar Pushdown	38
Cable Pushdown (forward leaning)	38
Cable Incline Pushdown	38
Cable One Arm Pushdown	38
Weighted Triceps Dip	38
Weighted Neutral Grip Chin-up	23
Weighted Parallel Close Grip Pull-up	23
Cable Side Triceps Extension	38
Cable Triceps Dip	38
Cable Triceps Extension	38
Cable One Arm Triceps Extension (pronated grip)	38
Cable One Arm Triceps Extension (supinated grip)	38
Weighted Inverted Row	23
Dumbbell Kickback	38
Dumbbell Lying Triceps Extension	38
Dumbbell Decline Triceps Extension	38
Dumbbell Incline Triceps Extension	38
Dumbbell One Arm Triceps Extension	38
Dumbbell One Arm Reclined Triceps Extension	38
Dumbbell Triceps Extension	38
Dumbbell Reclined Triceps Extension	38
Weighted Pull-up	23
Weighted Neutral Grip Pull-up	23
Weighted Chin-up	23
Lever Incline Triceps Extension	38
Lever Overhead Triceps Extension	38
Lever Pushdown	38
Lever Seated Close Grip Press	38
Lever Close Grip Incline Bench Press	38
Lever Triceps Dip	38
Lever Overhand Triceps Dip	38
Sled Standing Triceps Dip	38
Smith Close Grip Bench Press	38
Smith Close Grip Incline Bench Press	38
Weighted Rear Pull-up	23
Weighted Chest Dip	28
Weighted Push-up	28
Bench Dip	38
Close Grip Push-up	38
Close Grip Decline Pushup	38
Weighted Reverse Hyper-extension	16
Weighted Single Leg Squat	6
Weighted Lying Hip Abduction	2
Triceps Dip	38
Weighted Hanging Leg Raise	21
Weighted Hanging Straight Leg Raise	21
Suspended Triceps Dip	38
Weighted Incline Leg Raise	21
Suspended Triceps Extension	38
Barbell Curl	4
Barbell Drag Curl	4
Cable Alternating Curl	4
Cable Curl	4
Cable Bar Curl	4
Weighted Incline Straight Leg Raise	21
Cable Seated Curl	4
Cable One Arm Curl	4
Cable Supine Curl	4
Dumbbell Curl	4
Dumbbell Seated Curl	4
Dumbbell Incline Curl	4
Lever Curl	4
Lever Alternating Curl	4
Chin-up	23
Inverted Biceps Row	4
Barbell Preacher Curl	5
Barbell Standing Preacher Curl	5
Barbell Prone Incline Curl	5
Cable Concentration Curl	5
Cable Preacher Curl	5
Cable Alternating Preacher Curl	5
Cable Standing Preacher Curl	5
Cable One Arm Standing Preacher Curl	5
Cable One Arm Preacher Curl	5
Cable Prone Incline Curl	5
Dumbbell Concentration Curl	5
Dumbbell Preacher Curl	5
Dumbbell Standing Preacher Curl	5
Weighted Lying Leg Raise	21
Dumbbell Prone Incline Curl	5
Weighted Seated Leg Raise	21
Weighted Vertical Leg Raise	21
Weighted Vertical Straight Leg Raise	21
Lever Preacher Curl	5
Lever Alternating Preacher Curl (arms high)	5
Lever Standing Preacher Curl	5
Suspended Arm Curl	5
Barbell Bent-over Row	23
Barbell Close Grip Bent-over Row	23
Barbell Underhand Bent-over Row	23
Cable Incline Row	23
Cable Straight Back Incline Row	23
Cable Kneeling Row	23
Cable Lying Row	23
Cable One Arm Bent-over Row	23
Cable One Arm Seated Row	23
Cable Twisting Seated Row	23
Cable One Arm Seated High Row	23
Cable One Arm Straight Back Seated High Row	23
Cable Twisting Seated High Row	23
Cable Seated High Row	23
Cable Alternating Seated High Row	23
Cable Seated Row	23
Cable Straight Back Seated Row	23
Cable Wide Grip Seated Row	23
Cable Wide Grip Straight Back Seated Row	23
Cable Standing Row	23
Cable Standing Low Row	23
Cable Twisting Standing High Row	23
Dumbbell Incline Row	23
Weighted Glute-Ham Raise	20
Weighted Crunch	44
Weighted Crunch (on stability ball)	44
Weighted Overhead Crunch (on stability ball)	44
Weighted Incline Crunch	44
Weighted Incline Sit-up	44
Weighted Sit-up	44
Weighted Hanging Leg-Hip Raise	44
Lever Seated High Row	23
Lever Alternating Seated High Row	23
Lever Seated Row	23
Lever Wide Grip Seated Row	23
Lever Underhand Seated Row	23
Lever Alternating Underhand Seated Row	23
Smith Bent-over Row	23
Weighted Incline Leg-Hip Raise	44
Inverted Row	23
Weighted Lying Leg-Hip Raise	44
Weighted Vertical Leg-Hip Raise	44
Suspended Inverted Row	23
Weighted V-up	44
Suspended Row	23
Weighted Side Crunch	25
Weighted Side Crunch (on stability ball)	25
Weighted Twisting Crunch	25
Weighted Twisting Crunch (on stability ball)	25
Weighted Incline Twisting Sit-up	25
Barbell Pullover	23
Cable Close Grip Pulldown	23
Cable Alternating Close Grip Pulldown	23
Cable One Arm Pulldown	23
Cable One Arm Kneeling Pulldown	23
Weighted Twisting Sit-up	25
Cable Kneeling Bent-over Pulldown	23
Cable Pulldown	23
Cable Alternating Pulldown	23
Cable Parallel Grip Pulldown	23
Weighted Lying Twist	25
Cable Pullover	23
Cable Bent-over Pullover	23
Cable Chin-up	23
Cable Parallel Close Grip Pull-up	23
Cable Pull-up	23
Cable Rear Pull-up	23
Cable Rear Pulldown	23
Cable Alternating Standing Pulldown	23
Cable Twisting Standing Overhead Pull	23
Cable Underhand Pulldown	23
Weighted Bent-knee Lying Twist	25
Weighted Russian Twist (on stability ball)	25
Weighted Side Bend (on stability ball)	25
Weighted Back Extension (on stability ball)	14
Weighted Hyperextension	14
Lever Close Grip Pulldown	23
Lever Front Pulldown	23
Lever Iron Cross	23
Lever Pulldown (parallel grip)	23
Lever Pullover	23
Lever Underhand Pulldown	23
Lever Alternating Underhand Pulldown	23
Neutral Grip Chin-up	23
Parallel Close Grip Pull-up	23
Pull-up	23
Neutral Grip Pull-up	23
Rear Pull-up	23
Suspended Pull-up	23
Barbell Shrug	35
Trap Bar Shrug	35
Cable Shrug	35
Cable Bar Shrug	35
Cable One Arm Shrug	35
Dumbbell Shrug	35
Lever Bent-over Fly	28
Lever Seated Gripless Shrug	35
Lever Shrug	35
Sled Gripless Shrug	35
Smith Shrug	35
Cable Seated Shoulder External Rotation	22
Cable Standing Shoulder External Rotation	22
Cable Upright Shoulder External Rotation	30
Dumbbell Lying Shoulder External Rotation	22
Dumbbell Incline Shoulder External Rotation	22
Dumbbell Prone External Rotation	22
Dumbbell Prone Incline External Rotation	22
Dumbbell Seated Shoulder External Rotation	30
Dumbbell Upright Shoulder External Rotation	30
Lever Shoulder External Rotation	22
Lever Upright Shoulder External Rotation	30
Suspended Shoulder External Rotation	22
Cable Seated Shoulder Internal Rotation	51
Cable Standing Shoulder Internal Rotation	51
Lever Shoulder Internal Rotation	51
Lever Upright Shoulder Internal Rotation	51
Barbell Bench Press	28
Barbell Decline Bench Press	28
Cable Chest Dip	28
Cable Decline Fly	28
Cable Lying Fly	28
Cable Seated Fly	28
Cable Standing Fly	28
Cable Bench Press	28
Cable Bar Bench Press	28
Cable Chest Press	28
Cable One Arm Chest Press	28
Cable Standing Chest Press	28
Cable Bar Standing Chest Press	28
Cable Twisting Chest Press	28
Cable Decline Chest Press	28
Cable Bar Standing Decline Chest Press	28
Cable Standing Decline Chest Press	28
Cable Twisting Standing Chest Press	28
Dumbbell Bench Press	28
Dumbbell Decline Bench Press	28
Dumbbell Decline Fly	28
Dumbbell Fly	28
Dumbbell Pullover	28
Lever Chest Dip	28
Lever Lying Fly	28
Lever Pec Deck Fly	28
Lever Decline Pec Deck Fly	28
Lever Seated Fly	28
Lever Seated Iron Cross Fly	28
Lever Bench Press	28
Lever Chest Press	28
Lever Alternating Chest Press	28
Lever Parallel Grip Chest Press	28
Lever Decline Chest Press	28
Lever Alternating Decline Chest Press	28
Lever Decline Bench Press	28
Sled Standing Chest Dip	28
Sled Horizontal Grip Standing Chest Dip	28
Smith Bench Press	28
Smith Decline Bench Press	28
Chest Dip	28
Push-up	28
Incline Push-up	28
Push-up (on knees)	28
Suspended Chest Dip	28
Suspended Chest Press	28
Suspended Fly	28
Barbell Incline Bench Press	27
Cable Incline Bench Press	27
Cable Bar Incline Bench Press	27
Cable Incline Chest Press	27
Cable Standing Incline Chest Press	27
Cable Bar Standing Incline Chest Press	27
Cable One Arm Standing Incline Chest Press	27
Cable Incline Fly	27
Cable Standing Incline Fly	27
Dumbbell Incline Bench Press	27
Dumbbell Incline Fly	27
Lever Incline Bench Press	27
Lever Parallel Grip Incline Bench Press	27
Lever Incline Chest Press	27
Lever Alternating Incline Chest Press	27
Lever Parallel Grip Incline Chest Press	27
Lever Incline Fly	27
Smith Incline Bench Press	27
Decline Push-up	27
Pike Push-up	27
Cable Incline Shoulder Raise	47
Cable One Arm Incline Push	47
Dumbbell Incline Shoulder Raise	47
Lever Incline Shoulder Raise	47
Smith Incline Shoulder Raise	47
Push-up Plus	47
Barbell Reverse Curl	3
Barbell Reverse Preacher Curl	3
Barbell Standing Reverse Preacher Curl	3
Cable Hammer Curl	3
Cable Reverse Curl	3
Cable Bar Reverse Curl	3
Cable Reverse Preacher Curl	3
Cable Standing Reverse Preacher Curl	3
Dumbbell Hammer Curl	3
Lever Hammer Preacher Curl	3
Lever Reverse Curl	4
Lever Reverse Preacher Curl	3
Barbell Wrist Curl	40
Cable Wrist Curl	40
Cable One Arm Wrist Curl	40
Dumbbell Wrist Curl	40
Lever Wrist Curl	40
Barbell Reverse Wrist Curl	39
Cable Reverse Wrist Curl	39
Cable One Arm Reverse Wrist Curl	39
Dumbbell Radial Deviation	3
Dumbbell Reverse Wrist Curl	39
Lever Reverse Wrist Curl	39
Dumbbell Seated Pronation	36
Lever Seated Forearm Pronation	36
Lever Standing Forearm Pronation	36
Dumbbell Lying Supination	37
Dumbbell Seated Supination	37
Lever Seated Forearm Supination	37
Lever Standing Forearm Supination	37
Barbell Seated Good-morning	16
Barbell Deadlift	14
Barbell Sumo Deadlift	14
Barbell Hip Thrust	16
Barbell Lunge	6
Barbell Alternating Lunge To Rear Lunge	6
Barbell Rear Lunge	6
Barbell Side Lunge	6
Barbell Walking Lunge	6
Barbell Single Leg Split Squat	6
Barbell Side Split Squat	6
Barbell Single Leg Squat	6
Barbell Split Squat	6
Barbell Front Squat	6
Barbell Full Squat	6
Trap Bar Squat	6
Trap Bar Deadlift	14
Cable Glute Kickback	16
Cable Rear Lunge	6
Cable Rear Step-down Lunge	6
Cable Single Leg Split Squat	6
Cable One Arm Single Leg Split Squat	6
Cable Split Squat	6
Cable One Arm Split Squat	6
Cable Squat	6
Cable Bar Squat	6
Cable Belt Squat	6
Cable Standing Hip Extension	16
Cable Bent-over Hip Extension	16
Cable Step-up	6
Dumbbell Lunge	6
Dumbbell Alternating Side Lunge	6
Dumbbell Rear Lunge	6
Dumbbell Side Lunge	6
Dumbbell Walking Lunge	6
Dumbbell Single Leg Split Squat	6
Dumbbell Single Leg Squat	6
Dumbbell Split Squat	6
Dumbbell Squat	6
Dumbbell Front Squat	6
Dumbbell Step-up	6
Dumbbell Lateral Step-up	6
Dumbbell Step Down	6
Lever Hip Thrust	16
Lever Single Leg 45° Leg Press	6
Lever Front Squat	16
Lever Kneeling Hip Extension	16
Lever Alternating Kneeling Hip Extension	16
Lever Lying Hip Extension	16
Lever Alternating Lying Hip Extension	16
Lever Standing Hip Extension	16
Lever Alternating Lying Leg Press	6
Lever Seated Leg Press	6
Lever Single Leg Seated Leg Press	6
Lever Bent-over Glute Kickback	16
Lever Kneeling Glute Kickback	16
Lever Standing Glute Kickback	16
Lever Squat	6
Lever V-Squat	6
Lever Split V-Squat	6
Lever Single Leg Split V-Squat	6
Lever Alternating Single Leg Split V-Squat	6
Sled 45° Leg Press	6
Sled Alternating 45° Leg Press	6
Sled Single Leg 45° Leg Press	6
Sled Hack Press	6
Sled Lying Leg Press	6
Sled Single Leg Lying Leg Press	6
Sled Seated Leg Press	6
Sled Vertical Leg Press	6
Sled Single Leg Vertical Leg Press	6
Sled Kneeling Glute Kickback	16
Sled Standing Glute Kickback	16
Sled Rear Lunge	6
Sled Hack Squat	6
Sled Single Leg Hack Squat	6
Smith Bent Knee Good-morning	14
Smith Deadlift	14
Smith Rear Lunge	6
Smith Single Leg Split Squat	6
Smith Split Squat	6
Smith Squat	6
Smith Single Leg Squat	6
Smith Front Squat	6
Smith Hack Squat	6
Smith Wide Squat	6
Lunge	6
Rear Lunge	6
Reverse Hyper-extension	16
Reverse Hyper-extension (on stability ball)	16
Single Leg Hip Bridge	16
Single Leg Squat (pistol)	6
Single Leg Half Squat	6
Split Squat	6
Single Leg Split Squat	6
Squat	6
Half Squat	6
Step-up	6
Lateral Step-up	6
Step-down	6
Alternating Step-down	16
Suspended Hip Bridge	16
Suspended Reclining Squat	6
Suspended Single Leg Squat	6
Suspended Single Leg Split Squat	6
Cable Hip Abduction	2
Cable Lying Hip Internal Rotation	13
Cable Seated Hip Internal Rotation	13
Dumbbell Lying Hip Abduction	2
Lever Lying Hip Abduction	2
Lever Seated Hip Abduction	2
Lever Standing Hip Abduction	2
Side Bridge Hip Abduction	17
Side Bridge Hip Abduction	18
Side Bridge Hip Abduction	53
Angled Side Bridge Hip Abduction	17
Angled Side Bridge Hip Abduction	18
Angled Side Bridge Hip Abduction	53
Bent Knee Side Bridge Hip Abduction	17
Bent Knee Side Bridge Hip Abduction	18
Bent Knee Side Bridge Hip Abduction	53
Suspended Hip Abduction	2
Angled Side Bridge	25
Bent Knee Side Bridge	25
Side Bridge	25
Suspended Side Bend	25
Suspended Side Bridge	25
Cable Lying Leg Raise	21
Cable Lying Straight Leg Raise	21
Cable Standing Leg Raise	21
Cable Standing Straight Leg Raise	21
Lever Hip Flexion	21
Lever Lying Leg Raise	21
Lever Vertical Leg Raise	21
Hanging Leg Raise	21
Hanging Straight Leg Raise	21
Incline Leg Raise	21
Incline Straight Leg Raise	21
Lying Straight Leg Raise	21
Lying Simultaneous Alternating Straight Leg Raise	21
Seated Leg Raise	21
Vertical Leg Raise	21
Vertical Straight Leg Raise	21
Jack-knife on Ball	21
Lying Scissor Kick	21
Jack-knife on Power Wheel	21
Pike on Power Wheel	21
Pike on Discs	21
Suspended Mountain Climber	21
Suspended Pike	21
Cable Lying Hip External Rotation	13
Cable Seated Hip External Rotation	13
Barbell Front Raise	10
Barbell Incline Front Raise	10
Barbell Military Press	10
Barbell Seated Military Press	10
Barbell Shoulder Press	10
Barbell Reclined Shoulder Press	10
Cable Bar Behind Neck Press	10
Cable Bar Front Raise	10
Cable Bar Military Press	10
Cable Bar Shoulder Press	10
Cable Seated Front Raise	10
Cable Alternating Front Raise	10
Cable Alternating Seated Front Raise	10
Cable One Arm Front Raise	10
Cable Standing Shoulder Press	10
Cable Shoulder Press	10
Cable Twisting Overhead Press	10
Dumbbell Arnold Press	10
Dumbbell Front Raise	10
Dumbbell Alternating Front Raise	10
Dumbbell Alternating Incline Front Raise	10
Dumbbell Alternating Seated Front Raise	10
Dumbbell Seated Front Raise	10
Dumbbell Shoulder Press	10
Dumbbell One Arm Shoulder Press	10
Dumbbell Reclined Shoulder Press	10
Lever One Arm Front Raise	10
Lever Reclined Shoulder Press	10
Lever Reclined Parallel Grip Shoulder Press	10
Lever Shoulder Press	10
Lever Alternating Shoulder Press	10
Sled Shoulder Press	10
Smith Behind Neck Press	10
Smith Shoulder Press	10
Pike Press	10
Elevated Pike Press	10
Suspended Front Raise	10
Barbell Upright Row	11
Barbell Wide Grip Upright Row	11
Cable Lateral Raise	11
Cable One Arm Lateral Raise	11
Barbell Straight Leg Deadlift (Romanian)	14
Cable Seated Lateral Raise	11
Cable Upright Row	11
Cable Bar Upright Row	11
Cable Straight Leg Deadlift (Romanian)	14
Cable One Arm Upright Row	11
Dumbbell Straight Leg Deadlift (Romanian)	14
Smith Straight Leg Deadlift (Romanian)	14
Cable Wide Grip Upright Row	11
Cable Y Raise	11
Cable Seated Y Raise	11
Trap Bar Straight Leg Deadlift (Romanian)	14
Dumbbell Incline Lateral Raise	11
Dumbbell Incline Y Raise	11
Dumbbell Lateral Raise	11
Dumbbell One Arm Lateral Raise	11
Dumbbell One Arm Seated Lateral Raise	11
Dumbbell Seated Lateral Raise	11
Dumbbell Lying Lateral Raise	11
Dumbbell Raise	11
Dumbbell Upright Row	11
Dumbbell One Arm Upright Row	11
Dumbbell Seated Upright Row	11
Lever Rear Lateral Raise	12
Lever Lateral Raise	11
Lever Extended Arm Lateral Raise	11
Smith Upright Row	11
Smith Wide Grip Upright Row	11
Suspended Y Lateral Raise	11
Barbell Rear Delt Row	12
Barbell Lying Rear Delt Row	12
Cable Reverse Fly	12
Cable Seated Reverse Fly	12
Cable One Arm Reverse Fly	12
Cable Supine Reverse Fly	12
Cable Rear Delt Row	12
Cable One Arm Rear Delt Row	12
Cable Rear Lateral Raise	12
Cable One Arm Rear Lateral Raise	12
Cable Seated Rear Lateral Raise	12
Cable Standing Cross Row	12
Cable One Arm Standing Cross Row	12
Dumbbell Lying One Arm Rear Lateral Raise	12
Dumbbell Rear Lateral Raise	12
Dumbbell Rear Delt Row	12
Dumbbell Seated Rear Lateral Raise	12
Dumbbell Side Lying Rear Delt Raise	12
Lever Seated Rear Delt Row	12
Lever Seated Reverse Fly (parallel grip)	12
Lever Seated Reverse Fly (on pec deck)	12
Lever Seated Reverse Fly (overhand grip)	12
Lever Seated Reverse Fly (pronated parallel grip)	12
Smith Rear Delt Row	12
Rear Delt Inverted Row	12
Suspended Rear Delt Row	12
Suspended Reverse Fly	12
Cable Front Lateral Raise	52
Cable Seated Front Lateral Raise	52
Dumbbell Front Lateral Raise	52
Dumbbell Seated Front Lateral Raise	52
Barbell Squat	6
Cable Belt Half Squat	6
Cable Standing Leg Extension	6
Cable Step Down	6
Sled Squat	6
Smith Step Down	6
Barbell Good-morning	20
Barbell Glute-Ham Raise	20
Cable Bent-over Leg Curl	20
Cable Lying Leg Curl	20
Cable Standing Leg Curl	20
Lever Bent-over Leg Curl	20
Lever Alternating Bent-over Leg Curl	20
Lever Kneeling Leg Curl	20
Lever Lying Leg Curl	20
Lever Alternating Lying Leg Curl	20
Lever Single Leg Seated Leg Curl	20
Lever Straight-leg Lying Hip Extension	20
Smith Good-morning	20
Glute-Ham Raise (hands behind neck)	20
Glute-Ham Raise (hands behind hips)	20
Hanging Hamstring Bridge	20
Single Leg Hanging Hamstring Bridge	14
Hanging Hamstring Bridge Curl	20
Single Leg Hanging Hamstring Bridge Curl	20
Hanging Leg Curl	20
Hanging Straight Hip Leg Curl	20
Straight Hip Leg Curl (on stability ball)	20
Single Leg Straight Hip Leg Curl (on stability ball)	20
Suspended Straight Hip Leg Curl	20
Cable Hip Adduction	1
Cable Lying Hip Adduction	1
Lever Lying Hip Adduction	1
Lever Seated Hip Adduction	1
Barbell Push Sit-up	44
Cable Lying Crunch (on stability ball)	44
Cable Lying Leg-Hip Raise	44
Cable Lying Straight Leg-Hip Raise	44
Cable Kneeling Crunch	44
Cable Overhead Seated Crunch	44
Cable Standing Crunch	44
Cable Standing Overhead Crunch	44
Dumbbell Push Sit-up	44
Lever Lying Crunch	44
Lever Lying Leg-Hip Raise	44
Lever Push Crunch	44
Lever Seated Crunch	44
Lever Seated Leg Raise Crunch	44
Lever Side Lying Leg Hip Raise	44
Cable Standing Twisting Crunch	25
Crunch	44
Crunch Up	44
Incline Crunch	44
Jack-knife Sit-up	44
Hanging Leg-Hip Raise	44
Hanging Straight Leg-Hip Raise	44
Incline Leg-Hip Raise	44
Lying Leg-Hip Raise	44
Leg-Hip Raise (on stability ball)	44
Vertical Leg-Hip Raise	44
Vertical Straight Leg-Hip Raise (parallel bars)	44
Incline Sit-up	44
Sit-up	44
V-up	44
Suspended Jack-knife	44
Suspended Jack-knife Pike	44
Suspended Hanging Leg Hip Raise	44
Cable Kneeling Twisting Crunch	25
Cable Side Bend	25
Cable Side Crunch	25
Cable Seated Twist	25
Cable Seated Cross Arm Twist	25
Dumbbell Russian Twist (on stability ball)	25
Dumbbell Side Bend	25
Lever Seated Side Bend	25
Lever Seated Twist	25
Lever Seated Side Crunch	25
Lever Standing Side Bend	25
Hyperextension	14
Lying Twist	25
Bent-knee Lying Twist	25
Side Bend (on stability ball)	25
Hanging Twisting Leg Raise	25
Vertical Twisting Leg Raise	25
Vertical Twisting Leg Raise (on dip bar)	25
Incline Twisting Sit-up	25
Twisting Sit-up	25
Incline Twisting Crunch	25
Side Crunch	25
Side Crunch (on stability ball)	25
Twisting Crunch	25
Twisting Crunch (on stability ball)	25
Hanging Windshield Wiper	25
Suspended Twisting Jack-knife	25
Lever Back Extension	14
Back Extension (on stability ball, arms crossed)	14
Bird Dog	14
Alternating Bird Dog	14
Bird Dog (on stability ball)	14
Rear Bridge	14
Decline Rear Bridge	14
Single Leg Decline Rear Bridge	14
Incline Rear Bridge	14
\.


--
-- Name: BroadCast_broad_cast_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."BroadCast_broad_cast_id_seq"', 1, false);


--
-- Name: ExcerciseSetGroup_excercise_set_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."ExcerciseSetGroup_excercise_set_group_id_seq"', 4155, true);


--
-- Name: ExcerciseSet_excercise_set_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."ExcerciseSet_excercise_set_id_seq"', 18626, true);


--
-- Name: Measurement_measurement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Measurement_measurement_id_seq"', 1, false);


--
-- Name: MuscleRegion_muscle_region_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."MuscleRegion_muscle_region_id_seq"', 58, true);


--
-- Name: Notification_notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Notification_notification_id_seq"', 1, false);


--
-- Name: User_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."User_user_id_seq"', 110, true);


--
-- Name: Workout_workout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."Workout_workout_id_seq"', 706, true);


--
-- Name: BroadCast BroadCast_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."BroadCast"
    ADD CONSTRAINT "BroadCast_pkey" PRIMARY KEY (broad_cast_id);


--
-- Name: ExcerciseMetadata ExcerciseMetadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ExcerciseMetadata"
    ADD CONSTRAINT "ExcerciseMetadata_pkey" PRIMARY KEY (user_id, excercise_name);


--
-- Name: ExcerciseSetGroup ExcerciseSetGroup_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ExcerciseSetGroup"
    ADD CONSTRAINT "ExcerciseSetGroup_pkey" PRIMARY KEY (excercise_set_group_id);


--
-- Name: ExcerciseSet ExcerciseSet_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ExcerciseSet"
    ADD CONSTRAINT "ExcerciseSet_pkey" PRIMARY KEY (excercise_set_id);


--
-- Name: Excercise Excercise_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Excercise"
    ADD CONSTRAINT "Excercise_pkey" PRIMARY KEY (excercise_name);


--
-- Name: Measurement Measurement_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Measurement"
    ADD CONSTRAINT "Measurement_pkey" PRIMARY KEY (measurement_id);


--
-- Name: MuscleRegion MuscleRegion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."MuscleRegion"
    ADD CONSTRAINT "MuscleRegion_pkey" PRIMARY KEY (muscle_region_id);


--
-- Name: Notification Notification_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Notification"
    ADD CONSTRAINT "Notification_pkey" PRIMARY KEY (notification_id);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (user_id);


--
-- Name: Workout Workout_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Workout"
    ADD CONSTRAINT "Workout_pkey" PRIMARY KEY (workout_id);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: MuscleRegion_muscle_region_name_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "MuscleRegion_muscle_region_name_key" ON public."MuscleRegion" USING btree (muscle_region_name);


--
-- Name: User_email_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "User_email_key" ON public."User" USING btree (email);


--
-- Name: User_firebase_uid_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "User_firebase_uid_key" ON public."User" USING btree (firebase_uid);


--
-- Name: _BroadCastToUser_AB_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "_BroadCastToUser_AB_unique" ON public."_BroadCastToUser" USING btree ("A", "B");


--
-- Name: _BroadCastToUser_B_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "_BroadCastToUser_B_index" ON public."_BroadCastToUser" USING btree ("B");


--
-- Name: _dynamic_AB_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "_dynamic_AB_unique" ON public._dynamic USING btree ("A", "B");


--
-- Name: _dynamic_B_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "_dynamic_B_index" ON public._dynamic USING btree ("B");


--
-- Name: _stabilizer_AB_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "_stabilizer_AB_unique" ON public._stabilizer USING btree ("A", "B");


--
-- Name: _stabilizer_B_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "_stabilizer_B_index" ON public._stabilizer USING btree ("B");


--
-- Name: _synergist_AB_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "_synergist_AB_unique" ON public._synergist USING btree ("A", "B");


--
-- Name: _synergist_B_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "_synergist_B_index" ON public._synergist USING btree ("B");


--
-- Name: _target_AB_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "_target_AB_unique" ON public._target USING btree ("A", "B");


--
-- Name: _target_B_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "_target_B_index" ON public._target USING btree ("B");


--
-- Name: ExcerciseMetadata ExcerciseMetadata_excercise_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ExcerciseMetadata"
    ADD CONSTRAINT "ExcerciseMetadata_excercise_name_fkey" FOREIGN KEY (excercise_name) REFERENCES public."Excercise"(excercise_name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ExcerciseMetadata ExcerciseMetadata_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ExcerciseMetadata"
    ADD CONSTRAINT "ExcerciseMetadata_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public."User"(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ExcerciseSetGroup ExcerciseSetGroup_excercise_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ExcerciseSetGroup"
    ADD CONSTRAINT "ExcerciseSetGroup_excercise_name_fkey" FOREIGN KEY (excercise_name) REFERENCES public."Excercise"(excercise_name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ExcerciseSetGroup ExcerciseSetGroup_workout_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ExcerciseSetGroup"
    ADD CONSTRAINT "ExcerciseSetGroup_workout_id_fkey" FOREIGN KEY (workout_id) REFERENCES public."Workout"(workout_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ExcerciseSet ExcerciseSet_excercise_set_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ExcerciseSet"
    ADD CONSTRAINT "ExcerciseSet_excercise_set_group_id_fkey" FOREIGN KEY (excercise_set_group_id) REFERENCES public."ExcerciseSetGroup"(excercise_set_group_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Measurement Measurement_muscle_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Measurement"
    ADD CONSTRAINT "Measurement_muscle_region_id_fkey" FOREIGN KEY (muscle_region_id) REFERENCES public."MuscleRegion"(muscle_region_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Measurement Measurement_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Measurement"
    ADD CONSTRAINT "Measurement_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public."User"(user_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Notification Notification_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Notification"
    ADD CONSTRAINT "Notification_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public."User"(user_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Workout Workout_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Workout"
    ADD CONSTRAINT "Workout_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public."User"(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _BroadCastToUser _BroadCastToUser_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."_BroadCastToUser"
    ADD CONSTRAINT "_BroadCastToUser_A_fkey" FOREIGN KEY ("A") REFERENCES public."BroadCast"(broad_cast_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _BroadCastToUser _BroadCastToUser_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."_BroadCastToUser"
    ADD CONSTRAINT "_BroadCastToUser_B_fkey" FOREIGN KEY ("B") REFERENCES public."User"(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _dynamic _dynamic_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public._dynamic
    ADD CONSTRAINT "_dynamic_A_fkey" FOREIGN KEY ("A") REFERENCES public."Excercise"(excercise_name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _dynamic _dynamic_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public._dynamic
    ADD CONSTRAINT "_dynamic_B_fkey" FOREIGN KEY ("B") REFERENCES public."MuscleRegion"(muscle_region_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _stabilizer _stabilizer_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public._stabilizer
    ADD CONSTRAINT "_stabilizer_A_fkey" FOREIGN KEY ("A") REFERENCES public."Excercise"(excercise_name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _stabilizer _stabilizer_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public._stabilizer
    ADD CONSTRAINT "_stabilizer_B_fkey" FOREIGN KEY ("B") REFERENCES public."MuscleRegion"(muscle_region_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _synergist _synergist_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public._synergist
    ADD CONSTRAINT "_synergist_A_fkey" FOREIGN KEY ("A") REFERENCES public."Excercise"(excercise_name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _synergist _synergist_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public._synergist
    ADD CONSTRAINT "_synergist_B_fkey" FOREIGN KEY ("B") REFERENCES public."MuscleRegion"(muscle_region_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _target _target_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public._target
    ADD CONSTRAINT "_target_A_fkey" FOREIGN KEY ("A") REFERENCES public."Excercise"(excercise_name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _target _target_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public._target
    ADD CONSTRAINT "_target_B_fkey" FOREIGN KEY ("B") REFERENCES public."MuscleRegion"(muscle_region_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM cloudsqladmin;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO cloudsqlsuperuser;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: FUNCTION pg_replication_origin_advance(text, pg_lsn); Type: ACL; Schema: pg_catalog; Owner: -
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_advance(text, pg_lsn) TO cloudsqlsuperuser;


--
-- Name: FUNCTION pg_replication_origin_create(text); Type: ACL; Schema: pg_catalog; Owner: -
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_create(text) TO cloudsqlsuperuser;


--
-- Name: FUNCTION pg_replication_origin_drop(text); Type: ACL; Schema: pg_catalog; Owner: -
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_drop(text) TO cloudsqlsuperuser;


--
-- Name: FUNCTION pg_replication_origin_oid(text); Type: ACL; Schema: pg_catalog; Owner: -
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_oid(text) TO cloudsqlsuperuser;


--
-- Name: FUNCTION pg_replication_origin_progress(text, boolean); Type: ACL; Schema: pg_catalog; Owner: -
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_progress(text, boolean) TO cloudsqlsuperuser;


--
-- Name: FUNCTION pg_replication_origin_session_is_setup(); Type: ACL; Schema: pg_catalog; Owner: -
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_session_is_setup() TO cloudsqlsuperuser;


--
-- Name: FUNCTION pg_replication_origin_session_progress(boolean); Type: ACL; Schema: pg_catalog; Owner: -
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_session_progress(boolean) TO cloudsqlsuperuser;


--
-- Name: FUNCTION pg_replication_origin_session_reset(); Type: ACL; Schema: pg_catalog; Owner: -
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_session_reset() TO cloudsqlsuperuser;


--
-- Name: FUNCTION pg_replication_origin_session_setup(text); Type: ACL; Schema: pg_catalog; Owner: -
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_session_setup(text) TO cloudsqlsuperuser;


--
-- Name: FUNCTION pg_replication_origin_xact_reset(); Type: ACL; Schema: pg_catalog; Owner: -
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_xact_reset() TO cloudsqlsuperuser;


--
-- Name: FUNCTION pg_replication_origin_xact_setup(pg_lsn, timestamp with time zone); Type: ACL; Schema: pg_catalog; Owner: -
--

GRANT ALL ON FUNCTION pg_catalog.pg_replication_origin_xact_setup(pg_lsn, timestamp with time zone) TO cloudsqlsuperuser;


--
-- Name: FUNCTION pg_show_replication_origin_status(OUT local_id oid, OUT external_id text, OUT remote_lsn pg_lsn, OUT local_lsn pg_lsn); Type: ACL; Schema: pg_catalog; Owner: -
--

GRANT ALL ON FUNCTION pg_catalog.pg_show_replication_origin_status(OUT local_id oid, OUT external_id text, OUT remote_lsn pg_lsn, OUT local_lsn pg_lsn) TO cloudsqlsuperuser;


--
-- PostgreSQL database dump complete
--

