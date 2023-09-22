import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:education_app/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:education_app/src/on_boarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'on_boarding_repo.mock.dart';

void main() {
  late OnBoardingRepo repo;
  late CheckIfUserIsFirstTimer usecase;

  setUp(() {
    repo = MockOnBoardingRepo();
    usecase = CheckIfUserIsFirstTimer(repo);
  });

  test('Should call OnBoardingRepo.checkIfUserIsFirstTimer', () async {
    when(() => repo.checkIfUserIsFirstTimer()).thenAnswer((_) async => Left(
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

    verify(() => repo.checkIfUserIsFirstTimer()).called(1);
    verifyNoMoreInteractions(repo);
  });
}
