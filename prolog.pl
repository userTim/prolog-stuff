course(ch1010,[],[]).
course(cpsc1110,[],[]).
course(ece2010,[],[]).
course(ece2020,[math1080],[phys2210]).
course(ece2090,[],[]).
course(ece2110,[],[ece2020]).
course(ece2120,[ece2110],[ece2620]).
course(ece2220,[cpsc1110],[]).
course(ece2230,[ece2220],[]).
course(ece2620,[ece2020,phys2210,math2060],[]).
course(ece2720,[ece2010,cpsc1110],[]).
course(ece2730,[],[ece2720]).
course(ece3110,[ece2120],[]).
course(ece3170,[ece2620,math2080],[ece3300]).
course(ece3220,[ece2720,ece2230],[]).
course(ece3270,[ece3710],[]).
course(ece3300,[ece2620,math2080],[]).
course(ece3520,[ece2230],[math4190]).
course(ece3710,[ece2720],[ece2620]).
course(ece3720,[],[ece3710]).
course(ece4090,[ece3300],[]).
course(ece4950,[ece3710,ece2230,ece3200],[ece4090]).
course(ece4960,[ece3270,ece3520,ece4950,ece4090],[]).
course(engl1030,[],[]).
course(engr1020,[],[]).
course(engr1410,[engr1020],[]).
course(math1060,[],[]).
course(math1080,[math1060],[]).
course(math2060,[math1080],[]).
course(math2080,[math2060],[]).
course(math3110,[math1080],[]).
course(math4190,[math3110],[]).
course(phys1120,[],[math1060]).
course(phys2210,[],[math1080]).
/* completed( <course-name>, <grade> ) */  /* ALREADY TAKEN */
completed(C) :- completed(C,_).
completed(engr1020,a).
completed(ch1010,b).
completed(math1060,a).
completed(engl1030,b).
completed(ece3710,a).

/* RULES */
/* returns true if all courses are completed */
completed_all([]).
completed_all([CourseH | CourseT]) :-
    completed(CourseH),
    completed_all(CourseT).

/* return courses in Req-List not completed */
missing_req([], []).
missing_req([ReqH | ReqT], ReqR) :-
    missing_req(ReqT, TR),
    ( completed(ReqH) ->  
    ReqR = TR
    ;   ReqR = [ReqH | TR]).

/* return true if all pre-reqs satisified for Course */
prereq_satisfied(Course) :- 
    course(Course, Pre, _),
    completed_all(Pre).

/* return a lisst of missing pre-reqs for Course */
prereq_missing(Course, PreMiss) :-
    course(Course, Pre, _),
    missing_req(Pre, PreMiss).

/* return true if all co-reqs satisified for Course */
coreq_satisfied(Course) :-
    course(Course, _, Co),
	completed_all(Co).

/* return a lisst of missing co-reqs for Course */
coreq_missing(Course, CoMiss) :-
    course(Course, _, Co),
    missing_req(Co, CoMiss).

/* return lists of missing pre-reqs in L1 and co-reqs in L2 for course C 
*/
/* prints a message if course is already completed */
check_course(Course, L1, L2) :-
    (   completed(Course)
    ->  write('Course is already completed')
    ;   prereq_missing(Course, L1),
    	coreq_missing(Course, L2)
	).

/* prints all of the missing pre-reqs in L1 and co-reqs in L2 for all */
/* courses in LC  or returns true if there are none missing */
check_schedule([], [], []).
check_schedule([CourseH | CourseT], L1, L2) :-
    completed(CourseH), !,
    check_schedule(CourseT, L1, L2).
check_schedule([CourseH | CourseT], L1, L2) :-
    check_schedule(CourseT, TL1, TL2),
    prereq_missing(CourseH, Pre),
    coreq_missing(CourseH, Co),
  	append(TL1, Pre, L1),
   	append(TL2, Co, L2).

/* prints one (or more) courses that are not completed and do have their 
*/
/* requisites satisfied. */
suggest_course(Course) :-
    course(Course, _, _),
    \+ completed(Course),
    prereq_satisfied(Course),
    coreq_satisfied(Course).
