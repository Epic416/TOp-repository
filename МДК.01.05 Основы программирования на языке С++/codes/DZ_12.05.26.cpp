#include <iostream>
#include <memory>

int main() {
    std::unique_ptr<int> ptr1 = std::make_unique<int>(42);
    std::cout << *ptr1 << std::endl;

    std::shared_ptr<int> ptr2 = std::make_shared<int>(100);
    std::shared_ptr<int> ptr3 = ptr2;
    std::cout << ptr2.use_count() << std::endl;

    class B;
    class A {
    public:
        std::shared_ptr<B> b_ptr;
        ~A() {}
    };
    class B {
    public:
        std::weak_ptr<A> a_ptr;
        ~B() {}
    };

    std::shared_ptr<A> a = std::make_shared<A>();
    std::shared_ptr<B> b = std::make_shared<B>();
    a->b_ptr = b;
    b->a_ptr = a;
}