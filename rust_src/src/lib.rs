use std::os::raw::{c_int, c_void};

#[repr(C)]
struct LinkedList {
    head: *mut c_void,
}


extern "C" {
    fn create_list() -> *mut LinkedList;
    fn insert(list: *mut LinkedList, data: c_int);
    fn delete(list: *mut LinkedList, data: c_int);
    fn display(list: *mut LinkedList);
    fn free_list(list: *mut LinkedList);
}

pub struct RustLinkedList {
    list: *mut LinkedList,
}

impl RustLinkedList {
    pub fn new() -> Self {
        unsafe {
            RustLinkedList {
                list: create_list(),
            }
        }
    }

    pub fn insert(&mut self, data: i32) {
        unsafe {
            insert(self.list, data);
        }
    }

    pub fn delete(&mut self, data: i32) {
        unsafe {
            delete(self.list, data);
        }
    }

    pub fn display(&self) {
        unsafe {
            display(self.list);
        }
    }
}

impl Drop for RustLinkedList {
    fn drop(&mut self) {
        unsafe {
            free_list(self.list);
        }
    }
}

#[no_mangle]
pub extern "C" fn rust_create_list() -> *mut RustLinkedList {
    Box::into_raw(Box::new(RustLinkedList::new()))
}

#[no_mangle]
pub extern "C" fn rust_insert(list: *mut RustLinkedList, data: c_int) {
    unsafe {
        (*list).insert(data);
    }
}

#[no_mangle]
pub extern "C" fn rust_delete(list: *mut RustLinkedList, data: c_int) {
    unsafe {
        (*list).delete(data);
    }
}

#[no_mangle]
pub extern "C" fn rust_display(list: *mut RustLinkedList) {
    unsafe {
        (*list).display();
    }
}

#[no_mangle]
pub extern "C" fn rust_free_list(list: *mut RustLinkedList) {
    unsafe {
        drop(Box::from_raw(list));
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_create_list() {
        let _list = RustLinkedList::new();
    }

    #[test]
    fn test_insert_and_display() {
        let mut list = RustLinkedList::new();
        list.insert(1);
        list.insert(2);
        list.insert(3);

        list.display();
    }

    #[test]
    fn test_delete() {
        let mut list = RustLinkedList::new();
        list.insert(1);
        list.insert(2);
        list.insert(3);

        list.delete(2);

        list.display();
    }

    #[test]
    fn test_memory_safety() {
        for _ in 0..1000 {
            let mut list = RustLinkedList::new();
            for i in 0..100 {
                list.insert(i);
            }
            for i in 0..50 {
                list.delete(i * 2);
            }
        }
    }
}
