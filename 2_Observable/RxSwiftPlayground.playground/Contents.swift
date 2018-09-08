import RxSwift

example(of: "just, of, from") {
    let one = 1
    let two = 2
    let three = 3
    
    let observable: Observable<Int> = Observable<Int>.from([one, two, three])
    
    observable.subscribe(onNext: { print($0) })
}

example(of: "Empty") {
    let observable = Observable<Void>.empty()
    observable
        .subscribe(onNext: { (element) in
            print(element)
        }, onCompleted: {
            print("Complete")
        }, onDisposed: {
            print("Disposed")
        })
}

example(of: "never") {
    let observable = Observable<Any>.never()
    
    observable
        .subscribe(onNext: { (element) in
            print(element)
        }, onError: { (err) in
            print(err.localizedDescription)
        }, onCompleted: {
            print("Completed")
        }, onDisposed: {
            print("Disposed")
        })
}

example(of: "range") {
    let observable = Observable<Int>.range(start: 1, count: 10)
    
    observable
        .subscribe(onNext: {
            print($0)
        })
}


example(of: "Dispose") {
    let disposeBag = DisposeBag()
    Observable.of("A", "B", "C")
        .subscribe { print($0) }
        .disposed(by: disposeBag)
    
}

example(of: "create") {
    
    enum MyError: Error {
        case anError
    }
    
    let disposeBag = DisposeBag()
    
    Observable<String>.create { observable in
        observable.onNext("1")
        //        observable.onError(MyError.anError)
        //        observable.onCompleted()
        observable.onNext("?")
        return Disposables.create()
        }
        .subscribe(onNext: { print($0) },
                   onError: { print($0.localizedDescription) },
                   onCompleted: { print("Completed") },
                   onDisposed: { print("Disposed") })
        .disposed(by: disposeBag)
    
}


example(of: "deferred") {
    let disposeBag = DisposeBag()
    
    var flip = false
    
    let factory: Observable<Int> = Observable.deferred {
        flip = !flip
        
        if flip {
            return Observable.of(1, 2, 3)
        } else {
            return Observable.of(4, 5, 6)
        }
    }
    
    for _ in 0...3 {
        factory.subscribe(onNext: {
            print($0, terminator: "")
        })
            .disposed(by: disposeBag)
        print()
    }
}

example(of: "Single") {
    let disposeBag = DisposeBag()
    
    enum FileReadError: Error {
        case fileNotFound, unreadable, encodingFailed
    }
    
    func loadText(from name: String) -> Single<String> {
        return Single.create(subscribe: { single in
            let disposable = Disposables.create()
            
            guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
                single(.error(FileReadError.fileNotFound))
                return disposable
            }
            
            guard let data = FileManager.default.contents(atPath: path) else {
                single(.error(FileReadError.unreadable))
                return disposable
            }
            
            guard let contents = String(data: data, encoding: .utf8) else {
                single(.error(FileReadError.encodingFailed))
                return disposable
            }
            
            single(.success(contents))
            
            return disposable
        })
    }
    
    loadText(from: "Copyright")
        .subscribe {
            switch $0 {
            case .success(let string):
                print(string)
            case .error(let error):
                print(error.localizedDescription)
            }
    }
    
}







