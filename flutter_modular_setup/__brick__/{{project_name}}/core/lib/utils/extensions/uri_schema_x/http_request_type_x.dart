//
// extension StringHttpMethod on String {
//   HttpMethod asHttpMethod() {
//     switch (toUpperCase()) {
//       case "POST":
//         return HttpMethod.Post;
//       case "GET":
//         return HttpMethod.Get;
//       case "DELETE":
//         return HttpMethod.Delete;
//       case "PUT":
//         return HttpMethod.Put;
//       case "PATCH":
//         return HttpMethod.Patch;
//       case "OPTIONS":
//         return HttpMethod.Options;
//       default:
//         return HttpMethod.Get;
//     }
//   }