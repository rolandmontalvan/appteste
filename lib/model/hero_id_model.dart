import 'package:meta/meta.dart';

class HeroId {
  final String progressId;
  final String titleId;
  final String codePointId;
  final String remainingTaskId;

  HeroId({
    @required this.progressId,
    @required this.titleId,
    @required this.codePointId,
    @required this.remainingTaskId,

//     @required é usado para anotar um parâmetro nomeado `p` em um método ou função` f`. 
//     Indica que toda chamada de `f` deve incluir um argumento correspondente a` p`,
//      apesar do fato de que `p` seria um parâmetro opcional. 
//      Ferramentas, como o analisador, podem fornecer feedback se
// * a anotação está associada a qualquer coisa que não seja um parâmetro nomeado,
// * a anotação está associada a um parâmetro nomeado em um método `m1` que substitui um método` m0` e `m0` define um parâmetro nomeado com o mesmo nome que não possui essa anotação, ou
// * uma invocação de um método ou função não inclui um argumento correspondente a um parâmetro nomeado que possui esta anotação.
  });
}
