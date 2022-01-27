cd(dirname(@__FILE__))

using ProgressMeter, JLD, Statistics, MAT, Plots

fileIn = matopen("i140703-001_lfp-spikes.mat")
Data = read(fileIn)
close(fileIn)



events = Data["block"]["segments"][1]["events"][1]

TS_ON = events["times"][findall(x -> x == "65296", events["labels"])] ./ 30000
WS_ON = events["times"][findall(x -> x == "65360", events["labels"])][1:2:end] ./ 30000
CUE_ON = events["times"][findall(x -> x == "65365" || x == "65370", events["labels"])] ./ 30000
CUE_OFF = events["times"][findall(x -> x == "65360", events["labels"])][2:2:end] ./ 30000
GO_ON = events["times"][findall(x -> x == "65369" || x == "65366", events["labels"])] ./ 30000
SR = events["times"][findall(x -> x == "65385" || x == "65382", events["labels"])] ./ 30000
RW_ON = events["times"][findall(x -> x == "65509" || x == "65514", events["labels"])] ./ 30000
GO_RW_OFF = events["times"][findall(x -> x == "65376", events["labels"])] ./ 30000
STOP = events["times"][findall(x -> x == "65312", events["labels"])] ./ 30000
spiketrains = [Data["block"]["segments"][1, 1]["spiketrains"][i]["times"][:] for i ∈ 1:271] / 30000


####################################

Prog = Progress(271 * length(TS_ON))
cutspiketrains = []
for i ∈ 1:271
    for j ∈ 1:length(TS_ON)
        indices = findall(x -> x > [[0.0]; TS_ON][j] && x < [[0.0]; TS_ON][j+1], spiketrains[i])
        push!(cutspiketrains, [(i, spiketrains[i][n] - TS_ON[j]) for n ∈ indices]...)
        next!(Prog)
    end
end

save("cutspiketrains.jld", "cutspiketrains", cutspiketrains)

cutspiketrains

####################################

cut_TS_ON = []

for j ∈ 1:271
    push!(cut_TS_ON, (j, 0))
end

cut_TS_ON

####################################

cut_WS_ON = []

for i ∈ 1:length(TS_ON)-1
    indices = findall(x -> x > TS_ON[i] && x < TS_ON[i+1], WS_ON)
    for j ∈ 1:271
        push!(cut_WS_ON, [(j, WS_ON[n] - TS_ON[i]) for n ∈ indices]...)
    end
end

cut_WS_ON

####################################

cut_CUE_ON = []

for i ∈ 1:length(TS_ON)-1
    indices = findall(x -> x > TS_ON[i] && x < TS_ON[i+1], CUE_ON)
    for j ∈ 1:271
        push!(cut_CUE_ON, [(j, CUE_ON[n] - TS_ON[i]) for n ∈ indices]...)
    end
end

cut_CUE_ON

####################################

cut_CUE_OFF = []

for i ∈ 1:length(TS_ON)-1
    indices = findall(x -> x > TS_ON[i] && x < TS_ON[i+1], CUE_OFF)
    for j ∈ 1:271
        push!(cut_CUE_OFF, [(j, CUE_OFF[n] - TS_ON[i]) for n ∈ indices]...)
    end
end

cut_CUE_OFF

####################################

cut_GO_ON = []

for i ∈ 1:length(TS_ON)-1
    indices = findall(x -> x > TS_ON[i] && x < TS_ON[i+1], GO_ON)
    for j ∈ 1:271
        push!(cut_GO_ON, [(j, GO_ON[n] - TS_ON[i]) for n ∈ indices]...)
    end
end

cut_GO_ON

####################################

cut_CUE_OFF = []

for i ∈ 1:length(TS_ON)-1
    indices = findall(x -> x > TS_ON[i] && x < TS_ON[i+1], CUE_OFF)
    for j ∈ 1:271
        push!(cut_CUE_OFF, [(j, CUE_OFF[n] - TS_ON[i]) for n ∈ indices]...)
    end
end

cut_CUE_OFF

####################################

cut_SR = []

for i ∈ 1:length(TS_ON)-1
    indices = findall(x -> x > TS_ON[i] && x < TS_ON[i+1], SR)
    for j ∈ 1:271
        push!(cut_SR, [(j, SR[n] - TS_ON[i]) for n ∈ indices]...)
    end
end

cut_SR

####################################

cut_RW_ON = []

for i ∈ 1:length(TS_ON)-1
    indices = findall(x -> x > TS_ON[i] && x < TS_ON[i+1], RW_ON)
    for j ∈ 1:271
        push!(cut_RW_ON, [(j, RW_ON[n] - TS_ON[i]) for n ∈ indices]...)
    end
end

cut_RW_ON

####################################

cut_GO_RW_OFF = []

for i ∈ 1:length(TS_ON)-1
    indices = findall(x -> x > TS_ON[i] && x < TS_ON[i+1], GO_RW_OFF)
    for j ∈ 1:271
        push!(cut_GO_RW_OFF, [(j, GO_RW_OFF[n] - TS_ON[i]) for n ∈ indices]...)
    end
end

cut_GO_RW_OFF

####################################

cut_STOP = []

for i ∈ 1:length(TS_ON)-1
    indices = findall(x -> x > TS_ON[i] && x < TS_ON[i+1], STOP)
    for j ∈ 1:271
        push!(cut_STOP, [(j, STOP[n] - TS_ON[i]) for n ∈ indices]...)
    end
end

cut_STOP

####################################
[[1]; [2, 3]]

scatter(getindex.(cutspiketrains, 2), getindex.(cutspiketrains, 1), marker = :vline, c = :black, alpha = 0.01)

scatter!(getindex.(cut_TS_ON, 2), getindex.(cut_TS_ON, 1), marker = :vline, c = :red, ms = 5)

scatter!(getindex.(cut_WS_ON, 2), getindex.(cut_WS_ON, 1), marker = :vline, c = :green)

scatter!(getindex.(cut_CUE_OFF, 2), getindex.(cut_CUE_OFF, 1), marker = :vline, c = :blue)

scatter!(getindex.(cut_GO_ON, 2), getindex.(cut_GO_ON, 1), marker = :vline, c = :purple)

scatter!(getindex.(cut_SR, 2), getindex.(cut_SR, 1), marker = :vline, c = :brown)

scatter!(getindex.(cut_RW_ON, 2), getindex.(cut_RW_ON, 1), marker = :vline, c = :orange)

scatter!(getindex.(cut_GO_RW_OFF, 2), getindex.(cut_GO_RW_OFF, 1), marker = :vline, c = :yellow)

scatter!(getindex.(cut_STOP, 2), getindex.(cut_STOP, 1), marker = :vline, c = :black)

