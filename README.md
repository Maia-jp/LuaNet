# LuaNet

Lua module for creating multilayer neural networks


<!-- ABOUT THE PROJECT -->
## About The Project
LuaNet, a module for using neural networks in Lua! **This module is a tool easy to use for beginners and at the same time powerful**  enough to be used in small projects
Inspired by the [Toy Neural Network](https://github.com/CodingTrain/Toy-Neural-Network-JS), this module aims to reach all people who are entering the world of machine learning and want to implement it in their projects and games.
In view of this, this module comes with functions for creating neural networks, as well as manipulating matrices. All of this is compatible with [LOVE2D]([https://love2d.org), as well as with all other platforms and projects that use lua.

As mentioned earlier, the objectives of this module are:
* Be friendly and easy to use for beginners
* Be compatible with the maximum of platforms, projects, systems and etc. that use lua

It is worth mentioning that this project **is not a library for high-level projects**, that is: that it has all the capacities and technologies for application in professional and academic environments, for that I recommend using tools such as pytorch.




<!-- GETTING STARTED -->
## Getting Started
Before anything I highly recommend that you look at the documentation in the ``` \Doc``` folder
This is an example of how you may give instructions on setting up your project locally.
To get a local copy up and running follow these simple example steps.

### Prerequisites

Only a single prerequisite:
* lua


### Installation

1. Download and extract to anywhere you wish. **It is important that the files "NeuralLua.lua", "Matrix.lua" and "csvHandler.lua" stay together in the same folder**
2. Sometimes you may have to adjust the location of the files in the code, if any of these files cannot find the other open the code and follow the instructions commented above the "require" of each file. **For a complete view of the error and how to fix it see the documentation,"module issue" section**




<!-- USAGE EXAMPLES -->
## Basic Usage
1 Import the module
```LUA
luanet = require("path".."NeuralLua")
matrix = require("path".."Matrix") --sometime you may need the matrix module
```
2. create the neural network
```LUA
network = luanet.new({2,3,2}) -- creates a neural network with 2 inputs, 1 hidden layer of 3 neurons and 2 outputs
```
3. Trains the neural network
```LUA
network = nn.train(network,{inputx1,inputx2},{outputy1,outputy2})
```
4. Make a prediction
```LUA
pr = nn.preddict(network,{output1,output2})
```
4. The prediction always returns a matrix table so you can convert it to an array or print using the following commands
```LUA
array = matrix.toarray(pr)
--or print
matrix.print(pr)
```

**I highly recommend that you look at the documentation in the ``` \Doc``` folder**



<!-- ROADMAP -->
## Roadmap

 - More activation functions
 - Normalize dataset function
 - Functions for handling images
 - Functions for handling text
 - Portuguese Documentation (Documentação em portugues)

<!-- CONTRIBUTING -->
## Contributing

Pull requests are **very welcome**. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.



<!-- CONTACT -->
## Author

 - João P. Maia 




<!-- ACKNOWLEDGEMENTS -->
## Bibliography
* [Codding train](https://www.youtube.com/channel/UCvjgXvBlbQiydffZU7m1_aw)
* [3Blue1Brown]([https://www.youtube.com/channel/UCYO_jab_esuFRV4b17AJtAw)
* [Toy Neural Network](https://github.com/CodingTrain/Toy-Neural-Network-JS)

I researched and studied many resources for this list. I would like to name these pos was inspired by these channels that I started with this project. For a complete list check the documentation
