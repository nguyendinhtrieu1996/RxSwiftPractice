//: Please build the scheme 'RxSwiftPlayground' first
import RxSwift
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

example(of: "PublishSubject") {
    let subject = PublishSubject<String>()
    subject.onNext("Is anyone listening?")
    
    let subscriptionOne = subject
        .subscribe(onNext: { print($0) })
    
    subject.onNext("Hello")
    
    let subscriptionTwo = subject
        .subscribe{
            print("2) ", $0.element ?? $0)
        }
    
    subscriptionOne.dispose()
    
    subject.onNext("emit 2")
    
    subscriptionTwo.dispose()
    
}
enum MyError: Error {
    case anError
}

func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
    print(label, event.element ?? event.error ?? event)
}

example(of: "BehaviorSubject") {
    let disposeBag = DisposeBag()
    let subject = BehaviorSubject(value: "Initial value")
    
    subject
        .subscribe { print(label: "1)", event: $0) }
        .disposed(by: disposeBag)
    
    subject.onNext("X")
    subject.onError(MyError.anError)
    
    subject
        .subscribe { print(label: "2)", event: $0) }
        .disposed(by: disposeBag)
}

example(of: "ReplaySubject") {
    let subject = ReplaySubject<String>.create(bufferSize: 2)
    let disposeBag = DisposeBag()
    
    subject.onNext("1")
    subject.onNext("2")
    subject.onNext("3")
    
    subject
        .subscribe { print(label: "1)", event: $0) }
        .disposed(by: disposeBag)
    
    subject
        .subscribe { print(label: "2)", event: $0) }
        .disposed(by: disposeBag)
    
    subject.onNext("4")
    subject.onError(MyError.anError)
    subject.dispose()
    
    subject.subscribe { print(label: "3)", event: $0) }
    
}

example(of: "Variable") {
    let disposeBag = DisposeBag()
    let variable = Variable("Initial value")
    
    variable.value = "New Initial value"
    
    variable.asObservable()
        .subscribe { print(label: "1) ", event: $0) }
        .disposed(by: disposeBag)
    
    variable.value = "1"
  
    variable.asObservable()
        .subscribe {
            print(label: "2)", event: $0)
        }
        .disposed(by: disposeBag)
  
    variable.value = "2"
}










