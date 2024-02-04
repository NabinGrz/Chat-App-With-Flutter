import 'package:dartz/dartz.dart';

import '../../login/data/models/failed_login_model.dart';
import '../../login/data/models/successful_login_model.dart';
import '../../shared/api/typed_response.dart';

typedef LoginResponse
    = DataResponse<Either<SuccessfullLoginResponse, FailedLoginResponse>>;
