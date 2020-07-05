-- Matrix.lua 
--This file handles the creation and manipulation os the matrixes. 
--Author: Joao P Maia
--
--
local mat = {}
local write = io.write
math.randomseed(os.time())


--
-- Creating matrix
--

--New specifed matrix
function mat.new(rows,cols,values)
  grid ={}
  grid.rows = rows
  grid.cols = cols
  grid.matrix = {}
  j = 1
  for i=1,rows do
    grid.matrix[i] = {}
    for k=1,cols do
      grid.matrix[i][k] = values[j]
      j = j+1
    end
  end
    return grid
  end
  --
--New matrix fom 1d array
function mat.newfromarray(array)
  grid ={}
  grid.rows = #array
  grid.cols = 1
  grid.matrix = {}
  j = 1
  
  for i=1,grid.rows do
    grid.matrix[i] = {}
    for k=1,grid.cols do
      grid.matrix[i][k] = array[j]
      j = j+1
    end
  end
    return grid
  end
  --
--New Zero matrix
function mat.newzero(rows,cols)
  grid ={}
  grid.rows = rows
  grid.cols = cols
  grid.matrix = {}
  j = 1
  for i=1,rows do
    grid.matrix[i] = {}
    for k=1,cols do
      grid.matrix[i][k] = 0
      j = j+1
    end
  end
    return grid
  end
  --
  --New random matrix
  function mat.newrdn(rows,cols,positive)
  positive = false or positive
  grid ={}
  grid.rows = rows
  grid.cols = cols
  grid.matrix = {}
  j = 1
  for i=1,rows do
    grid.matrix[i] = {}
    for k=1,cols do
      if positive then
        grid.matrix[i][k] = math.random()
      else
        grid.matrix[i][k] = math.random(-1,0) + math.random()
      end
      j = j+1
    end
  end
    return grid
end
--New matrix from a given label, for classification
function mat.newfromlabel(rows,label_index)
  grid ={}
  grid.rows = rows
  grid.cols = 1
  grid.matrix = {}
  j = 1
  for i=1,rows do
    grid.matrix[i] = {}
    for k=1,grid.cols do
      if i == label_index then
        grid.matrix[i][k] = 1
      else
        grid.matrix[i][k] = 0
      end
    end
  end
    return grid
  end
  --
  
--
--  Matrix operations
--
  
-- Inner Sum
  function mat.innersum(m1)
    result = 0
    for i=1,result.rows do
      for j=1,result.cols do
          result = m1.matrix[i][j] + result
      end
    end
    return result
  end
  
  
  
-- Element sum
  function mat.sum(m1,m2)
    --checking if there is an error
    if(m1.cols ~= m2.cols or m1.rows ~= m2.rows) then
      print("erro in subtraction, cols rows erro")
    end
    --
    result = mat.newzero(m1.rows,m2.cols)
    for i=1,result.rows do
      for j=1,result.cols do
          result.matrix[i][j] = m1.matrix[i][j] + m2.matrix[i][j]
      end
    end
    return result
  end
  --  
-- Element subtraction
  function mat.sub(m1,m2)
    --checking if there is an error
    if(m1.cols ~= m2.cols or m1.rows ~= m2.rows) then
      print("Erro in matrix subtraction, cols rows erro")
    end
    --
    result = mat.newzero(m1.rows,m2.cols)
    for i=1,result.rows do
      for j=1,result.cols do
          result.matrix[i][j] = m1.matrix[i][j] - m2.matrix[i][j]
      end
    end
    return result
  end
  --    
-- Element multiply
  function mat.mult(m1,m2)
    result = mat.newzero(m1.rows,m2.cols)
    for i=1,result.rows do
      for j=1,result.cols do
          result.matrix[i][j] = m1.matrix[i][j] * m2.matrix[i][j]
      end
    end
    return result
  end
  --    
  --Dot product matrix
  function mat.dot(m1,m2)
    if m1.cols ~= m2.rows then
      print("Erro in matrix dot, cols rows erro")
      return
    end
    
    
    result = mat.newzero(m1.rows,m2.cols)
    for i=1,result.rows do
      for j=1,result.cols do
        sum = 0
        -- dot
        for k=1,m1.cols do
          sum = sum + m1.matrix[i][k] * m2.matrix[k][j]
        end
        result.matrix[i][j] = sum
      end
    end
    return result
  end
  --
 -- Scalar multiply
  function mat.mult1D(m1,scalar)
    result = mat.newzero(m1.rows,m1.cols)
    for i=1,result.rows do
      for j=1,result.cols do
          result.matrix[i][j] = m1.matrix[i][j] * scalar
      end
    end
    return result
  end
  --
  
--
--  Matrix modifications
--
  
  --Traspose
  function mat.transpose(m1)
    result = mat.newzero(m1.cols,m1.rows)
    for i=1,m1.rows do
      for j=1,m1.cols do
        result.matrix[j][i] = m1.matrix[i][j]
      end
    end
    return result
  end
  --
  --Apply a function in each number in the matrix
  function mat.map(m1,func)
    result = mat.newzero(m1.rows,m1.cols)
    for i=1,result.rows do
      for j=1,result.cols do
        result.matrix[i][j] = func(m1.matrix[i][j])
      end
    end
    return result
  end
  --
  --Matrix to array
  function mat.toarray(m1)
    result = {}
    for i=1,m1.rows do
      for j=1,m1.cols do
        table.insert(result,m1.matrix[i][j])
      end
    end
    return result
  end
  --
  
--
--  Matrix uncategorized functions
--

function mat.print(m,debug,separator)
  --DEBUG
  debug = debug or 0
  if debug ~= 0 then
    print("Matrix "..m.rows.."X"..m.cols..", ".. m.cols*m.rows.." elements")
  end
  --Separator
  separator = separator or " | "
  
  --Actual function
  for c=1,m.rows do
    r = 1
    while r <= m.cols do
      write(tostring(m.matrix[c][r]))
      write(separator)
      r = r+1
    end
    r = 1
    print()
  end
end  
  

--End
return mat