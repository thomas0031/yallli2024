import jdk.incubator.foreign.CLinker;
import jdk.incubator.foreign.FunctionDescriptor;
import jdk.incubator.foreign.MemoryAddress;
import jdk.incubator.foreign.SymbolLookup;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodType;

public class LinkedListWrapper implements AutoCloseable {
    private static final SymbolLookup SYMBOL_LOOKUP;
    private static final MethodHandle RUST_CREATE_LIST;
    private static final MethodHandle RUST_INSERT;
    private static final MethodHandle RUST_DELETE;
    private static final MethodHandle RUST_DISPLAY;
    private static final MethodHandle RUST_FREE_LIST;

    private final MemoryAddress listPtr;

    static {
        try {
            System.loadLibrary("rust_linked_list");
            SYMBOL_LOOKUP = SymbolLookup.loaderLookup();

            RUST_CREATE_LIST = SYMBOL_LOOKUP.lookup("rust_create_list")
                    .map(addr -> CLinker.getInstance().downcallHandle(
                            addr,
                            MethodType.methodType(MemoryAddress.class),
                            FunctionDescriptor.of(CLinker.C_POINTER)
                    ))
                    .orElseThrow();

            RUST_INSERT = SYMBOL_LOOKUP.lookup("rust_insert")
                    .map(addr -> CLinker.getInstance().downcallHandle(
                            addr,
                            MethodType.methodType(void.class, MemoryAddress.class, int.class),
                            FunctionDescriptor.ofVoid(CLinker.C_POINTER, CLinker.C_INT)
                    ))
                    .orElseThrow();

            RUST_DELETE = SYMBOL_LOOKUP.lookup("rust_delete")
                    .map(addr -> CLinker.getInstance().downcallHandle(
                            addr,
                            MethodType.methodType(void.class, MemoryAddress.class, int.class),
                            FunctionDescriptor.ofVoid(CLinker.C_POINTER, CLinker.C_INT)
                    ))
                    .orElseThrow();

            RUST_DISPLAY = SYMBOL_LOOKUP.lookup("rust_display")
                    .map(addr -> CLinker.getInstance().downcallHandle(
                            addr,
                            MethodType.methodType(void.class, MemoryAddress.class),
                            FunctionDescriptor.ofVoid(CLinker.C_POINTER)
                    ))
                    .orElseThrow();

            RUST_FREE_LIST = SYMBOL_LOOKUP.lookup("rust_free_list")
                    .map(addr -> CLinker.getInstance().downcallHandle(
                            addr,
                            MethodType.methodType(void.class, MemoryAddress.class),
                            FunctionDescriptor.ofVoid(CLinker.C_POINTER)
                    ))
                    .orElseThrow();
        } catch (Exception e) {
            throw new RuntimeException("Failed to initialize native methods", e);
        }
    }

    public LinkedListWrapper() {
        try {
            listPtr = (MemoryAddress) RUST_CREATE_LIST.invoke();
        } catch (Throwable e) {
            throw new RuntimeException("Failed to create linked list", e);
        }
    }

    public void insert(int data) {
        try {
            RUST_INSERT.invoke(listPtr, data);
        } catch (Throwable e) {
            throw new RuntimeException("Failed to insert data", e);
        }
    }

    public void delete(int data) {
        try {
            RUST_DELETE.invoke(listPtr, data);
        } catch (Throwable e) {
            throw new RuntimeException("Failed to delete data", e);
        }
    }

    public void display() {
        try {
            RUST_DISPLAY.invoke(listPtr);
        } catch (Throwable e) {
            throw new RuntimeException("Failed to display list", e);
        }
    }

    @Override
    public void close() {
        try {
            RUST_FREE_LIST.invoke(listPtr);
        } catch (Throwable e) {
            throw new RuntimeException("Failed to free list", e);
        }
    }

    public static void main(String[] args) {
        try (LinkedListWrapper list = new LinkedListWrapper()) {
            list.insert(1);
            list.insert(2);
            list.insert(3);
            System.out.println("After inserting 1, 2, 3:");
            list.display();

            list.delete(2);
            System.out.println("After deleting 2:");
            list.display();
        }
    }
}