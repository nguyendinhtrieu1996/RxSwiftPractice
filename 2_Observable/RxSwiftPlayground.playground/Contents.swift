import RxSwift

example(of: "just, of, from") {
    let one = 1
    let two = 2
    let three = 3
    
    let observable: Observable<Int> = Observable<Int>.just(one)
    let observabl2 = Observable.of(one, two, three)
    let observable3 = Observable.of([one, two, three])
    let observable4 = Observable.from([one, two, three])
    
    observable.subscribe { print($0) }
}



