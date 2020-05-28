% To Calculate Number of Carriers Zonewise
zonewise_infected([],_,_,_,[]).
zonewise_infected([H|T],TP,R,A,[M|N]):-
    F is (A*H*TP)/(R*100),
    M is floor(F),
    zonewise_infected(T,TP,R,A,N).

% To Calculate Number of People infected in each zone w.r.t. Days
infected_pop_zw([],[],_,[]).
infected_pop_zw([H|T],[M|N],Days,[P|Q]):-
    P is H*(M^Days),
    infected_pop_zw(T,N,Days,Q).

% To Calculate Total infected Population
total_infected_pop([],0).
total_infected_pop([H|T],Sum):-
    total_infected_pop(T,Sum1),
    Sum is 0.7*(H+Sum1).
    
% Finding Number of Days
count_days(ZWIn,CPop,I,Pop,Time):-
    V is I+1,
    infected_pop_zw(ZWIn,CPop,V,InfectedInNDays),
    total_infected_pop(InfectedInNDays,S),
     (   S<Pop->  count_days(ZWIn,CPop,V,Pop,Time);
      S>=Pop ->  Time is V) .  

estimate():-
    write('Total Population (n) is '),
    read(N),
    
    write('Number of Persons per Carrier (r) is '),
    read(R),
    
    % Percentage of Population living in each zone
    append([15,30,35,10,7,2,0.8,0.1,0.1],[],ZonePopPercent),
    
    %Assumed Number of People coming in contact with Carriers
    % under given conditions per DAY
    append([10,10,9,8,7,5,3,2,2],[],ContactedPop),
    
    write('% of Population Infected (x) is '),
    read(X),
    
    % Number of infected people 
    Pop is (N*X)/100, 
    write(Pop),write(' people will be infected in '),
    
    % Calculating Number of Carriers present in each intially 
    nl,
    zonewise_infected(ZonePopPercent,N,R,1,ZoneWiseInfected),
   
    % Counting Number of Days in which given % of Population
    % will be affected
    count_days(ZoneWiseInfected,ContactedPop,0,Pop,T),
    write(T), write(' Days'),nl,
    
    write('Number of days taken during each MOP level'),nl,
   %   Calculations for Static MOP
    write('STATIC : '), write(Pop),write(' people will be infected in '),
    St is 0.2*N,
    zonewise_infected(ZonePopPercent,St,R,0.5,ZoneWInfected),
    count_days(ZoneWInfected,ContactedPop,0,Pop,T1),
    write(T1), write(' Days'),nl,
    
   %  Calculations for Dynamic MOP
    write('DYNAMIC : '), write(Pop),write(' people will be infected in '),
    Dy is 0.4*N,
    zonewise_infected(ZonePopPercent,Dy,R,0.7,ZoneWInfected1),
    count_days(ZoneWInfected1,ContactedPop,0,Pop,T2),
    write(T2), write(' Days'),nl,
    
    %  Calculations for Senstive MOP
    write('SENSITIVE : '), write(Pop),write(' people will be infected in '),
    Se is 0.8*N,
    zonewise_infected(ZonePopPercent,Se,R,1,ZoneWInfected2),
    count_days(ZoneWInfected2,ContactedPop,0,Pop,T3),
    write(T3), write(' Days'),nl
    
    .

