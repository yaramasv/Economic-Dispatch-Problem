using JuMP, Ipopt

m=Model(with_optimizer(Ipopt.Optimizer))

@variable(m,PG[1:3])
D=450
α=[3*0.0053 3*0.00889 3*0.00741]
β=[3*11.669 3*10.333 3*10.833]
γ=[3*213.1 3*200 3*240]
UB=[200 150 180]
LB=[50 37.5 45]

@objective(m,Min,sum(α[i]*PG[i]^2+β[i]*PG[i] for i in 1:3))

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
