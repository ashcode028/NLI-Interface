:-dynamic ask_name/1.
:-dynamic ask_minor/1.
:-dynamic ask_subminor/1.
:-dynamic ask_branch/1.
:-dynamic ask_choice/1.
:-dynamic ask_choice2/1.
:-dynamic ask_btp/1.


:- nl,write('Type "suggest." to get started.'),nl,nl.

print_intro():-
	write('STUDENT ADVISOR SYSTEM FOR CHOOSING ELECTIVES IN IIIT DELHI.'),nl,
	write('Responser must have already completed 4 semesters and passed all courses.'),nl.

print_minor_intro(X,Y):-
	Y==20,
	write("You need total of "),write(Y),write(" credits to get "),write(X),write(" minor."),nl,
	write("where 16 credits earned by regular courses and rest 4 credits earned by IP/IS."), nl.
print_minor_intro(X,Y):-
	Y==24,
	write("You need total of "),write(Y),write(" credits to get "),write(X),write(" minor."),nl,
	write("where 16 credits earned by regular courses and rest 4 credits earned by elective courses and rest 4 credits by BTP."), nl.

% prints list
printlist([]).
printlist([X|List]) :-
	write(X),nl,
	printlist(List).

% removes l2 from l1
remove_list([], _, []).
remove_list([X|Tail], L2, Result):- member(X, L2), !, remove_list(Tail, L2, Result).
remove_list([X|Tail], L2, [X|Result]):- remove_list(Tail, L2, Result).

% list concatination
list_concat([],L,L).
list_concat([X1|L1],L2,[X1|L3]) :- list_concat(L1,L2,L3).

% ENT MINOR
ent_core(["Entrepreneurial Khichadi", "New Venture Planning", "Entrepreneurial Communication"]).
ent_core_electives(["Product Development", "Designing Human Centered Systems", "Ideation", "Creative Thinking","Innovation"]).
ent_electives(["Marketing","Entrepreneurial Finance", "Microeconomics", "SocialEntrepreneurship"]).
prof_ent(["Tavpritesh","Pankaj Vajpayee","Payal C Mukherjee","Rakesh Chaturvedi"]).

% BIO MINOR
bio_core(["Biophysics","Cell Biology & Biochemistry", "Foundations of Modern Biology","Chemoinformatics","NB","ACB","MLBA","BDMH","CGAS"]).
prof_bio(["Tavpritesh","Raghava","Arjun Ray","Debarka Sengupta","Ganesh Bagler","Jaspreet Kaur Dhanjal"]).


% ECO MINOR
prof_eco(["Aasim Khan","Gaurav Arora","Kiriti Kanjilal","Souvik Dutta","Gayatri Nair"]).
eco_core(["Econometrics1", "Microeconomics", "Game theory"]).
eco_electives(["Market Design","Behavioural Economics","Foundations of Finance","Valuation and Portfolio Management","Derivatives and Risk Management","Spatial Statistics and Spatial Econometrics"]).


suggest:-
	print_intro,
	write("Enter your name ?"),nl,
    consult('facts.pl'),
    ask_name(NAME),nl,
	write(NAME),nl,
	write("Dear "), write(NAME),write(", Please answer the following questions to get set of electives which can be done."),nl,
	write(NAME),write(", do you want to pursue minor in Entrepreneurship, Economics, Computational Biology (y/n) ?"),nl,
	ask_minor(X),nl,
	write(X),nl,
	minor(X,NAME).


subminor(C,NAME):-
	C=='ent', 
	print_minor_intro(C,24),
	write(NAME),write(", Mandatory courses for you are "),nl,
	ent_core(L1),ent_core_electives(L2),ent_electives(L3),
	write(L1),nl,
	write("Elective core courses for you are "),nl,
	write(L2),nl,
	write("		List of electives courses where you need to choose only 1 "),nl,
	write(L3),nl,
	prof_ent(L4),
	write("Contact any of these prof to complete IP/IS"),nl,
	printlist(L4).

	
subminor(C,NAME):-
	C=='eco', 
	print_minor_intro(C,20),
	write(NAME),write("		Core courses for you are "),nl,
	eco_core(L1),eco_electives(L2),prof_eco(L3),
	write(L1),nl,
	write("Choose any one out of these courses"),nl,
	write(L2),nl,
	write("Contact any of these prof to complete IP/IS"),nl,
	printlist(L3).



subminor(C,NAME):-
	C=='bio',
	print_minor_intro(C,20),
	write("		Introduction to Quantitative Biology (IQB) is the only mandatory course."),nl,nl,
	write(NAME),write(", You need to complete any three 3xx-5xx level courses, some are listed below"),nl,
	bio_core(L1),prof_bio(L2),
	write(L1),nl,
	write("Contact any of these prof to complete IP/IS"),nl,
	printlist(L2).

minor(X,NAME):-
	X=='y',
	write("  For detailed information refer to minor regulations document on website"),nl,
	write(NAME),write(", Select the field you want your minors in:- Entrepreneurship, Economics, Computational Biology (ent/eco/bio) ?"),nl,
	ask_subminor(C),nl,
    write(C),
	subminor(C,NAME).

minor(X,NAME):- X=='n',
	write(NAME),write("What are your interests ?"),nl,
	write("1. Data Science "),nl,
	write("2. AI "),nl,
	write("3. Design "),nl,
	write("4. Networks Sytems Security"),nl,
	write("5. Social sciences"),nl,
	write("6. Software Devlopment"),nl,
	ask_choice(CHOICE),nl,
    write(CHOICE),nl,
	write("Are you interested in doing BTP in the same? (y/n)"),nl,
	ask_btp(BTP),nl,
    write(BTP),nl,
	write("Which branch are you in ?(cse/ece/csx)"),nl,
	ask_branch(BRANCH),nl,
    write(BRANCH),nl,
	getelectives(BRANCH,CHOICE,Finalchoices),nl,
	(
		BTP == 'n'->
			write(NAME),write(", Here are the list of electives for you"),nl,
			write(Finalchoices);
		BTP=='y'->
			write(NAME),write(", Here are the list of electives for you"),nl,
			write(", Since you are not from CSE branch, first 5 are CSE manatory courses are also given."),nl,
			write(Finalchoices),nl,
			write("Also, this is the list of profs you can contact to get BTP done"),nl,
			btp_profs(L),
			printlist(L)
	),
	write("Finished").

btp_profs(["Tavpritish Sethi","Raghava Mutharaju","TanmoyChakroborty","Jainendra Shukla","Sambuddho","Mukkulika","Pankaj Jalote","Mukesh Mohania","Rajiv Ratn","Arun Balaji"]).
cse_mandatory(["DSA","OS","DBMS","CN","OOPD"]).
datascience(["DMG","BDA","MLN","DS","BDMH"]).
ai(["ML","RL","NLP","DL","IR","AI","CV"]).
design(["DDV","DPP","WARDI","I3DD"]).
nss(["PN","NSS","FCS","NAD","NSC","CA","SE"]).
social_sciences(["TE","MB","FF","ATP","CMM","CP","CISP","ST"]).
software_devlopment(["MC","SDOS","MAD","CLDC","CMP","AOS","IBC"]).

% CSX
getelectives(BRANCH,CHOICE,Finalchoices):-
	(BRANCH=='csx'),(CHOICE==1),
	cse_mandatory(L1),datascience(L2),
	list_concat(L1,L2,Finalchoices).

getelectives(BRANCH,CHOICE,Finalchoices):-
	(BRANCH=='csx'),(CHOICE==2),
	cse_mandatory(L1),ai(L2),
	list_concat(L1,L2,Finalchoices).

getelectives(BRANCH,CHOICE,Finalchoices):-
	(BRANCH=='csx'),(CHOICE==3),
	cse_mandatory(L1),design(L2),
	list_concat(L1,L2,Finalchoices).

getelectives(BRANCH,CHOICE,Finalchoices):-
	(BRANCH=='csx'),(CHOICE==4),
	cse_mandatory(L1),nss(L2),
	list_concat(L1,L2,Finalchoices).

getelectives(BRANCH,CHOICE,Finalchoices):-
	(BRANCH=='csx'),(CHOICE==5),
	cse_mandatory(L1),social_sciences(L2),
	list_concat(L1,L2,Finalchoices).

getelectives(BRANCH,CHOICE,Finalchoices):-
	(BRANCH=='csx'),(CHOICE==6),
	cse_mandatory(L1),software_devlopment(L2),
	list_concat(L1,L2,Finalchoices).


% ECE
getelectives(BRANCH,CHOICE,Finalchoices):-
	(BRANCH=='ece'),(CHOICE==1),
	cse_mandatory(L1),datascience(L2),
	list_concat(L1,L2,Finalchoices).

getelectives(BRANCH,CHOICE,Finalchoices):-
	(BRANCH=='ece'),(CHOICE==2),
	cse_mandatory(L1),ai(L2),
	list_concat(L1,L2,Finalchoices).

getelectives(BRANCH,CHOICE,Finalchoices):-
	(BRANCH=='ece'),(CHOICE==3),
	cse_mandatory(L1),design(L2),
	list_concat(L1,L2,Finalchoices).

getelectives(BRANCH,CHOICE,Finalchoices):-
	(BRANCH=='ece'),(CHOICE==4),
	cse_mandatory(L1),nss(L2),
	list_concat(L1,L2,Finalchoices).

getelectives(BRANCH,CHOICE,Finalchoices):-
	(BRANCH=='ece'),(CHOICE==5),
	cse_mandatory(L1),social_sciences(L2),
	list_concat(L1,L2,Finalchoices).

getelectives(BRANCH,CHOICE,Finalchoices):-
	(BRANCH=='ece'),(CHOICE==6),
	cse_mandatory(L1),software_devlopment(L2),
	list_concat(L1,L2,Finalchoices).

% CSE ELECTIVES

getelectives(BRANCH,CHOICE,Finalchoices):-
	(BRANCH=='cse'),(CHOICE==6),
	write("Enter another choice of interest as well"),nl,
	write("Make sure you dont enter "),write(CHOICE),write(" again"),nl,
    ask_choice2(CHOICE2),nl,
    write(CHOICE2),nl,
	(
		CHOICE2 == 1 ->
			datascience(L1),software_devlopment(L2);
		CHOICE2 == 2 ->
			ai(L1),software_devlopment(L2);
		CHOICE2 == 3 ->
			design(L1),software_devlopment(L2);
		CHOICE2 == 4 ->
			nss(L1),software_devlopment(L2);
		CHOICE2 == 5 ->
			social_sciences(L1),software_devlopment(L2)
	),
	list_concat(L1,L2,Finalchoices).



getelectives(BRANCH,CHOICE,Finalchoices):-
	(BRANCH=='cse'),(CHOICE==5),
	write("Enter another choice of interest as well"),nl,
	write("Make sure you dont enter "),write(CHOICE),write(" again"),nl,
	ask_choice2(CHOICE2),
    write(CHOICE2),nl,
	(
		CHOICE2 == 1 ->
			datascience(L1),social_sciences(L2);
		CHOICE2 == 2 ->
			ai(L1),social_sciences(L2);
		CHOICE2 == 3 ->
			design(L1),social_sciences(L2);
		CHOICE2 == 4 ->
			nss(L1),social_sciences(L2);
		CHOICE2 == 6 ->
			software_devlopment(L1),social_sciences(L2)
	),
	list_concat(L1,L2,Finalchoices).



getelectives(BRANCH,CHOICE,Finalchoices):-
	(BRANCH=='cse'),(CHOICE==4),
	write("Enter another choice of interest as well"),nl,
	write("Make sure you dont enter "),write(CHOICE),write(" again"),nl,
	ask_choice2(CHOICE2),
    write(CHOICE2),nl,
	(
		CHOICE2 == 1 ->
			datascience(L1),nss(L2);
		CHOICE2 == 2 ->
			ai(L1),nss(L2);
		CHOICE2 == 3 ->
			design(L1),nss(L2);
		CHOICE2 == 6 ->
			software_devlopment(L1),nss(L2);
		CHOICE2 == 5 ->
			social_sciences(L1),nss(L2)
	),
	list_concat(L1,L2,Finalchoices).



getelectives(BRANCH,CHOICE,Finalchoices):-
	(BRANCH=='cse'),(CHOICE==3),
	write("Enter another choice of interest as well"),nl,
	write("Make sure you dont enter "),write(CHOICE),write(" again"),nl,
	ask_choice2(CHOICE2),
    write(CHOICE2),nl,
	(
		CHOICE2 == 1 ->
			datascience(L1),design(L2);
		CHOICE2 == 2 ->
			ai(L1),design(L2);
		CHOICE2 == 6 ->
			software_devlopment(L1),design(L2);
		CHOICE2 == 4 ->
			nss(L1),design(L2);
		CHOICE2 == 5 ->
			social_sciences(L1),design(L2)
	),
	list_concat(L1,L2,Finalchoices).


getelectives(BRANCH,CHOICE,Finalchoices):-
	(BRANCH=='cse'),(CHOICE==2),
	write("Enter another choice of interest as well"),nl,
	write("Make sure you dont enter "),write(CHOICE),write(" again"),nl,
	ask_choice2(CHOICE2),
    write(CHOICE2),nl,
	(
		CHOICE2 == 1 ->
			datascience(L1),ai(L2);
		CHOICE2 == 2 ->
			ai(L1),ai(L2);
		CHOICE2 == 3 ->
			design(L1),ai(L2);
		CHOICE2 == 4 ->
			nss(L1),ai(L2);
		CHOICE2 == 5 ->
			social_sciences(L1),ai(L2)
	),
	list_concat(L1,L2,Finalchoices).


getelectives(BRANCH,CHOICE,Finalchoices):-
	(BRANCH=='cse'),(CHOICE==1),
	write("Enter another choice of interest as well"),nl,
	write("Make sure you dont enter "),write(CHOICE),write(" again"),nl,
	ask_choice2(CHOICE2),
    write(CHOICE2),nl,
	(
		CHOICE2 == 2 ->
			ai(L1),datascience(L2);
		CHOICE2 == 3 ->
			design(L1),datascience(L2);
		CHOICE2 == 4 ->
			nss(L1),datascience(L2);
		CHOICE2 == 5 ->
			social_sciences(L1),datascience(L2);
		CHOICE2 == 6 ->
			software_devlopment(L1),datascience(L2)
	),
	list_concat(L1,L2,Finalchoices).