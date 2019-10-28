using JuMP, Ipopt

m=Model(with_optimizer(Ipopt.Optimizer))

@variable(m,P[1:3, 1:2])

D=250

α=[3*0.0053 3*0.00889 3*0.00741]
β=[3*11.669 3*10.333 3*10.833]
γ=[3*213.1 3*200 3*240]

#         Bus   Pg   Qg   Pmax   Pmin
Gendata=[ 1     110   0    200    50
          2      80   0    150    37.5
          3      50   0    180    45
        ];

P_max=Gendata[:,4]
P_min=Gendata[:,5]

P_bar=(P_max+P_min)/2

del_P=zeros(3,2)
for i in 1:3
    del_P[i,1]=P_bar[i]-P_min[i]
    del_P[i,2]=P_max[i]-P_bar[i]
end


slope=zeros(3,2)
for i in 1:3
 slope[i,1]=(α[i]*P_bar[i]^2+β[i]*P_bar[i]+γ[i]-α[i]*P_min[i]^2+β[i]*P_min[i]+γ[i])/(P_bar[i]-P_min[i])
 slope[i,2]=(α[i]*P_max[i]^2+β[i]*P_max[i]+γ[i]-α[i]*P_bar[i]^2+β[i]*P_bar[i]+γ[i])/(P_max[i]-P_bar[i])
end

UB=[del_P[1,1] del_P[1,2] del_P[2,1] del_P[2,2] del_P[3,1] del_P[3,2]]
LB=[0 0 0 0 0 0]

@objective(m,Min,sum(slope[i,1]*P[i,1]+slope[i,2]*P[i,2] for i in 1:3))

@constraint(m,sum(P[i,1]+P[i,2] for i in 1:3)-D+P_min[1]+P_min[2]+P_min[3]==0)


@constraint(m,P[1,1].<=UB[1])
@constraint(m,P[1,2].<=UB[2])
@constraint(m,P[2,1].<=UB[3])
@constraint(m,P[2,2].<=UB[4])
@constraint(m,P[3,1].<=UB[5])
@constraint(m,P[3,2].<=UB[6])

@constraint(m,P[1,1].>=LB[1])
@constraint(m,P[1,2].>=LB[2])
@constraint(m,P[2,1].>=LB[3])
@constraint(m,P[2,2].>=LB[4])
@constraint(m,P[3,1].>=LB[5])
@constraint(m,P[3,2].>=LB[6])


println("The optimization problem to be solved is:")
print(m)
JuMP.optimize!(m)
optimvalue=JuMP.objective_value(m)
P=JuMP.value.(P)

println("Objective value:",optimvalue)
println("P11=:",P[1,1])
println("P12=:",P[1,2])
println("P21=:",P[2,1])
println("P22=:",P[2,2])
println("P31=:",P[3,1])
println("P32=:",P[3,2])

println("Dispatch of individual generators")
println("PG1=",P_min[1]+P[1,1]+P[1,2])
println("PG2=",P_min[2]+P[2,1]+P[2,2])
println("PG3=",P_min[3]+P[3,1]+P[3,2])
