#!/usr/bin/gawk -f
#. Designed to be fed:
#. ps -eo 'pid,state,pcpu,cputime,comm'|./ps.awk

function globals() {
    #. To workaround an annoying bug on v4.0.1
    printf("%s%s%s%s%s", pi[0], ps[0], pp[0], pt[0], pn[0]);
    ee=0;
    e=0;
    z="";
}

#. j = 0 --> HH:MM:SS
#. j = 1 --> HH:MM
function pst2s(ts, j) {
    s=0;
    l=split(ts, a, ":");
    for(i=l;i;i--)s += a[i]*(60**(l-i+j));
    return s;
}

BEGIN {
    globals();
}

{
    t=pst2s($4,0);
    if(($3>40)&&(t>1000))       { ee=1; z="CRIT"; }
    else if(($3>20)&&(t>1000))  { ee=1; z="WARN"; }
    else if(($3>5)&&(t>1000))   { ee=1; z="NOTE"; }
    else if(($3>60)&&(t>60))    { ee=1; z="WARN"; }
    else if(($3>90)&&(t>60))    { ee=1; z="INFO"; }

    if(ee) {
        #print($3,t);
        pi[length(pi)]=$1; #. PID
        ps[length(ps)]=$2; #. STATE
        pp[length(pp)]=$3; #. CPU %
        pt[length(pt)]=t;  #. CPU time
        pn[length(pn)]=$5; #. PNAME
        e=1;
        ee=0;
    }
}

END {
    if(e) {
        printf("%d %s",length(pi),z);
        for(i in pi) printf(" %d:%s:%s:%0.0f:%d", pi[i], ps[i], pn[i], pp[i], pt[i]);
        printf("\n");
    }
}
