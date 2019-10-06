module EvolucionDiferencial

greet() = print("Hello World!")
function ed(fnc,d,L,h,np,gen,n)
    hh,en=0,0
    fun_obj=zeros(n)
    x_opt=zeros(d,n)
    x_best=zeros(d)
    for replicas=1:n
        fopt=0
        tol=1e-6
        #L=ran[1];    #limite inferior de busqueda
        #h=ran[2];    #limite superior de busqueda
        F=0.5;      #cte de diFerenciacion
        cr=0.9;      #cte crossover
        #------creacion de poblacion---------#
        x=zeros(d,1);       #vector prueba
        pop=zeros(d,np);    #poblacion
        fit=zeros(1,np);    #fitnes de la poblacion
        ibest=1;            #indice de la mejor solucion
        r=zeros(3,1);       #indice aleatorio
        #inicializacion aleatoria de un generador de numeros
        for i=1:d
            for j=1:np
                pop[i,j]=L[i]+(h[i]-L[i])*rand()
            end
        end
        #print(pop)
        for jo=1:np
            fit[1,jo]=fnc(pop[:,jo]);
        end
        #--------optimizacion---------#
        for g=1:gen
            for j=1:np
                #seleccionar 3 individuos aleatorios de la pob.
                r1=floor(Int,rand()*np)+1;
                while r1==j
                    r1=floor(Int,rand()*np)+1;
                end
                r2=floor(Int,rand()*np)+1;
                while r2==r1||r2==j
                    r2=floor(Int,rand()*np)+1;
                end
                r3=floor(Int,rand()*np)+1;
                while r3==r2||r3==r1||r3==j
                    r3=floor(Int,rand()*np)+1;
                end
                #crear una nueva poblacion, el ultimo param. es ccambiado
                rnd=floor(Int,rand()*d)+1;
                for i=1:d
                    if rand()<cr||rnd==i
                        x[i]=pop[i,r3]+F*(pop[i,r1]-pop[i,r2]);
                    else
                        x[i]=pop[i,j];
                    end
                end
                #verificar que las var. esten en os limites
                for i=1:d
                    if(x[i]<L[i])||(x[i]>h[i])
                        x[i]=L[i]+(h[i]-L[i])*rand();
                    end
                end
                #seleccionar el mejor de los individuos y calcular fobj
                ffin=fnc(x)
                #si el valor prueba es mejor o igual que el actual
                if ffin<=fit[j]
                    pop[:,j]=x;
                    fit[j]=ffin;
                    #si prueba es mejor que actual
                    if ffin<=fit[ibest]
                        ibest=j;
                    end
                end
            end
        end
        ffin=fit[ibest];
        x=pop[:,ibest];
        #---------resutltados---------#
        print(replicas)
        print(" ",x)
        println(" ",ffin)
        #-------calculo de sr--------#
        if abs(ffin-fopt)<tol
            hh=hh+1;
        end

        if isnan(ffin)
            ffin=Inf
        end
        fun_obj[replicas]=ffin
        en=findmin(fun_obj)
        #println(en)
        #println(fun_obj)

        for ii=1:d
        x_opt[ii,replicas]=x[ii];
        x_best[ii]=x_opt[ii,en[2]]
        end
    end
    sr=(hh/n)*100;
    fobj=(sum(fun_obj))/n;

    println("El SR es de $sr %")
    println("El vector solucion es $x_best")
    println("El mejor valor de $fnc es $(en[1]) y su indice es $(en[2])")
    println("El valor promedio de la funcion objetivo es $fobj")
end

end # module
