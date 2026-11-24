# Functional Programming - What | OCaml Programming | Chapter 1 Video 2

- **URL:** https://www.youtube.com/watch?v=JTEwC3HihFc **Channel:** Michael Ryan Clarkson **Published:** 2021-06-11 **Duration:** 7:22 **Transcript:** manual (en), 957 words
## Summary
Michael Ryan Clarkson examines the conceptual differences between imperative and functional programming paradigms. The discussion centers on the roles of mutable state, side effects, and referential transparency in code design, highlighting how functional languages prioritize immutability to simplify reasoning and enhance the reliability of software construction.
## Transcript
[Chapter 1]: What is a functional language?
Well, it's really more of something that's on a spectrum than a precise definition.
But for now, let's say that a functional language is one that defines computations as mathematical functions and avoids mutable state. [pause (2.6s)]
What I mean by state is the information maintained by a computation.
You're used to maintaining state, say for example when you build a linked list class in Java.
It maintains information, perhaps about how many elements are in the linked lists, or which nodes are at the very beginning and very end of the list.
That's the state that's maintained.
Or perhaps you're implementing Dijkstra's algorithm, and you're exploring to find the nearest city, the shortest path to it.
There is state that is maintained in terms of a frontier set in that algorithm.
Mutable state is a state that can be changed.
One instant in a computation the state is one thing, and another instant in the computation the state has evolved and changed.
That change is the essence of mutability.
The [uh] antonym for mutable, by the way, is immutable.
So functional languages avoid mutable state, they embrace immutability, and they do so by expressing computations as mathematical functions. [pause (3.1s)]
[Chapter 2] What is Mutability?
Mutability is something you've probably been taking for granted for a long time now, and it's a very seductive notion.
The fantasy of mutability is that it's easy to reason about, because you think — well, it's not your fault, you were taught to think this — the machine does this, and then it does this, and this, and so forth and so on-- there's just this linear sequence of actions that's taking place.
The reality of mutability is twofold.
The first piece of it is that machines are really good about complicated manipulations of state, but our brains are not.
Human brains are not good at this, but the machine is; that's what it was built to do.
That's what the processor in this [sentence restart] inside the machine actually makes possible, and you learn all about that in CS 3410. [pause (2.5s)]
What's really a problem with mutability, to use a fancy technical term now, is that it breaks what's called referential transparency.
That means the ability to replace an expression with its value without changing the result of the computation. [pause (2.8s)]
Referential transparency makes it easy for humans to reason about a computation, because we can just substitute one thing with another.
Mutable state breaks that, because a variable can change its value from one time to another.
And that's exactly what happens with imperative programming.
[Chapter 3]: Imperative programming is kind of the opposite end of the spectrum from functional.
Imperative programming is what you've come to love and know through [uh] your classes that had Python or Java.
In an imperative program, we have commands, which specify how to compute by destructively changing the state.
Here are three examples of such commands.
`x` becomes `x + 1`.
Now, no self-respecting mathematician is ever going to write `x = x + 1`.
That's an equation that can't possibly hold, but programmers write it all the time.
It's a destructive change to the state.
We're actually taking some bits in memory and replacing them with other bits that change the meaning of this name `x` from one instant in computation to another. [pause (3.2s)]
An array update like `a[i]` becomes `42`, or a pointer change like `p.next` becomes `p.next.next` — those are also examples of commands that change the state.
They're saying how to compute.
What I want the computer to do with each of those is to update some bits in memory that I've given a name to. [pause (3.4s)]
Another phenomenon that occurs with imperative programming is what's called a side effect.
There are many definitions of what a side effect could be, but let's go with a simple one for here.
Here is a function or a method — you could think of it as either, let's think of it as a method for now — that has a side effect by modifying a variable that was declared outside of it.
You call this method `incr_x`, and it's going to add 1 to `x` and return it.
That's the side effect when it adds one to this variable that was declared outside.
In addition to returning a value, it changes something in the state.
It's that change that really is the side effect there. [pause (3.2s)]
[Chapter 4]: Functional programming:
In functional programs, we don't have commands so much as expressions, and expressions don't say how to compute, they say what to compute.
So in a functional program, variables never change value.
That makes the very notion of calling them variables kind of suspect, but it's a word you've come to know and love from other programming classes, so I'm not going to attempt to change that at this point.
We could maybe better call them identifiers... But anyway, in a functional language, variables never change values.
They just aren't *variable* in a functional program.
Once a variable has a value, it's not going to change, and functions are never going to have side effects. [pause (4.1s)]
The reality of immutability is that it frees you as a programmer.
It makes your job easier, because you no longer have to think about state and how it changes-- If you've ever had to debug a program with pointers, you know the pain I'm talking about.
No more in the functional world...
So this gives you very powerful ways of writing and building correct programs.
And for that reason, concepts from functional programming have really taken hold in some areas of the programming world where you might not have expected to see them, like in web programming, or in building concurrent programs that run on machines that have many processors.
