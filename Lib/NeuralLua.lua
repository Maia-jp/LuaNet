--NeuralLua file
--Author: Joao P Maia
--This file takes care of all the neual network part
local nn = {}
matrix = require('Lib.Matrix') -- MODULE ISSUE||If the "module issue" error described in the documentation has occurred. Please change and path to point to Matrix.lua file
csv = require('Lib.csvHandler') --MODULE ISSUE ||If the "module issue" error described in the documentation has occurred. Please change and path to point to csvHandler.lua file


--Aux Functions
math.randomseed(os.time())
function labelToArray(dataset_size,item)
  local arr = {}
  for i=1,dataset_size do
    if i == item then
      table.insert(arr,1)
    else
      table.insert(arr,0)
    end
  end
return arr
end
function tabledel(tb,index)
  local tb_new = {}
  for i=1,#tb do
    if i ~= index then
      table.insert(tb_new,tb[i])
    end
  end
  return tb_new
end

function shuffle(array)
    -- fisher-yates
    local output = { }
    local random = math.random

    for index = 1, #array do
        local offset = index - 1
        local value = array[index]
        local randomIndex = offset*random()
        local flooredIndex = randomIndex - randomIndex%1

        if flooredIndex == offset then
            output[#output + 1] = value
        else
            output[#output + 1] = output[flooredIndex + 1]
            output[flooredIndex + 1] = value
        end
    end

    return output
end

function normalize(x,max,min)
  return (x-min)/(max-min) 
end
function IndexOf(t,val)
    for k=1, #t do 
        if tostring(t[k]) == tostring(val) then return k end
    end
end
function contains(table, val)
   for i=1,#table do
      if table[i] == val then 
         return true
      end
   end
   return false
end
function round(number, decimals)
    decimals = 10 or decimals
    local power = 10^decimals
    return math.floor(number * power) / power
end

--
--Activations functions
--

--Sigmoid
function sigmoid(x)
  return 1/ (1+math.exp(-x))
end
--Sigmoid Derivative
function Dsigmoid(x)

  return x * (1-x)
end
--Hyperbolic Tangent
function tanh(x)
  return math.tanh(x)
end
--Hyperbolic Tangent Derivative
function Dtanh(x)
  return 1-(x*x)
end

--
--Basic Functions
--

--Create a NN table
function nn.new(neurons,activation)
  activation = activation or "sigmoid"
  
  neural = {}
  -- store each neuron numbers
  neural.neurons = neurons
  --Store the weights
  neural.weights = {}
  --Activation and de activation function
  neural.F_activation = activation
  if activation == "sigmoid" then
    neural.activation  = sigmoid
    neural.Dactivation  = Dsigmoid
  else
    neural.activation  = tanh
    neural.Dactivation  = Dtanh
  end
  
  --Generate radom weights
  i = 1
  while i<#neurons do
    weight_n = matrix.newrdn(neurons[i+1],neurons[i])
    table.insert(neural.weights,weight_n)
    i = i+1
  end
  
  --Store BIAS
  neural.bias = {}
  i = 1
  while i<#neurons do
    bias_n = matrix.newzero(neurons[i+1],1)
    table.insert(neural.bias,bias_n)
    i = i+1
  end

  return neural
end
--
--Predicts
function nn.preddict(neural,x,trainning)
  --Transfrom x in matrix
  input = matrix.newfromarray(x)
  
  -- y = inputs
   y = {}
   table.insert(y,input)
   
  -- preddicting
  i = 1
  while i <= #neural.weights do
    Y_n = matrix.dot(neural.weights[i],y[i])
    Y_n = matrix.sum(Y_n,neural.bias[i])
    Y_n  = matrix.map(Y_n,neural.activation)
    Y_n = matrix.map(Y_n,round)
    table.insert(y,Y_n)
    i = i+1
  end
  
  if trainning then
    return y
  end
  
  return y[#y]
  
  end


--
--Trainning
function nn.train(neural,input_x,target_y,lr)
  -- lr = learning rate
  lr = lr or 0.5
  --preparation
  y = nn.preddict(neural,input_x,1)
  target_y = matrix.newfromarray(target_y)
  errors = {}
  --step A, calcutae overall error
  total_err = matrix.sub(target_y,y[#y])
  
  table.insert(errors,total_err)
  
  -- calculating erros in each layer
   i = #neural.weights
   k = 1
   while i > 1 do
    layer_trasposed = matrix.transpose(neural.weights[i])
    erro_n = matrix.dot(layer_trasposed,errors[k])
    table.insert(errors,erro_n)
    i = i-1
    k = k+1
  end
  
  -- calculating the deltas
  deltas = {}
  i = 1
  k = #y
  b = #neural.bias
  while i <= #neural.weights do
  gradient_n = y[k]
  gradient_n = matrix.map(gradient_n,neural.Dactivation)
  
  -- mutiplicar gradiente pelo erro
  gradient_n = matrix.mult(gradient_n,errors[i])
  gradient_n = matrix.mult1D(gradient_n,lr)
  
  -- Adiciona o gradiente ao BIAS
  neural.bias[b] = matrix.sum(neural.bias[b],gradient_n)
  b = b-1
  
  -- transpor o que esta saindo
  exiting = matrix.transpose(y[k-1])
  delta =  matrix.dot(gradient_n,exiting)
  
  table.insert(deltas,delta)
  
  
  i = i+1
  k = k-1
  end

  -- aplying deltas
  b = #neural.bias
  i = 1 
  k = #neural.weights
  while i <= #neural.weights do
    neural.weights[i] = matrix.sum(neural.weights[i],deltas[k])
    i = i+1
    k = k-1
  end
  
  -- aplying BIAS
  b = #neural.bias
  i = 1 
  k = #neural.weights
  while i <= #neural.weights do
    neural.weights[i] = matrix.sum(neural.weights[i],deltas[k])
    i = i+1
    k = k-1
  end
  
  
  return neural

end

--
--Dataset Trainning
--

--Geral data to trainnig
function nn.newdataset(labels,target,file,sep)
  sep =  sep or ","
  
  local dataset = {}
  dataset.x = {}
  dataset.y = {}
  dataset.Xlabel = {}
  dataset.Ylabel = {}

  local data = csv.totrain(file,sep)
  local teste = csv.totrain(file,sep)
  
  -- Check if the targets need conversion
  for i=1,#labels do
    if labels[i] == target then
      target_to_num = true
      -- new labels table without the target
      labels = tabledel(labels,i)
    end
  end
  
  -- convert label targets to numbers
  if target_to_num then
    -- convert label to number
    for i=1,#data do
      if contains(dataset.Ylabel,data[i][target]) == false then
      table.insert(dataset.Ylabel,data[i][target])
      end
    data[i][target] = IndexOf(dataset.Ylabel,data[i][target])
    end
  end
  

  
  
  -- convert the rest here
  for j=1,#labels do
    dataset.Xlabel[j] = {} -- create a table for each label
    index = labels[j]
    for i=1,#data do
      if contains(dataset.Xlabel[j],data[i][index]) == false then
      table.insert(dataset.Xlabel[j],data[i][index])
      end
    data[i][index] = IndexOf(dataset.Xlabel[j],data[i][index])
    end
  end
  
  -- convert everything to number
  for c=1,#data do
    for r=1,#data[c] do
      data[c][r] = tonumber(data[c][r])
    end
  end
  
  --pass to labels
  for i=1, # data do
    dataset.y[i] = data[i][target]
    data[i] = tabledel(data[i],target)
  end
  
  -- if target is label pass a arr as value
  for i=1,#dataset.y do
    dataset.y[i] = labelToArray(#dataset.Ylabel,dataset.y[i])
  end
  
  -- pass everything to dataset table
  for i=1,#data do
    dataset.x[i] = data[i]
  end

  return dataset

end
--Train in a dataset
function nn.traindataset(neural,dataset,options)
  --defalut options
  options = options or {}
  local lr = options.lr or 0.1
  local epochs = options.epoch or 150
  local validation = options.validation or 0.20
  local debug = options.debug or true
  local label = options.label or false
  
  --starting
  trainnig_data = #dataset.x - math.floor(#dataset.x*validation) 
  validation_data = math.floor(#dataset.x*validation)
  
  
  --trainnig for given epochs
  run = 0
  while run<epochs do
    if debug then
      print("Epoch "..run..' of '..epochs)
    end
    for t=1,trainnig_data do
      neural = nn.train(neural,dataset.x[t],dataset.y[t],lr)
    end
    run = run+1
  end

  --validate trannig
  --Accuracy
  acc = 0 
  for i=trainnig_data,#dataset.x do
    preddiction = nn.preddict(neural,dataset.x[i])
    true_y = dataset.y[i]
    true_y = matrix.newfromarray(true_y)
    
    --accuracy for classification
    if label then
      if nn.getlabel(dataset,true_y) == nn.getlabel(dataset,preddiction) then
        acc = acc+1
      end
    end
    
  end
  
  if debug then
    if label then
    print("Done training, "..acc.." correct awnsers of "..(#dataset.x-trainnig_data).." guesses. Estimated acuracy: "..acc/(#dataset.x-trainnig_data))
    end
  end
  return neural
end
--transform a matrix into a label
function nn.getlabel(dataset,mat)
  arr = matrix.toarray(mat)
  best = 1
  for i=1,#arr do
    if arr[i] > arr[best] then
      best = i
    end
  end
  return dataset.Ylabel[best]
end

--
--Save and Load functions
--

--Save NN table
function nn.save(neural,path,personal_name)
  path = path or nil
  personal_name = personal_name or math.random(0,1000)
  
  --NN Info
  name = "NN"..personal_name
  name = tostring(name)
  
  --NN Save geral Info
  info = io.open(path..name..".txt", "a")
  info:write(name.."\n")
  info:write(#neural.neurons.."\n")
  info:write(#neural.weights.."\n")
  info:write(#neural.bias.."\n")
  info:write(neural.F_activation.."\n")
  for i=1,#neural.neurons do
    info:write(neural.neurons[i].."\n")
  end

  --NN Save geral Neurons
  n = io.open(path..name.."Neurons"..".txt", "a")
  for k=1,#neural.neurons do
    neurons = neural.neurons[k]
    n:write(neurons.."\n")
  end
    
    
    
  --NN Save weights
  for k=1,#neural.weights do
    w = io.open(path..name.."Weights"..k..".txt", "a")
    weight = neural.weights[k]
    for i=1,weight.rows do
      for j=1,weight.cols do
            w:write(weight.matrix[i][j].."\n")
      end
    end
  end

  
  --Save Bias
  for k=1,#neural.bias do
    b = io.open(path..name.."Bias"..k..".txt", "a")
    bias = neural.bias[k]
    for i=1,bias.rows do
      for j=1,bias.cols do
            b:write(bias.matrix[i][j].."\n")
      end
    end
  end
  

end
--Load NN
function nn.load(path,name)
  
  --Create NN table
  neural = {}
  neural.weights = {}
  neural.bias = {}
  neural.neurons = {}
  
  
  --Get Info
  inf = io.open(path..name..".txt", "r")
  info = {}
  for line in inf:lines () do
    table.insert(info,line)
  end 

  name = info[1]
  neurons_N = info[2]
  weights = tonumber(info[3])
  bias = tonumber(info[4])
  neural.F_activation = info[5]
  
  for i = 6, #info do
    table.insert(neural.neurons,tonumber(info[i]))
  end
  
  
  --Get neurons
    neurons = {}
    neurons_path = path..name.."Neurons"..".txt"
    n = io.open(neurons_path, "r")
  for line in n:lines () do
      table.insert(neurons,tonumber(line))
  end

  
  --Get weights
  weights_values = {}
  for i=1,weights do
    weights_path = path..name.."Weights"..i..".txt"
    w = io.open(weights_path, "r")
    weights_values[i] = {}
    for line in w:lines () do
      table.insert(weights_values[i],tonumber(line))
    end 
  end
  
  
  
  --Get BIAS
  bias_values = {}
  for i=1,bias do
    bias_path = path..name.."Bias"..i..".txt"
    b = io.open(bias_path, "r")
    bias_values[i] = {}
    for line in b:lines () do
      table.insert(bias_values[i],tonumber(line))
    end 
  end
  
  
  
  --Weights to neural
  for i=1,#neurons-1 do
    neural.weights[i] = matrix.new(neurons[i+1],neurons[i],weights_values[i])
  end
  
  
  --Bias to neural
  for i=1,#neurons-1 do
    neural.bias[i] = matrix.new(neurons[i+1],1,bias_values[i])
  end
  
  
  
  
  if activation == "tanh" then
    neural.activation = tanh
    neural.Dactivation = Dtanh
  else
    neural.activation = sigmoid
    neural.Dactivation = Dsigmoid
  end
  
  return neural
end

--
--Neuroevolution functions
--

--Copy
function nn.copy(neural)
  new_neural = neural
  return new_neural
end
--Mutate
function nn.mutate(neural,mutation_type,mutation_rate,func_mutation)
  mutation_type = "shuffle" or mutation_type
  func_mutation = nil or func_mutation
  mutation_rate = 0.50 or mutation_rate
  func_mutation = func_mutation or function(x) return math.cos(x) end
  
  --Shuffle mutation
  if mutation_type == "shuffle" then
    -- get weights
    weights = {}
    for i=1,#neural.weights do
      weights[i] = matrix.toarray(neural.weights[i])
    end
    
    --Mutate
    for i=1,math.ceil(#weights*mutation_rate) do
      weights[i] = shuffle(weights[i])
    end
    
    -- insert mutation
    i = 1
    while i<#neural.neurons do
      weight_n = matrix.new(neural.neurons[i+1],neural.neurons[i],weights[i])
      neural.weights[i] = weight_n
      i = i+1
  end
    
  end
  
  --random mutation
  if mutation_type == "random" then
    for i=1,math.ceil(#weights*mutation_rate) do
      r = math.random(1,#neural.weights[i])
      neural.weights[i] = matrix.mult1D(neural.weights[i],math.random()*math.random(-9,9))
    end
  end
  --Function mutation
  if mutation_type == 'function' then
    for i=1,#neural.weights*mutation_rate do
      neural.weights[i] = matrix.map(neural.weights[i],func_mutation)
    end
  end
  return neural
end
-- Crossover
function nn.crossover(neuralA,neuralB)

  child = nn.new(neuralA.neurons)
  
  for i=1,#child.weights do
    if i%2 == 0 then
      child.weights[i] = neuralA.weights[i]
    else
      child.weights[i] = neuralB.weights[i]
    end
  end
  return child
end

return nn
