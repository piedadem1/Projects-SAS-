/*Selecting the Best Model using Honest Assessment*/

proc glmselect data=STAT1.ameshousing3
               seed=8675309
               noprint;
    class &categorical / param=ref ref=first;
    model SalePrice=&categorical &interval / 
               selection=stepwise
               (select=aic 
               choose=validate) hierarchy=single;
    partition fraction(validate=0.3333);
    score data=STAT1.ameshousing4 out=score1;
    store out=store1;
    title "Selecting the Best Model using Honest Assessment";
run;

proc plm restore=store1;
    score data=STAT1.ameshousing4 out=score2;
run;

proc compare base=score1 compare=score2 criterion=0.0001;
    var P_SalePrice;
    with Predicted;
run;

