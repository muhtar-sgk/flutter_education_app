import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:education_app/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'on_boarding_repo.mock.dart';

void main() {
  late OnBoardingRepo repo;
  late CacheFirstTimer usecase;

  setUp(() {
    repo = MockOnBoardingRepo();
    usecase = CacheFirstTimer(repo);
  });

  test('Should call OnBoardingRepo.cacheFirstTimer', () async {
    when(() => repo.cacheFirstTime()).thenAnswer((_) async => Left(
        ServerFailure(message: 'Unknown error occured', statusCode: 500),
      ),
    );

    final result = await usecase();

    expect(result, equals(Left<Failure, dynamic>(ServerFailure(
          message: 'Unknown error occured', 
          statusCode: 500,),
        ),
      ),
    );

    verify(() => repo.cacheFirstTime()).called(1);
    verifyNoMoreInteractions(repo);
  });
}
