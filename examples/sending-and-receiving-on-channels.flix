/// A function that sends every element of a list
def send(o: Channel[Int], l: List[Int]): Unit =
    match l with {
        case Nil     => ()
        case x :: xs => o <- x; send(o, xs)
    }

/// A function that receives n elements
/// and collects them into a list.
def recv(i: Channel[Int], n: Int): List[Int] =
    match n with {
        case 0 => Nil
        case _ => (<- i) :: recv(i, n - 1)
    }

/// A function that calls receive and sends the result on d.
def wait(i: Channel[Int], n: Int, d: Channel[List[Int]]): Unit =
    d <- recv(i, n);
    ()

/// Spawn a process for send and wait, and print the result.
def main(): List[Int] =
    let l = 1 :: 2 :: 3 :: Nil;
    let c = chan Int 100;
    let d = chan List[Int] 100;
    spawn send(c, l);
    spawn wait(c, List.length(l), d);
    <- d
