
import RxSwift
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

example(of: "PublishSubject") {
    let subject = PublishSubject<String>()
    subject.onNext("is anyone listening?")
    
    let subsciptionsOne = subject
        .subscribe(onNext: { string in
            print(string)
        })
    
    subject.onNext("1")
    subject.onNext("2")
    
    let subscriptionTwo = subject
        .subscribe { event in
            print("2) ", event.element ?? event)
        }
    
    subject.onNext("3")
    subsciptionsOne.dispose()
    
    subject.onNext("4")
    subject.onCompleted()
    subject.onNext("5")
    
    subject
        .subscribe {
            print("3)", $0.element ?? $0)
        }
        .disposed(by: DisposeBag())
    
    subject.onNext("?")
}

enum MyError: Error {
    case anError
}

func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
    print(label, event.element ?? event.error)
}

example(of: "BehaviorSubject") {
    let disposeBag = DisposeBag()
    let subject = BehaviorSubject(value: "Initial value")
    
    subject
        .subscribe {
            print(label: "1)", event: $0)
        }
        .disposed(by: disposeBag)
    
    subject.onNext("X")
    subject.onError(MyError.anError)
    
    subject
        .subscribe {
            print(label: "2)", event: $0)
        }
        .disposed(by: disposeBag)
    
}

example(of: "ReplaySubject") {
    let subject = ReplaySubject<String>.create(bufferSize: 2)
    let disposeBag = DisposeBag()
    
    subject.onNext("1")
    subject.onNext("2")
    subject.onNext("3")
    
    subject
        .subscribe {
            print(label: "1)", event: $0)
        }
        .disposed(by: disposeBag)
    
    subject
        .subscribe {
            print(label: "2)", event: $0)
        }
    
    subject.onNext("4")
    
    subject
        .subscribe {
            print(label: "3)", event: $0)
        }
        .disposed(by: disposeBag)
    
    subject.onError(MyError.anError)
    subject.dispose()
}

example(of: "Variable") {
    let disposeBad = DisposeBag()
    let variable = Variable("Initial value")
    
    variable.value = "New initial value"
    
    variable
        .asObservable()
        .subscribe {
            print(label: "1)", event: $0)
        }
        .disposed(by: disposeBad)
    
    variable.value = "1"
    
    
    
}
