--Import LuaNet module, contains all neural network functions
nn = require('Lib.NeuralLua')

--Import matrix.lua module, takes care of the matrix part
mat = require('Lib.Matrix')

--Create or train
print("Would you like to create a neural network or load the already trained network?? (Create type 0, Load type 1)")
local train = tonumber(io.read())

if train == 0 then
  --Creates a neural network with 4 inputs, a hidden layer of 5 neurons and 3 outputs
  Brain = nn.new({4,5,3})

  print("Press anything to to train")
  io.read()

  --Load the dataset in csv, first argument defines values that must be transformed into int, second defines y and lastly the file location
  dataset = nn.newdataset({5},5,'Demos/Iris/iris_dataset.csv')

  --training options
  options = {lr = 0.01,
     epochs = 150,
     validation = 0.20,
     debug = true,
     label = true }
  --Trains the neural network
  Brain = nn.traindataset(Brain,dataset,options)
  
else
  
  --Load the dataset in csv, first argument defines values that must be transformed into int, second defines y and lastly the file location
  dataset = nn.newdataset({5},5,'Demos/Iris/iris_dataset.csv')
  
  Brain = nn.load('Demos/Iris/Saved/',"NNIris")
  print("Model loaded")
end
--

--preddicting
print("Finished, start preddicting")
print("sepal length: ")
x1 = io.read()
print("sepal width: ")
x2 = io.read()
print("petal length: ")
x3 = io.read()
print("petal width: ")
x4 = io.read()

--Prediction based on inputs
pr = nn.preddict(Brain,{x1,x2,x3,x4})

--Turn prediction into a label
lbl = nn.getlabel(dataset,pr)
print(lbl)
