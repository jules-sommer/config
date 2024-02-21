use std::time;


fn main() {
  loop {
    println!("Hello, world!");
    std::thread::sleep(time::Duration::from_secs(1));
  }
}
