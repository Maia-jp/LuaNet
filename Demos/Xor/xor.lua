local nn = require("Lib.NeuralLua")
local matrix = require("Lib.Matrix")

local brain= nn.new({2,3,1})

local i = 0

while i<200 do
  brain = nn.train(brain,{1,1},{0})
  brain = nn.train(brain,{0,1},{1})
  brain = nn.train(brain,{1,0},{1})
  brain = nn.train(brain,{1,1},{0})
  i= i+1
  print("Epoch"..i)
end

pr = nn.preddict(brain,{0,1});
matrix.print(pr)