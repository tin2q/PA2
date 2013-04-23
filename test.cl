
(*
 *  ECS 142 Spring 13
 *
 *  Programming Assignment 1
 *    Implementation of a simple stack machine.
 *
 *  Skeleton file
 *)

(* (* nested comment *) *)

class Main inherits IO {
  st : Stack <- new Stack;

   main() : Object {
    {
    out_string(">");
    (let value : String <- in_string() in {
      while (not value = "x") loop {
        if value = "d" then
          print_stack(st)
        else if value = "e" then {
          st <- st.head().eval(st);
        }
        else if value = "+" then {
          st <- st.cons(new Plus.setVal(value));
        }
        else if value = "s" then {
          st <- st.cons(new Swap.setVal(value));
        }
        else
          st <- st.cons(new StackCommand.setVal(value))
        fi fi fi
        fi;
        out_string(">");
        value <- in_string();
        --out_string(value);
         
      } pool;
    });
    }
   };

  print_stack(l : Stack) : Object {
    if l.isNil() then out_string("")
    else {
      out_string(l.head().getVal());
      out_string("\n");
      print_stack(l.tail());
    }
    fi
  };

};

class Stack {
  isNil() : Bool { true };
  head() : StackCommand { (new StackCommand).setVal("x")};
  tail() : Stack { self };
  cons(i : StackCommand) : Stack {
    (new Item).init(i, self)
  };
};

class Item inherits Stack {
  car : StackCommand;
  cdr : Stack;
  isNil() : Bool { false };
  head()  : StackCommand { car };
  tail()  : Stack { cdr };
  init(i: StackCommand, rest : Stack) : Stack {
    {
      car <- i; 
      --(new IO).out_string(car.getVal());
      cdr <- rest;
      self;
    }
  };
};

class StackCommand {
  val : String;
  setVal(v: String) : SELF_TYPE {
    {
      val <- v;
      --(new IO).out_string(val);
      self;
    }
  };
  getVal() : String {
    val
  };
  eval(st : Stack) : Stack {
    st
  };
};

class Plus inherits StackCommand {
  sym : String <- "+";
  eval(st : Stack) : Stack {
    {
      st <- st.tail(); -- pop +
      --(new IO).out_string("Plus\n");
      --(new IO).out_string(st.head().getVal());
      (let z: A2I <- new A2I in {
        (let result : StackCommand <- new StackCommand.setVal(z.i2a(
                      add(z.a2i(st.head().getVal()),
                           z.a2i(st.tail().head().getVal())))) in {
          st <- st.tail(); --pop first number
          st <- st.tail(); --pop second number
          st <- st.cons(result); -- push result
        --(new IO).out_string(st.head().getVal());
        });
      });
      st;
    }
  };

  add(numa : Int, numb : Int) : Int {
    {
    --(new IO).out_string("in add\n");
    --(new IO).out_int(numa);
    --(new IO).out_int(numb);
      numa + numb;
    }
  };
};

class Swap inherits StackCommand {
  sym: String <- "s";
  eval(st : Stack) : Stack {
    {
      st <- st.tail(); --pop s
      (let a : StackCommand <- st.head() in {
          st <- st.tail(); -- pop first item
          (let b : StackCommand <- st.head() IN {
            st <- st.tail(); -- pop 2nd item
            st <- st.cons(a); -- push 
            st <- st.cons(b);
          });
        });
      st;
    }
  };
};

class Test inherits IO {
  backo(): SELF_TYPE {
    out_string("\0")
  };
  unescaped_string(): SELF_TYPE {
    out_string("abc
               bcd")
  };
  longString() : SELF_TYPE {
    out_string("aaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\
               ") 
  };
  unescaped_stringb(): SELF_TYPE {
    out_string("abc
               bcd")
};

(* models one-dimensional cellular automaton on a circle of finite radius
(*
 *  ECS 142 Spring 13
 *
 *  Programming Assignment 1
 *    Implementation of a simple stack machine.
 *
 *  Skeleton file
 *)

(* (* nested comment *) *)

class Main inherits IO {
  st : Stack <- new Stack;

   main() : Object {
    {
    out_string(">");
    (let value : String <- in_string() in {
      while (not value = "x") loop {
        if value = "d" then
          print_stack(st)
        else if value = "e" then {
          st <- st.head().eval(st);
        }
        else if value = "+" then {
          st <- st.cons(new Plus.setVal(value));
        }
        else if value = "s" then {
          st <- st.cons(new Swap.setVal(value));
        }
        else
          st <- st.cons(new StackCommand.setVal(value))
        fi fi fi
        fi;
        out_string(">");
        value <- in_string();
        --out_string(value);
         
      } pool;
    });
    }
   };

  print_stack(l : Stack) : Object {
    if l.isNil() then out_string("")
    else {
      out_string(l.head().getVal());
      out_string("\n");
      print_stack(l.tail());
    }
    fi
  };

};

class Stack {
  isNil() : Bool { true };
  head() : StackCommand { (new StackCommand).setVal("x")};
  tail() : Stack { self };
  cons(i : StackCommand) : Stack {
    (new Item).init(i, self)
  };
};

class Item inherits Stack {
  car : StackCommand;
  cdr : Stack;
  isNil() : Bool { false };
  head()  : StackCommand { car };
  tail()  : Stack { cdr };
  init(i: StackCommand, rest : Stack) : Stack {
    {
      car <- i; 
      --(new IO).out_string(car.getVal());
      cdr <- rest;
      self;
    }
  };
};

class StackCommand {
  val : String;
  setVal(v: String) : SELF_TYPE {
    {
      val <- v;
      --(new IO).out_string(val);
      self;
    }
  };
  getVal() : String {
    val
  };
  eval(st : Stack) : Stack {
    st
  };
};

class Plus inherits StackCommand {
  sym : String <- "+";
  eval(st : Stack) : Stack {
    {
      st <- st.tail(); -- pop +
      --(new IO).out_string("Plus\n");
      --(new IO).out_string(st.head().getVal());
      (let z: A2I <- new A2I in {
        (let result : StackCommand <- new StackCommand.setVal(z.i2a(
                      add(z.a2i(st.head().getVal()),
                           z.a2i(st.tail().head().getVal())))) in {
          st <- st.tail(); --pop first number
          st <- st.tail(); --pop second number
          st <- st.cons(result); -- push result
        --(new IO).out_string(st.head().getVal());
        });
      });
      st;
    }
  };

  add(numa : Int, numb : Int) : Int {
    {
    --(new IO).out_string("in add\n");
    --(new IO).out_int(numa);
    --(new IO).out_int(numb);
      numa + numb;
    }
  };
};

class Swap inherits StackCommand {
  sym: String <- "s";
  eval(st : Stack) : Stack {
    {
      st <- st.tail(); --pop s
      (let a : StackCommand <- st.head() in {
          st <- st.tail(); -- pop first item
          (let b : StackCommand <- st.head() IN {
            st <- st.tail(); -- pop 2nd item
            st <- st.cons(a); -- push 
            st <- st.cons(b);
          });
        });
      st;
    }
  };
};
   arrays are faked as Strings,
   X's respresent live cells, dots represent dead cells,
   no error checking is done *)
class CellularAutomaton inherits IO {
    population_map : String;
   
    init(map : String) : SELF_TYPE {
        {
            population_map <- map;
            self;
        }
    };
   
    print() : SELF_TYPE {
        {
            out_string(population_map.concat("\n"));
            self;
        }
    };
   
    num_cells() : Int {
        population_map.length()
    };
   
    cell(position : Int) : String {
        population_map.substr(position, 1)
    };
   
    cell_left_neighbor(position : Int) : String {
        if position = 0 then
            cell(num_cells() - 1)
        else
            cell(position - 1)
        fi
    };
   
    cell_right_neighbor(position : Int) : String {
        if position = num_cells() - 1 then
            cell(0)
        else
            cell(position + 1)
        fi
    };
   
    (* a cell will live if exactly 1 of itself and it's immediate
       neighbors are alive *)
    cell_at_next_evolution(position : Int) : String {
        if (if cell(position) = "X" then 1 else 0 fi
            + if cell_left_neighbor(position) = "X" then 1 else 0 fi
            + if cell_right_neighbor(position) = "X" then 1 else 0 fi
            = 1)
        then
            "X"
        else
            '.'
        fi
    };
   
    evolve() : SELF_TYPE {
        (let position : Int in
        (let num : Int <- num_cells[] in
        (let temp : String in
            {
                while position < num loop
                    {
                        temp <- temp.concat(cell_at_next_evolution(position));
                        position <- position + 1;
                    }
                pool;
                population_map <- temp;
                self;
            }
        ) ) )
    };
};
(*
class Main {
    cells : CellularAutomaton;
   
    main() : SELF_TYPE {
        {
            cells <- (new CellularAutomaton).init("         X         ");
            cells.print();
            (let countdown : Int <- 20 in
                while countdown > 0 loop
                    {
                        cells.evolve();
                        cells.print();
                        countdown <- countdown - 1;
                    
                pool
            );  (* end let countdown
            self;
        }
    };
};
*)
