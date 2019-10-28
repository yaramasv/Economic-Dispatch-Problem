using JuMP, Ipopt

m=Model(with_optimizer(Ipopt.Optimizer))

@variable(m,PG[1:3])

D=250
α=[3*0.28*0.0053 3*0.56*0.00889 3*0.448*0.00741]
β=[3*0.28*11.669 3*0.56*10.333 3*0.448*10.833]
γ=[3*0.28*213.1 3*0.56*200 3*0.448*240]
UB=[200 150 180]
LB=[50 37.5 45]

@objective(m,Min,sum(α[i]*PG[i]^2+β[i]*PG[i]+γ[i] for i in 1:3))

@constraint(m,sum(PG[i] for i in 1:3)-D==0)

for i in 1:3
@constraint(m,PG[i] .<=UB[i])
@constraint(m,PG[i] .>=LB[i])
end

println("The optimization problem to be solved is:")
print(m)
JuMP.optimize!(m)
optimvalue=JuMP.objective_value(m)
PG=JuMP.value.(PG)

println("Objective value:",optimvalue)
println("PG1=:",PG[1])
println("PG2=:",PG[2])
println("PG3=:",PG[3])





#PG3=JuMP.value(PG[i] for i in 3)
#PG2=JuMP.value(PG[i])
#PG3=JuMP.value(PG3)

#println("PG2=:",PG2)
#println("PG3=:",PG3)
#=
@variable(m,PG2)
@variable(m,PG3)
#i=[1:3]
PG=[PG1 PG2 PG3]
D=250

α=[3*0.0053 3*0.00889 3*0.00741]
β=[3*11.669 3*10.333 3*10.833]
γ=[3*213.1 3*200 3*240]
#=@variable(myModel,w)
@variable(myModel,w=5-x1-x2)
=#
@objective(m,Min,sum[α[i]*PG[i]^2+β[i]*PG[i]+γ[i]])
@constraint(m,sum[PG[i],i=1:3]-D==0)
@constraint(m,PG[i]<=[200 150 180])
@constraint(m,PG[i]>=[50 37.5 45])
#@constraint(myModel,w=0)

println("The optimization problem to be solved is:")
print(m)
JuMP.optimize!(m)
optimvalue=JuMP.objective_value(m)
PG1=JuMP.value(PG1)
PG2=JuMP.value(PG2)
PG3=JuMP.value(PG3)
println("Objective value:",optimvalue)
println("PG1=:",PG1)
println("PG2=:",PG2)
println("PG3=:",PG3)
=#
