# prueba-tecnica-upax

# Prueba Técnica para la vacante de programador iOS para UPAX
- - - -

# Complemento de la Prueba Técnica: Preguntas teóricas.

### 6.- Explique el ciclo de vida de un view controller

EL ciclo de vida de un View Controller, es una serie de estados de transición (representados por métodos) ejecutados automáticamente dentro de toda clase que herede de UIViewController. Cada estado del View Controller tiene una tarea especifica durante el proceso de transición. A continuación se describe brevemente la función de los principales estados:

**loadView**: Aquí es donde las subclases deben crear su jerarquía de vista personalizada si no están usando un nib. Nunca debe llamarse directamente.

**loadViewIfNeeded**: carga la vista de los View Controller's si aún no se ha configurado.

**viewDidLoad**: el evento viewDidLoad solo se llama cuando la vista se crea y se carga en la memoria, pero los Constraints de la vista aún no están definidos. Este es un buen lugar para inicializar los objetos que utilizará el controlador de vista.

**viewWillAppear**: se llama cuando la vista está a punto de hacerse visible. El valor predeterminado no hace nada. Este evento notifica al View Controller cada vez que la vista aparece en la pantalla. En este paso, la vista tiene Constraints definidos pero la orientación no está establecida.

**viewWillLayoutSubviews**: este es el primer paso en el ciclo de vida donde se finalizan los bounds. Si no está utilizando Constraints o auto-layout, probablemente pueda actualizar las subvistas aquí.

**viewDidLayoutSubviews**: este evento notifica al controlador de vista que se han configurado las subvistas. Es un buen lugar para realizar cambios en las subvistas después de que se hayan establecido.

viewDidAppear: el evento se activa después de que se presenta la vista en la pantalla. Lo que lo convierte en un buen lugar para obtener datos de un servicio de back-end o una base de datos.

**viewWillDisappear**: el evento se activa cuando la vista del viewController presentado está a punto de desaparecer, descartarse, cubrirse u ocultarse detrás de otro viewController. Este es un buen lugar donde puede restringir sus llamadas de red, invalidar el temporizador o liberar objetos que están vinculados a ese viewController. Por defecto no hace nada.

**viewDidDisappear**: este es el último paso del ciclo de vida, ya que este evento se activa justo después de que la vista del View Controller presentado haya desaparecido, descartado, cubierto u ocultado. Por defecto no hace nada.



### 7.- Explique el ciclo de vida de una aplicación.

El ciclo de vida de la aplicación constituye la secuencia de eventos que ocurre entre el lanzamiento y la finalización de la aplicación; ayudando a comprender el comportamiento general.

iOS administra los estados de la aplicación, pero la aplicación es responsable de manejar la experiencia del usuario a través de estas transiciones de estado.


Estados de ejecución para aplicaciones:

**Not Running state**: el sistema no ha iniciado ni finalizado la aplicación.

**Inactive state**: la aplicación está entrando en el estado de primer plano pero no recibe eventos.

**Active state**: la aplicación entra en el estado de primer plano y puede procesar el evento.

**Background state**: en este estado, si hay código ejecutable, se ejecutará y si no hay código ejecutable o la ejecución está completa, la aplicación se suspenderá inmediatamente.

**Suspended state**: la aplicación está en segundo plano (en la memoria), pero no está ejecutando el código y, si el sistema no tiene suficiente memoria, finalizará la aplicación.


Tan pronto como la aplicación haya iniciado el proceso de lanzamiento, la secuencia de métodos, según el estado en el que se encuentre la aplicación, es la siguiente:

**application:willFinishLaunchingWithOptions**:
Este método se llama después de que su aplicación se haya iniciado correctamente. Es el primer método de nuestro delegado de aplicación, al que se llamará. Puede ejecutar su código si el lanzamiento fue exitoso.


**application:didFinishLaunchingWithOptions**:
Este método se llama antes de que se muestre la ventana de la aplicación. Puede finalizar su interfaz y proporcionar el ViewController raíz a la ventana.


**applicationDidBecomeActive**:
Este método se llama para que su aplicación sepa que pasó del estado inactivo al estado activo o que el usuario o el sistema iniciaron su aplicación o en caso de que el usuario ignore una interrupción (como una llamada telefónica entrante o un mensaje SMS) que envió la aplicación temporalmente al estado inactivo. Debe usar este método para reiniciar cualquier tarea que se detuvo (o aún no se inició) mientras la aplicación estaba inactiva.


**applicationWillResignActive**:
Se llama a este método para que su aplicación sepa que está a punto de pasar del estado activo al estado inactivo. Esto puede suceder en caso de interrupciones (como una llamada telefónica entrante o un mensaje SMS o alertas de calendario) o cuando el usuario sale de la aplicación. Debe usar este método para pausar cualquier tarea en curso o deshabilitar temporizadores, etc.


**applicationDidEnterBackground**:
Se llama a este método para que la aplicación sepa que no se está ejecutando en primer plano. Tiene aproximadamente cinco segundos para realizar cualquier tarea y regresar. En caso de que necesite tiempo adicional, puede solicitar tiempo de ejecución adicional del sistema llamando a beginBackgroundTask(expirationHandler:). Si el método no regresa antes de que se agote el tiempo, su aplicación finaliza y se elimina de la memoria.


**applicationWillEnterForeground**:
Este método se llama como parte de la transición del fondo al estado activo. Debe usar esto para deshacer cualquier cambio que haya realizado en su aplicación al ingresar al fondo. El método applicationDidBecomeActive se llama poco después de que este método haya terminado su ejecución, lo que luego mueve la aplicación del estado inactivo al estado activo.

**applicationWillTerminate**:
Se llama a este método para informarle que su aplicación está a punto de finalizar. Debe usar este método para realizar cualquier tarea de limpieza final. Tiene aproximadamente cinco segundos para realizar cualquier tarea y regresar. Si el método no regresa antes de que expire el tiempo, el sistema puede eliminar el proceso por completo. Se puede llamar a este método en situaciones en las que la aplicación se ejecuta en segundo plano (no suspendida) y el sistema necesita finalizarla por algún motivo. No debe esperar a que se llame a applicationWillTerminate para guardar sus datos. Hay algunos casos en los que applicationWillTerminate no se llamará antes de la finalización de la aplicación. Por ejemplo, el sistema no llamará a applicationWillTerminate cuando el dispositivo se reinicie.



### 8.- En qué casos se usa un weak, un strong y un unowned.

Tanto weak como o unowned no crean una relación fuerte en el objeto referido. Por lo tanto, no aumentan el recuento de retención para evitar que ARC desasigne el objeto referido.

Weak es muy común emplearlo en tareas en segundo plano como peticiones que requieran acceso a internet.

Unowned es mas usado en tareas como los eventos tipo closures de un UIButton o un UIAlert

Strong puede ser empleado en fuertes dependencias entre structs.



### 9.- ¿Qué es el ARC?

Contador de Referencias Automático (Automatic Reference Counting)

El contador de referencias automático es una funcionalidad que permite liberar la memoria de aquellos elementos que no posean referencias fuertes hacia ellos (strong references).

Esto es, cada vez que creamos una nueva referencia a una clase, ARC reserva un espacio en memoria para poder guardar el tipo de instancia y los valores de cada una de las propiedades del objeto.

En el momento en que esa referencia es nil y no existe ninguna otra referencia hacia ese objeto, ARC libera la memoria que estaba siendo ocupaba para poder usar ese espacio para otros elementos.

Para estar seguros de que no se está liberando memoria que está siendo utilizada por alguna parte del código, ARC chequea que la cantidad de referencias strong hacia ese elemento sean 0.
