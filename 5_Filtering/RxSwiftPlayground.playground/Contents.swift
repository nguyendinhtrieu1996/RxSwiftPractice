import RxSwift

example(of: "ignoreElements") {
    let strikes = PublishSubject<String>()
    
    let disposeBag = DisposeBag()
    
    strikes
        .ignoreElements()
        .subscribe({ _ in
            print("You're out")
        })
        .disposed(by: disposeBag)
    
    strikes.onNext("X")
    strikes.onCompleted()
    
}

example(of: "elementAt") {
    let strikes = PublishSubject<String>()
    let disposeBag = DisposeBag()
    
    strikes
        .elementAt(2)
        .subscribe(onNext: { _ in
            print("you're out")
        })
        .disposed(by: disposeBag)
    
    strikes.onNext("X")
    strikes.onNext("X")
    strikes.onNext("X")
    strikes.onNext("X")
}

example(of: "filter") {
    let disposeBag = DisposeBag()
    
    Observable.of(1, 2, 3, 4, 5, 6)
        .filter { $0 % 2 == 0 }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
}


example(of: "skip") {
    let disposeBag = DisposeBag()
    
    Observable.of("A", "B", "C", "D", "E", "F")
        .skip(3)
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
}

example(of: "skipWhile") {
    let disposeBag = DisposeBag()
    
    Observable.of(2, 2, 3, 4, 4)
        .skipWhile { $0 % 2 == 0 }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
}

example(of: "skipUntil") {
    let disposeBag = DisposeBag()
    
    let subject = PublishSubject<String>()
    let trigger = PublishSubject<String>()
    
    subject
        .skipUntil(trigger)
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
    subject.onNext("A")
    subject.onNext("B")
    subject.onNext("C")
    
    trigger.onNext("X")
    
    subject.onNext("D")
    
}

example(of: "take") {
    let disposeBag = DisposeBag()
    
    Observable.of(1, 2, 3, 4, 5, 6)
        .take(3)
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}


example(of: "takeWhile") {
    let disposeBag = DisposeBag()
    
    Observable.of(2, 4, 5, 4 , 6)
        .enumerated()
        .takeWhile { $0 < 3 && $1 % 2 == 0 }
        .map { $0.element }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
}

example(of: "distinctUntilChanges") {
    let disposeBag = DisposeBag()
    
    Observable.of("A", "A", "C", "C", "B")
        .distinctUntilChanged()
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}






