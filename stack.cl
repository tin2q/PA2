(*
 *  ECS 142 Spring 13
 *
 *  Programming Assignment 1
 *    Implementation of a simple stack machine.
 *
 *  Skeleton file
 *)

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

