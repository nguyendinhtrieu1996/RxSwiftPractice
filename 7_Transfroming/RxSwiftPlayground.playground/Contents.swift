import RxSwift

example(of: "toArray") {
    let disposeBag = DisposeBag()
    
    Observable.of("A", "B", "C", "D")
        .toArray()
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

example(of: "map") {
    let disposeBag = DisposeBag()
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    
    Observable<NSNumber>.of(1, 2, 3, 4, 5, 6)
        .map { formatter.string(from: $0) ?? "" }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
}

example(of: "enumrated and map") {
    let disposeBag = DisposeBag()
    
    Observable.of(1, 2, 3, 4, 5, 6)
        .enumerated()
        .map { $0 > 2 ? $1 * 2 : $1 }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

struct Student {
    var score: BehaviorSubject<Int>
}

example(of: "flatMap") {
    let disposeBag = DisposeBag()
    
    let ryan = Student(score: BehaviorSubject<Int>(value: 80))
    let charlotte = Student(score: BehaviorSubject<Int>(value: 90))
    
    let student = PublishSubject<Student>()
    
    student
        .flatMap { $0.score }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
    student.onNext(ryan)
    ryan.score.onNext(91)
    ryan.score.onNext(34)
    student.onNext(charlotte)
    ryan.score.onNext(100)
    charlotte.score.onNext(200)
    ryan.score.onNext(299)
}

example(of: "flatMapLatest") {
    let disposeBag = DisposeBag()
    
    let ryan = Student(score: BehaviorSubject<Int>(value: 80))
    let charlotte = Student(score: BehaviorSubject<Int>(value: 90))
    
    let student = PublishSubject<Student>()
    
    student
        .flatMapLatest { $0.score }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
    student.onNext(ryan)
    ryan.score.onNext(91)
    ryan.score.onNext(34)
    student.onNext(charlotte)
    ryan.score.onNext(100)
    charlotte.score.onNext(200)
    ryan.score.onNext(299)
    
}

example(of: "materialize and demeterialize") {
    enum MyError: Error {
        case anError
    }
    
    let disposeBag = DisposeBag()
    
    let ryan = Student(score: BehaviorSubject<Int>(value: 80))
    let charlotte = Student(score: BehaviorSubject<Int>(value: 100))
    
    let student = BehaviorSubject(value: ryan)
    
    let studentScore = student
        .flatMapLatest { $0.score.materialize() }
    
    studentScore
        .filter {
            guard $0.error == nil else {
                print($0.error)
                return false
            }
            return true
        }
        .dematerialize()
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
    ryan.score.onNext(85)
    ryan.score.onError(MyError.anError)
    ryan.score.onNext(90)
    
    student.onNext(charlotte)
    
}





