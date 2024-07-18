/*! WebUploader 0.1.5 */


/**
 * @fileOverview è®©å†…éƒ¨å„ä¸ªéƒ¨ä»¶çš„ä»£ç å¯ä»¥ç”¨[amd](https://github.com/amdjs/amdjs-api/wiki/AMD)æ¨¡å—å®šä¹‰æ–¹å¼ç»„ç»‡èµ·æ¥ã€‚
 *
 * AMD API å†…éƒ¨çš„ç®€å•ä¸å®Œå…¨å®žçŽ°ï¼Œè¯·å¿½ç•¥ã€‚åªæœ‰å½“WebUploaderè¢«åˆå¹¶æˆä¸€ä¸ªæ–‡ä»¶çš„æ—¶å€™æ‰ä¼šå¼•å…¥ã€‚
 */
(function( root, factory ) {
    var modules = {},

        // å†…éƒ¨require, ç®€å•ä¸å®Œå…¨å®žçŽ°ã€‚
        // https://github.com/amdjs/amdjs-api/wiki/require
        _require = function( deps, callback ) {
            var args, len, i;

            // å¦‚æžœdepsä¸æ˜¯æ•°ç»„ï¼Œåˆ™ç›´æŽ¥è¿”å›žæŒ‡å®šmodule
            if ( typeof deps === 'string' ) {
                return getModule( deps );
            } else {
                args = [];
                for( len = deps.length, i = 0; i < len; i++ ) {
                    args.push( getModule( deps[ i ] ) );
                }

                return callback.apply( null, args );
            }
        },

        // å†…éƒ¨defineï¼Œæš‚æ—¶ä¸æ”¯æŒä¸æŒ‡å®šid.
        _define = function( id, deps, factory ) {
            if ( arguments.length === 2 ) {
                factory = deps;
                deps = null;
            }

            _require( deps || [], function() {
                setModule( id, factory, arguments );
            });
        },

        // è®¾ç½®module, å…¼å®¹CommonJså†™æ³•ã€‚
        setModule = function( id, factory, args ) {
            var module = {
                    exports: factory
                },
                returned;

            if ( typeof factory === 'function' ) {
                args.length || (args = [ _require, module.exports, module ]);
                returned = factory.apply( null, args );
                returned !== undefined && (module.exports = returned);
            }

            modules[ id ] = module.exports;
        },

        // æ ¹æ®idèŽ·å–module
        getModule = function( id ) {
            var module = modules[ id ] || root[ id ];

            if ( !module ) {
                throw new Error( '`' + id + '` is undefined' );
            }

            return module;
        },

        // å°†æ‰€æœ‰modulesï¼Œå°†è·¯å¾„idsè£…æ¢æˆå¯¹è±¡ã€‚
        exportsTo = function( obj ) {
            var key, host, parts, part, last, ucFirst;

            // make the first character upper case.
            ucFirst = function( str ) {
                return str && (str.charAt( 0 ).toUpperCase() + str.substr( 1 ));
            };

            for ( key in modules ) {
                host = obj;

                if ( !modules.hasOwnProperty( key ) ) {
                    continue;
                }

                parts = key.split('/');
                last = ucFirst( parts.pop() );

                while( (part = ucFirst( parts.shift() )) ) {
                    host[ part ] = host[ part ] || {};
                    host = host[ part ];
                }

                host[ last ] = modules[ key ];
            }

            return obj;
        },

        makeExport = function( dollar ) {
            root.__dollar = dollar;

            // exports every module.
            return exportsTo( factory( root, _define, _require ) );
        },

        origin;

    if ( typeof module === 'object' && typeof module.exports === 'object' ) {

        // For CommonJS and CommonJS-like environments where a proper window is present,
        module.exports = makeExport();
    } else if ( typeof define === 'function' && define.amd ) {

        // Allow using this built library as an AMD module
        // in another project. That other project will only
        // see this AMD call, not the internal modules in
        // the closure below.
        define([ 'jquery' ], makeExport );
    } else {

        // Browser globals case. Just assign the
        // result to a property on the global.
        origin = root.WebUploader;
        root.WebUploader = makeExport();
        root.WebUploader.noConflict = function() {
            root.WebUploader = origin;
        };
    }
})( window, function( window, define, require ) {


    /**
     * @fileOverview jQuery or Zepto
     */
    define('dollar-third',[],function() {
        var $ = window.__dollar || window.jQuery || window.Zepto;
    
        if ( !$ ) {
            throw new Error('jQuery or Zepto not found!');
        }
    
        return $;
    });
    /**
     * @fileOverview Dom æ“ä½œç›¸å…³
     */
    define('dollar',[
        'dollar-third'
    ], function( _ ) {
        return _;
    });
    /**
     * ç›´æŽ¥æ¥æºäºŽjqueryçš„ä»£ç ã€‚
     * @fileOverview Promise/A+
     * @beta
     */
    define('promise-builtin',[
        'dollar'
    ], function( $ ) {
    
        var api;
    
        // ç®€å•ç‰ˆCallbacks, é»˜è®¤memoryï¼Œå¯é€‰once.
        function Callbacks( once ) {
            var list = [],
                stack = !once && [],
                fire = function( data ) {
                    memory = data;
                    fired = true;
                    firingIndex = firingStart || 0;
                    firingStart = 0;
                    firingLength = list.length;
                    firing = true;
    
                    for ( ; list && firingIndex < firingLength; firingIndex++ ) {
                        list[ firingIndex ].apply( data[ 0 ], data[ 1 ] );
                    }
                    firing = false;
    
                    if ( list ) {
                        if ( stack ) {
                            stack.length && fire( stack.shift() );
                        }  else {
                            list = [];
                        }
                    }
                },
                self = {
                    add: function() {
                        if ( list ) {
                            var start = list.length;
                            (function add ( args ) {
                                $.each( args, function( _, arg ) {
                                    var type = $.type( arg );
                                    if ( type === 'function' ) {
                                        list.push( arg );
                                    } else if ( arg && arg.length &&
                                            type !== 'string' ) {
    
                                        add( arg );
                                    }
                                });
                            })( arguments );
    
                            if ( firing ) {
                                firingLength = list.length;
                            } else if ( memory ) {
                                firingStart = start;
                                fire( memory );
                            }
                        }
                        return this;
                    },
    
                    disable: function() {
                        list = stack = memory = undefined;
                        return this;
                    },
    
                    // Lock the list in its current state
                    lock: function() {
                        stack = undefined;
                        if ( !memory ) {
                            self.disable();
                        }
                        return this;
                    },
    
                    fireWith: function( context, args ) {
                        if ( list && (!fired || stack) ) {
                            args = args || [];
                            args = [ context, args.slice ? args.slice() : args ];
                            if ( firing ) {
                                stack.push( args );
                            } else {
                                fire( args );
                            }
                        }
                        return this;
                    },
    
                    fire: function() {
                        self.fireWith( this, arguments );
                        return this;
                    }
                },
    
                fired, firing, firingStart, firingLength, firingIndex, memory;
    
            return self;
        }
    
        function Deferred( func ) {
            var tuples = [
                    // action, add listener, listener list, final state
                    [ 'resolve', 'done', Callbacks( true ), 'resolved' ],
                    [ 'reject', 'fail', Callbacks( true ), 'rejected' ],
                    [ 'notify', 'progress', Callbacks() ]
                ],
                state = 'pending',
                promise = {
                    state: function() {
                        return state;
                    },
                    always: function() {
                        deferred.done( arguments ).fail( arguments );
                        return this;
                    },
                    then: function( /* fnDone, fnFail, fnProgress */ ) {
                        var fns = arguments;
                        return Deferred(function( newDefer ) {
                            $.each( tuples, function( i, tuple ) {
                                var action = tuple[ 0 ],
                                    fn = $.isFunction( fns[ i ] ) && fns[ i ];
    
                                // deferred[ done | fail | progress ] for
                                // forwarding actions to newDefer
                                deferred[ tuple[ 1 ] ](function() {
                                    var returned;
    
                                    returned = fn && fn.apply( this, arguments );
    
                                    if ( returned &&
                                            $.isFunction( returned.promise ) ) {
    
                                        returned.promise()
                                                .done( newDefer.resolve )
                                                .fail( newDefer.reject )
                                                .progress( newDefer.notify );
                                    } else {
                                        newDefer[ action + 'With' ](
                                                this === promise ?
                                                newDefer.promise() :
                                                this,
                                                fn ? [ returned ] : arguments );
                                    }
                                });
                            });
                            fns = null;
                        }).promise();
                    },
    
                    // Get a promise for this deferred
                    // If obj is provided, the promise aspect is added to the object
                    promise: function( obj ) {
    
                        return obj != null ? $.extend( obj, promise ) : promise;
                    }
                },
                deferred = {};
    
            // Keep pipe for back-compat
            promise.pipe = promise.then;
    
            // Add list-specific methods
            $.each( tuples, function( i, tuple ) {
                var list = tuple[ 2 ],
                    stateString = tuple[ 3 ];
    
                // promise[ done | fail | progress ] = list.add
                promise[ tuple[ 1 ] ] = list.add;
    
                // Handle state
                if ( stateString ) {
                    list.add(function() {
                        // state = [ resolved | rejected ]
                        state = stateString;
    
                    // [ reject_list | resolve_list ].disable; progress_list.lock
                    }, tuples[ i ^ 1 ][ 2 ].disable, tuples[ 2 ][ 2 ].lock );
                }
    
                // deferred[ resolve | reject | notify ]
                deferred[ tuple[ 0 ] ] = function() {
                    deferred[ tuple[ 0 ] + 'With' ]( this === deferred ? promise :
                            this, arguments );
                    return this;
                };
                deferred[ tuple[ 0 ] + 'With' ] = list.fireWith;
            });
    
            // Make the deferred a promise
            promise.promise( deferred );
    
            // Call given func if any
            if ( func ) {
                func.call( deferred, deferred );
            }
    
            // All done!
            return deferred;
        }
    
        api = {
            /**
             * åˆ›å»ºä¸€ä¸ª[Deferred](http://api.jquery.com/category/deferred-object/)å¯¹è±¡ã€‚
             * è¯¦ç»†çš„Deferredç”¨æ³•è¯´æ˜Žï¼Œè¯·å‚ç…§jQueryçš„APIæ–‡æ¡£ã€‚
             *
             * Deferredå¯¹è±¡åœ¨é’©å­å›žæŽ‰å‡½æ•°ä¸­ç»å¸¸è¦ç”¨åˆ°ï¼Œç”¨æ¥å¤„ç†éœ€è¦ç­‰å¾…çš„å¼‚æ­¥æ“ä½œã€‚
             *
             * @for  Base
             * @method Deferred
             * @grammar Base.Deferred() => Deferred
             * @example
             * // åœ¨æ–‡ä»¶å¼€å§‹å‘é€å‰åšäº›å¼‚æ­¥æ“ä½œã€‚
             * // WebUploaderä¼šç­‰å¾…æ­¤å¼‚æ­¥æ“ä½œå®ŒæˆåŽï¼Œå¼€å§‹å‘é€æ–‡ä»¶ã€‚
             * Uploader.register({
             *     'before-send-file': 'doSomthingAsync'
             * }, {
             *
             *     doSomthingAsync: function() {
             *         var deferred = Base.Deferred();
             *
             *         // æ¨¡æ‹Ÿä¸€æ¬¡å¼‚æ­¥æ“ä½œã€‚
             *         setTimeout(deferred.resolve, 2000);
             *
             *         return deferred.promise();
             *     }
             * });
             */
            Deferred: Deferred,
    
            /**
             * åˆ¤æ–­ä¼ å…¥çš„å‚æ•°æ˜¯å¦ä¸ºä¸€ä¸ªpromiseå¯¹è±¡ã€‚
             * @method isPromise
             * @grammar Base.isPromise( anything ) => Boolean
             * @param  {*}  anything æ£€æµ‹å¯¹è±¡ã€‚
             * @return {Boolean}
             * @for  Base
             * @example
             * console.log( Base.isPromise() );    // => false
             * console.log( Base.isPromise({ key: '123' }) );    // => false
             * console.log( Base.isPromise( Base.Deferred().promise() ) );    // => true
             *
             * // Deferredä¹Ÿæ˜¯ä¸€ä¸ªPromise
             * console.log( Base.isPromise( Base.Deferred() ) );    // => true
             */
            isPromise: function( anything ) {
                return anything && typeof anything.then === 'function';
            },
    
            /**
             * è¿”å›žä¸€ä¸ªpromiseï¼Œæ­¤promiseåœ¨æ‰€æœ‰ä¼ å…¥çš„promiseéƒ½å®Œæˆäº†åŽå®Œæˆã€‚
             * è¯¦ç»†è¯·æŸ¥çœ‹[è¿™é‡Œ](http://api.jquery.com/jQuery.when/)ã€‚
             *
             * @method when
             * @for  Base
             * @grammar Base.when( promise1[, promise2[, promise3...]] ) => Promise
             */
            when: function( subordinate /* , ..., subordinateN */ ) {
                var i = 0,
                    slice = [].slice,
                    resolveValues = slice.call( arguments ),
                    length = resolveValues.length,
    
                    // the count of uncompleted subordinates
                    remaining = length !== 1 || (subordinate &&
                        $.isFunction( subordinate.promise )) ? length : 0,
    
                    // the master Deferred. If resolveValues consist of
                    // only a single Deferred, just use that.
                    deferred = remaining === 1 ? subordinate : Deferred(),
    
                    // Update function for both resolve and progress values
                    updateFunc = function( i, contexts, values ) {
                        return function( value ) {
                            contexts[ i ] = this;
                            values[ i ] = arguments.length > 1 ?
                                    slice.call( arguments ) : value;
    
                            if ( values === progressValues ) {
                                deferred.notifyWith( contexts, values );
                            } else if ( !(--remaining) ) {
                                deferred.resolveWith( contexts, values );
                            }
                        };
                    },
    
                    progressValues, progressContexts, resolveContexts;
    
                // add listeners to Deferred subordinates; treat others as resolved
                if ( length > 1 ) {
                    progressValues = new Array( length );
                    progressContexts = new Array( length );
                    resolveContexts = new Array( length );
                    for ( ; i < length; i++ ) {
                        if ( resolveValues[ i ] &&
                                $.isFunction( resolveValues[ i ].promise ) ) {
    
                            resolveValues[ i ].promise()
                                    .done( updateFunc( i, resolveContexts,
                                            resolveValues ) )
                                    .fail( deferred.reject )
                                    .progress( updateFunc( i, progressContexts,
                                            progressValues ) );
                        } else {
                            --remaining;
                        }
                    }
                }
    
                // if we're not waiting on anything, resolve the master
                if ( !remaining ) {
                    deferred.resolveWith( resolveContexts, resolveValues );
                }
    
                return deferred.promise();
            }
        };
    
        return api;
    });
    define('promise',[
        'promise-builtin'
    ], function( $ ) {
        return $;
    });
    /**
     * @fileOverview åŸºç¡€ç±»æ–¹æ³•ã€‚
     */
    
    /**
     * Web Uploaderå†…éƒ¨ç±»çš„è¯¦ç»†è¯´æ˜Žï¼Œä»¥ä¸‹æåŠçš„åŠŸèƒ½ç±»ï¼Œéƒ½å¯ä»¥åœ¨`WebUploader`è¿™ä¸ªå˜é‡ä¸­è®¿é—®åˆ°ã€‚
     *
     * As you know, Web Uploaderçš„æ¯ä¸ªæ–‡ä»¶éƒ½æ˜¯ç”¨è¿‡[AMD](https://github.com/amdjs/amdjs-api/wiki/AMD)è§„èŒƒä¸­çš„`define`ç»„ç»‡èµ·æ¥çš„, æ¯ä¸ªModuleéƒ½ä¼šæœ‰ä¸ªmodule id.
     * é»˜è®¤module idä¸ºè¯¥æ–‡ä»¶çš„è·¯å¾„ï¼Œè€Œæ­¤è·¯å¾„å°†ä¼šè½¬åŒ–æˆåå­—ç©ºé—´å­˜æ”¾åœ¨WebUploaderä¸­ã€‚å¦‚ï¼š
     *
     * * module `base`ï¼šWebUploader.Base
     * * module `file`: WebUploader.File
     * * module `lib/dnd`: WebUploader.Lib.Dnd
     * * module `runtime/html5/dnd`: WebUploader.Runtime.Html5.Dnd
     *
     *
     * ä»¥ä¸‹æ–‡æ¡£ä¸­å¯¹ç±»çš„ä½¿ç”¨å¯èƒ½çœç•¥æŽ‰äº†`WebUploader`å‰ç¼€ã€‚
     * @module WebUploader
     * @title WebUploader APIæ–‡æ¡£
     */
    define('base',[
        'dollar',
        'promise'
    ], function( $, promise ) {
    
        var noop = function() {},
            call = Function.call;
    
        // http://jsperf.com/uncurrythis
        // åç§‘é‡ŒåŒ–
        function uncurryThis( fn ) {
            return function() {
                return call.apply( fn, arguments );
            };
        }
    
        function bindFn( fn, context ) {
            return function() {
                return fn.apply( context, arguments );
            };
        }
    
        function createObject( proto ) {
            var f;
    
            if ( Object.create ) {
                return Object.create( proto );
            } else {
                f = function() {};
                f.prototype = proto;
                return new f();
            }
        }
    
    
        /**
         * åŸºç¡€ç±»ï¼Œæä¾›ä¸€äº›ç®€å•å¸¸ç”¨çš„æ–¹æ³•ã€‚
         * @class Base
         */
        return {
    
            /**
             * @property {String} version å½“å‰ç‰ˆæœ¬å·ã€‚
             */
            version: '0.1.5',
    
            /**
             * @property {jQuery|Zepto} $ å¼•ç”¨ä¾èµ–çš„jQueryæˆ–è€…Zeptoå¯¹è±¡ã€‚
             */
            $: $,
    
            Deferred: promise.Deferred,
    
            isPromise: promise.isPromise,
    
            when: promise.when,
    
            /**
             * @description  ç®€å•çš„æµè§ˆå™¨æ£€æŸ¥ç»“æžœã€‚
             *
             * * `webkit`  webkitç‰ˆæœ¬å·ï¼Œå¦‚æžœæµè§ˆå™¨ä¸ºéžwebkitå†…æ ¸ï¼Œæ­¤å±žæ€§ä¸º`undefined`ã€‚
             * * `chrome`  chromeæµè§ˆå™¨ç‰ˆæœ¬å·ï¼Œå¦‚æžœæµè§ˆå™¨ä¸ºchromeï¼Œæ­¤å±žæ€§ä¸º`undefined`ã€‚
             * * `ie`  ieæµè§ˆå™¨ç‰ˆæœ¬å·ï¼Œå¦‚æžœæµè§ˆå™¨ä¸ºéžieï¼Œæ­¤å±žæ€§ä¸º`undefined`ã€‚**æš‚ä¸æ”¯æŒie10+**
             * * `firefox`  firefoxæµè§ˆå™¨ç‰ˆæœ¬å·ï¼Œå¦‚æžœæµè§ˆå™¨ä¸ºéžfirefoxï¼Œæ­¤å±žæ€§ä¸º`undefined`ã€‚
             * * `safari`  safariæµè§ˆå™¨ç‰ˆæœ¬å·ï¼Œå¦‚æžœæµè§ˆå™¨ä¸ºéžsafariï¼Œæ­¤å±žæ€§ä¸º`undefined`ã€‚
             * * `opera`  operaæµè§ˆå™¨ç‰ˆæœ¬å·ï¼Œå¦‚æžœæµè§ˆå™¨ä¸ºéžoperaï¼Œæ­¤å±žæ€§ä¸º`undefined`ã€‚
             *
             * @property {Object} [browser]
             */
            browser: (function( ua ) {
                var ret = {},
                    webkit = ua.match( /WebKit\/([\d.]+)/ ),
                    chrome = ua.match( /Chrome\/([\d.]+)/ ) ||
                        ua.match( /CriOS\/([\d.]+)/ ),
    
                    ie = ua.match( /MSIE\s([\d\.]+)/ ) ||
                        ua.match( /(?:trident)(?:.*rv:([\w.]+))?/i ),
                    firefox = ua.match( /Firefox\/([\d.]+)/ ),
                    safari = ua.match( /Safari\/([\d.]+)/ ),
                    opera = ua.match( /OPR\/([\d.]+)/ );
    
                webkit && (ret.webkit = parseFloat( webkit[ 1 ] ));
                chrome && (ret.chrome = parseFloat( chrome[ 1 ] ));
                ie && (ret.ie = parseFloat( ie[ 1 ] ));
                firefox && (ret.firefox = parseFloat( firefox[ 1 ] ));
                safari && (ret.safari = parseFloat( safari[ 1 ] ));
                opera && (ret.opera = parseFloat( opera[ 1 ] ));
    
                return ret;
            })( navigator.userAgent ),
    
            /**
             * @description  æ“ä½œç³»ç»Ÿæ£€æŸ¥ç»“æžœã€‚
             *
             * * `android`  å¦‚æžœåœ¨androidæµè§ˆå™¨çŽ¯å¢ƒä¸‹ï¼Œæ­¤å€¼ä¸ºå¯¹åº”çš„androidç‰ˆæœ¬å·ï¼Œå¦åˆ™ä¸º`undefined`ã€‚
             * * `ios` å¦‚æžœåœ¨iosæµè§ˆå™¨çŽ¯å¢ƒä¸‹ï¼Œæ­¤å€¼ä¸ºå¯¹åº”çš„iosç‰ˆæœ¬å·ï¼Œå¦åˆ™ä¸º`undefined`ã€‚
             * @property {Object} [os]
             */
            os: (function( ua ) {
                var ret = {},
    
                    // osx = !!ua.match( /\(Macintosh\; Intel / ),
                    android = ua.match( /(?:Android);?[\s\/]+([\d.]+)?/ ),
                    ios = ua.match( /(?:iPad|iPod|iPhone).*OS\s([\d_]+)/ );
    
                // osx && (ret.osx = true);
                android && (ret.android = parseFloat( android[ 1 ] ));
                ios && (ret.ios = parseFloat( ios[ 1 ].replace( /_/g, '.' ) ));
    
                return ret;
            })( navigator.userAgent ),
    
            /**
             * å®žçŽ°ç±»ä¸Žç±»ä¹‹é—´çš„ç»§æ‰¿ã€‚
             * @method inherits
             * @grammar Base.inherits( super ) => child
             * @grammar Base.inherits( super, protos ) => child
             * @grammar Base.inherits( super, protos, statics ) => child
             * @param  {Class} super çˆ¶ç±»
             * @param  {Object | Function} [protos] å­ç±»æˆ–è€…å¯¹è±¡ã€‚å¦‚æžœå¯¹è±¡ä¸­åŒ…å«constructorï¼Œå­ç±»å°†æ˜¯ç”¨æ­¤å±žæ€§å€¼ã€‚
             * @param  {Function} [protos.constructor] å­ç±»æž„é€ å™¨ï¼Œä¸æŒ‡å®šçš„è¯å°†åˆ›å»ºä¸ªä¸´æ—¶çš„ç›´æŽ¥æ‰§è¡Œçˆ¶ç±»æž„é€ å™¨çš„æ–¹æ³•ã€‚
             * @param  {Object} [statics] é™æ€å±žæ€§æˆ–æ–¹æ³•ã€‚
             * @return {Class} è¿”å›žå­ç±»ã€‚
             * @example
             * function Person() {
             *     console.log( 'Super' );
             * }
             * Person.prototype.hello = function() {
             *     console.log( 'hello' );
             * };
             *
             * var Manager = Base.inherits( Person, {
             *     world: function() {
             *         console.log( 'World' );
             *     }
             * });
             *
             * // å› ä¸ºæ²¡æœ‰æŒ‡å®šæž„é€ å™¨ï¼Œçˆ¶ç±»çš„æž„é€ å™¨å°†ä¼šæ‰§è¡Œã€‚
             * var instance = new Manager();    // => Super
             *
             * // ç»§æ‰¿å­çˆ¶ç±»çš„æ–¹æ³•
             * instance.hello();    // => hello
             * instance.world();    // => World
             *
             * // å­ç±»çš„__super__å±žæ€§æŒ‡å‘çˆ¶ç±»
             * console.log( Manager.__super__ === Person );    // => true
             */
            inherits: function( Super, protos, staticProtos ) {
                var child;
    
                if ( typeof protos === 'function' ) {
                    child = protos;
                    protos = null;
                } else if ( protos && protos.hasOwnProperty('constructor') ) {
                    child = protos.constructor;
                } else {
                    child = function() {
                        return Super.apply( this, arguments );
                    };
                }
    
                // å¤åˆ¶é™æ€æ–¹æ³•
                $.extend( true, child, Super, staticProtos || {} );
    
                /* jshint camelcase: false */
    
                // è®©å­ç±»çš„__super__å±žæ€§æŒ‡å‘çˆ¶ç±»ã€‚
                child.__super__ = Super.prototype;
    
                // æž„å»ºåŽŸåž‹ï¼Œæ·»åŠ åŽŸåž‹æ–¹æ³•æˆ–å±žæ€§ã€‚
                // æš‚æ—¶ç”¨Object.createå®žçŽ°ã€‚
                child.prototype = createObject( Super.prototype );
                protos && $.extend( true, child.prototype, protos );
    
                return child;
            },
    
            /**
             * ä¸€ä¸ªä¸åšä»»ä½•äº‹æƒ…çš„æ–¹æ³•ã€‚å¯ä»¥ç”¨æ¥èµ‹å€¼ç»™é»˜è®¤çš„callback.
             * @method noop
             */
            noop: noop,
    
            /**
             * è¿”å›žä¸€ä¸ªæ–°çš„æ–¹æ³•ï¼Œæ­¤æ–¹æ³•å°†å·²æŒ‡å®šçš„`context`æ¥æ‰§è¡Œã€‚
             * @grammar Base.bindFn( fn, context ) => Function
             * @method bindFn
             * @example
             * var doSomething = function() {
             *         console.log( this.name );
             *     },
             *     obj = {
             *         name: 'Object Name'
             *     },
             *     aliasFn = Base.bind( doSomething, obj );
             *
             *  aliasFn();    // => Object Name
             *
             */
            bindFn: bindFn,
    
            /**
             * å¼•ç”¨Console.logå¦‚æžœå­˜åœ¨çš„è¯ï¼Œå¦åˆ™å¼•ç”¨ä¸€ä¸ª[ç©ºå‡½æ•°noop](#WebUploader:Base.noop)ã€‚
             * @grammar Base.log( args... ) => undefined
             * @method log
             */
            log: (function() {
                if ( window.console ) {
                    return bindFn( console.log, console );
                }
                return noop;
            })(),
    
            nextTick: (function() {
    
                return function( cb ) {
                    setTimeout( cb, 1 );
                };
    
                // @bug å½“æµè§ˆå™¨ä¸åœ¨å½“å‰çª—å£æ—¶å°±åœäº†ã€‚
                // var next = window.requestAnimationFrame ||
                //     window.webkitRequestAnimationFrame ||
                //     window.mozRequestAnimationFrame ||
                //     function( cb ) {
                //         window.setTimeout( cb, 1000 / 60 );
                //     };
    
                // // fix: Uncaught TypeError: Illegal invocation
                // return bindFn( next, window );
            })(),
    
            /**
             * è¢«[uncurrythis](http://www.2ality.com/2011/11/uncurrying-this.html)çš„æ•°ç»„sliceæ–¹æ³•ã€‚
             * å°†ç”¨æ¥å°†éžæ•°ç»„å¯¹è±¡è½¬åŒ–æˆæ•°ç»„å¯¹è±¡ã€‚
             * @grammar Base.slice( target, start[, end] ) => Array
             * @method slice
             * @example
             * function doSomthing() {
             *     var args = Base.slice( arguments, 1 );
             *     console.log( args );
             * }
             *
             * doSomthing( 'ignored', 'arg2', 'arg3' );    // => Array ["arg2", "arg3"]
             */
            slice: uncurryThis( [].slice ),
    
            /**
             * ç”Ÿæˆå”¯ä¸€çš„ID
             * @method guid
             * @grammar Base.guid() => String
             * @grammar Base.guid( prefx ) => String
             */
            guid: (function() {
                var counter = 0;
    
                return function( prefix ) {
                    var guid = (+new Date()).toString( 32 ),
                        i = 0;
    
                    for ( ; i < 5; i++ ) {
                        guid += Math.floor( Math.random() * 65535 ).toString( 32 );
                    }
    
                    return (prefix || 'wu_') + guid + (counter++).toString( 32 );
                };
            })(),
    
            /**
             * æ ¼å¼åŒ–æ–‡ä»¶å¤§å°, è¾“å‡ºæˆå¸¦å•ä½çš„å­—ç¬¦ä¸²
             * @method formatSize
             * @grammar Base.formatSize( size ) => String
             * @grammar Base.formatSize( size, pointLength ) => String
             * @grammar Base.formatSize( size, pointLength, units ) => String
             * @param {Number} size æ–‡ä»¶å¤§å°
             * @param {Number} [pointLength=2] ç²¾ç¡®åˆ°çš„å°æ•°ç‚¹æ•°ã€‚
             * @param {Array} [units=[ 'B', 'K', 'M', 'G', 'TB' ]] å•ä½æ•°ç»„ã€‚ä»Žå­—èŠ‚ï¼Œåˆ°åƒå­—èŠ‚ï¼Œä¸€ç›´å¾€ä¸ŠæŒ‡å®šã€‚å¦‚æžœå•ä½æ•°ç»„é‡Œé¢åªæŒ‡å®šäº†åˆ°äº†K(åƒå­—èŠ‚)ï¼ŒåŒæ—¶æ–‡ä»¶å¤§å°å¤§äºŽM, æ­¤æ–¹æ³•çš„è¾“å‡ºå°†è¿˜æ˜¯æ˜¾ç¤ºæˆå¤šå°‘K.
             * @example
             * console.log( Base.formatSize( 100 ) );    // => 100B
             * console.log( Base.formatSize( 1024 ) );    // => 1.00K
             * console.log( Base.formatSize( 1024, 0 ) );    // => 1K
             * console.log( Base.formatSize( 1024 * 1024 ) );    // => 1.00M
             * console.log( Base.formatSize( 1024 * 1024 * 1024 ) );    // => 1.00G
             * console.log( Base.formatSize( 1024 * 1024 * 1024, 0, ['B', 'KB', 'MB'] ) );    // => 1024MB
             */
            formatSize: function( size, pointLength, units ) {
                var unit;
    
                units = units || [ 'B', 'K', 'M', 'G', 'TB' ];
    
                while ( (unit = units.shift()) && size > 1024 ) {
                    size = size / 1024;
                }
    
                return (unit === 'B' ? size : size.toFixed( pointLength || 2 )) +
                        unit;
            }
        };
    });
    /**
     * äº‹ä»¶å¤„ç†ç±»ï¼Œå¯ä»¥ç‹¬ç«‹ä½¿ç”¨ï¼Œä¹Ÿå¯ä»¥æ‰©å±•ç»™å¯¹è±¡ä½¿ç”¨ã€‚
     * @fileOverview Mediator
     */
    define('mediator',[
        'base'
    ], function( Base ) {
        var $ = Base.$,
            slice = [].slice,
            separator = /\s+/,
            protos;
    
        // æ ¹æ®æ¡ä»¶è¿‡æ»¤å‡ºäº‹ä»¶handlers.
        function findHandlers( arr, name, callback, context ) {
            return $.grep( arr, function( handler ) {
                return handler &&
                        (!name || handler.e === name) &&
                        (!callback || handler.cb === callback ||
                        handler.cb._cb === callback) &&
                        (!context || handler.ctx === context);
            });
        }
    
        function eachEvent( events, callback, iterator ) {
            // ä¸æ”¯æŒå¯¹è±¡ï¼Œåªæ”¯æŒå¤šä¸ªeventç”¨ç©ºæ ¼éš”å¼€
            $.each( (events || '').split( separator ), function( _, key ) {
                iterator( key, callback );
            });
        }
    
        function triggerHanders( events, args ) {
            var stoped = false,
                i = -1,
                len = events.length,
                handler;
    
            while ( ++i < len ) {
                handler = events[ i ];
    
                if ( handler.cb.apply( handler.ctx2, args ) === false ) {
                    stoped = true;
                    break;
                }
            }
    
            return !stoped;
        }
    
        protos = {
    
            /**
             * ç»‘å®šäº‹ä»¶ã€‚
             *
             * `callback`æ–¹æ³•åœ¨æ‰§è¡Œæ—¶ï¼Œargumentså°†ä¼šæ¥æºäºŽtriggerçš„æ—¶å€™æºå¸¦çš„å‚æ•°ã€‚å¦‚
             * ```javascript
             * var obj = {};
             *
             * // ä½¿å¾—objæœ‰äº‹ä»¶è¡Œä¸º
             * Mediator.installTo( obj );
             *
             * obj.on( 'testa', function( arg1, arg2 ) {
             *     console.log( arg1, arg2 ); // => 'arg1', 'arg2'
             * });
             *
             * obj.trigger( 'testa', 'arg1', 'arg2' );
             * ```
             *
             * å¦‚æžœ`callback`ä¸­ï¼ŒæŸä¸€ä¸ªæ–¹æ³•`return false`äº†ï¼Œåˆ™åŽç»­çš„å…¶ä»–`callback`éƒ½ä¸ä¼šè¢«æ‰§è¡Œåˆ°ã€‚
             * åˆ‡ä¼šå½±å“åˆ°`trigger`æ–¹æ³•çš„è¿”å›žå€¼ï¼Œä¸º`false`ã€‚
             *
             * `on`è¿˜å¯ä»¥ç”¨æ¥æ·»åŠ ä¸€ä¸ªç‰¹æ®Šäº‹ä»¶`all`, è¿™æ ·æ‰€æœ‰çš„äº‹ä»¶è§¦å‘éƒ½ä¼šå“åº”åˆ°ã€‚åŒæ—¶æ­¤ç±»`callback`ä¸­çš„argumentsæœ‰ä¸€ä¸ªä¸åŒå¤„ï¼Œ
             * å°±æ˜¯ç¬¬ä¸€ä¸ªå‚æ•°ä¸º`type`ï¼Œè®°å½•å½“å‰æ˜¯ä»€ä¹ˆäº‹ä»¶åœ¨è§¦å‘ã€‚æ­¤ç±»`callback`çš„ä¼˜å…ˆçº§æ¯”è„šä½Žï¼Œä¼šå†æ­£å¸¸`callback`æ‰§è¡Œå®ŒåŽè§¦å‘ã€‚
             * ```javascript
             * obj.on( 'all', function( type, arg1, arg2 ) {
             *     console.log( type, arg1, arg2 ); // => 'testa', 'arg1', 'arg2'
             * });
             * ```
             *
             * @method on
             * @grammar on( name, callback[, context] ) => self
             * @param  {String}   name     äº‹ä»¶åï¼Œæ”¯æŒå¤šä¸ªäº‹ä»¶ç”¨ç©ºæ ¼éš”å¼€
             * @param  {Function} callback äº‹ä»¶å¤„ç†å™¨
             * @param  {Object}   [context]  äº‹ä»¶å¤„ç†å™¨çš„ä¸Šä¸‹æ–‡ã€‚
             * @return {self} è¿”å›žè‡ªèº«ï¼Œæ–¹ä¾¿é“¾å¼
             * @chainable
             * @class Mediator
             */
            on: function( name, callback, context ) {
                var me = this,
                    set;
    
                if ( !callback ) {
                    return this;
                }
    
                set = this._events || (this._events = []);
    
                eachEvent( name, callback, function( name, callback ) {
                    var handler = { e: name };
    
                    handler.cb = callback;
                    handler.ctx = context;
                    handler.ctx2 = context || me;
                    handler.id = set.length;
    
                    set.push( handler );
                });
    
                return this;
            },
    
            /**
             * ç»‘å®šäº‹ä»¶ï¼Œä¸”å½“handleræ‰§è¡Œå®ŒåŽï¼Œè‡ªåŠ¨è§£é™¤ç»‘å®šã€‚
             * @method once
             * @grammar once( name, callback[, context] ) => self
             * @param  {String}   name     äº‹ä»¶å
             * @param  {Function} callback äº‹ä»¶å¤„ç†å™¨
             * @param  {Object}   [context]  äº‹ä»¶å¤„ç†å™¨çš„ä¸Šä¸‹æ–‡ã€‚
             * @return {self} è¿”å›žè‡ªèº«ï¼Œæ–¹ä¾¿é“¾å¼
             * @chainable
             */
            once: function( name, callback, context ) {
                var me = this;
    
                if ( !callback ) {
                    return me;
                }
    
                eachEvent( name, callback, function( name, callback ) {
                    var once = function() {
                            me.off( name, once );
                            return callback.apply( context || me, arguments );
                        };
    
                    once._cb = callback;
                    me.on( name, once, context );
                });
    
                return me;
            },
    
            /**
             * è§£é™¤äº‹ä»¶ç»‘å®š
             * @method off
             * @grammar off( [name[, callback[, context] ] ] ) => self
             * @param  {String}   [name]     äº‹ä»¶å
             * @param  {Function} [callback] äº‹ä»¶å¤„ç†å™¨
             * @param  {Object}   [context]  äº‹ä»¶å¤„ç†å™¨çš„ä¸Šä¸‹æ–‡ã€‚
             * @return {self} è¿”å›žè‡ªèº«ï¼Œæ–¹ä¾¿é“¾å¼
             * @chainable
             */
            off: function( name, cb, ctx ) {
                var events = this._events;
    
                if ( !events ) {
                    return this;
                }
    
                if ( !name && !cb && !ctx ) {
                    this._events = [];
                    return this;
                }
    
                eachEvent( name, cb, function( name, cb ) {
                    $.each( findHandlers( events, name, cb, ctx ), function() {
                        delete events[ this.id ];
                    });
                });
    
                return this;
            },
    
            /**
             * è§¦å‘äº‹ä»¶
             * @method trigger
             * @grammar trigger( name[, args...] ) => self
             * @param  {String}   type     äº‹ä»¶å
             * @param  {*} [...] ä»»æ„å‚æ•°
             * @return {Boolean} å¦‚æžœhandlerä¸­return falseäº†ï¼Œåˆ™è¿”å›žfalse, å¦åˆ™è¿”å›žtrue
             */
            trigger: function( type ) {
                var args, events, allEvents;
    
                if ( !this._events || !type ) {
                    return this;
                }
    
                args = slice.call( arguments, 1 );
                events = findHandlers( this._events, type );
                allEvents = findHandlers( this._events, 'all' );
    
                return triggerHanders( events, args ) &&
                        triggerHanders( allEvents, arguments );
            }
        };
    
        /**
         * ä¸­ä»‹è€…ï¼Œå®ƒæœ¬èº«æ˜¯ä¸ªå•ä¾‹ï¼Œä½†å¯ä»¥é€šè¿‡[installTo](#WebUploader:Mediator:installTo)æ–¹æ³•ï¼Œä½¿ä»»ä½•å¯¹è±¡å…·å¤‡äº‹ä»¶è¡Œä¸ºã€‚
         * ä¸»è¦ç›®çš„æ˜¯è´Ÿè´£æ¨¡å—ä¸Žæ¨¡å—ä¹‹é—´çš„åˆä½œï¼Œé™ä½Žè€¦åˆåº¦ã€‚
         *
         * @class Mediator
         */
        return $.extend({
    
            /**
             * å¯ä»¥é€šè¿‡è¿™ä¸ªæŽ¥å£ï¼Œä½¿ä»»ä½•å¯¹è±¡å…·å¤‡äº‹ä»¶åŠŸèƒ½ã€‚
             * @method installTo
             * @param  {Object} obj éœ€è¦å…·å¤‡äº‹ä»¶è¡Œä¸ºçš„å¯¹è±¡ã€‚
             * @return {Object} è¿”å›žobj.
             */
            installTo: function( obj ) {
                return $.extend( obj, protos );
            }
    
        }, protos );
    });
    /**
     * @fileOverview Uploaderä¸Šä¼ ç±»
     */
    define('uploader',[
        'base',
        'mediator'
    ], function( Base, Mediator ) {
    
        var $ = Base.$;
    
        /**
         * ä¸Šä¼ å…¥å£ç±»ã€‚
         * @class Uploader
         * @constructor
         * @grammar new Uploader( opts ) => Uploader
         * @example
         * var uploader = WebUploader.Uploader({
         *     swf: 'path_of_swf/Uploader.swf',
         *
         *     // å¼€èµ·åˆ†ç‰‡ä¸Šä¼ ã€‚
         *     chunked: true
         * });
         */
        function Uploader( opts ) {
            this.options = $.extend( true, {}, Uploader.options, opts );
            this._init( this.options );
        }
    
        // default Options
        // widgetsä¸­æœ‰ç›¸åº”æ‰©å±•
        Uploader.options = {};
        Mediator.installTo( Uploader.prototype );
    
        // æ‰¹é‡æ·»åŠ çº¯å‘½ä»¤å¼æ–¹æ³•ã€‚
        $.each({
            upload: 'start-upload',
            stop: 'stop-upload',
            getFile: 'get-file',
            getFiles: 'get-files',
            addFile: 'add-file',
            addFiles: 'add-file',
            sort: 'sort-files',
            removeFile: 'remove-file',
            cancelFile: 'cancel-file',
            skipFile: 'skip-file',
            retry: 'retry',
            isInProgress: 'is-in-progress',
            makeThumb: 'make-thumb',
            md5File: 'md5-file',
            getDimension: 'get-dimension',
            addButton: 'add-btn',
            predictRuntimeType: 'predict-runtime-type',
            refresh: 'refresh',
            disable: 'disable',
            enable: 'enable',
            reset: 'reset'
        }, function( fn, command ) {
            Uploader.prototype[ fn ] = function() {
                return this.request( command, arguments );
            };
        });
    
        $.extend( Uploader.prototype, {
            state: 'pending',
    
            _init: function( opts ) {
                var me = this;
    
                me.request( 'init', opts, function() {
                    me.state = 'ready';
                    me.trigger('ready');
                });
            },
    
            /**
             * èŽ·å–æˆ–è€…è®¾ç½®Uploaderé…ç½®é¡¹ã€‚
             * @method option
             * @grammar option( key ) => *
             * @grammar option( key, val ) => self
             * @example
             *
             * // åˆå§‹çŠ¶æ€å›¾ç‰‡ä¸Šä¼ å‰ä¸ä¼šåŽ‹ç¼©
             * var uploader = new WebUploader.Uploader({
             *     compress: null;
             * });
             *
             * // ä¿®æ”¹åŽå›¾ç‰‡ä¸Šä¼ å‰ï¼Œå°è¯•å°†å›¾ç‰‡åŽ‹ç¼©åˆ°1600 * 1600
             * uploader.option( 'compress', {
             *     width: 1600,
             *     height: 1600
             * });
             */
            option: function( key, val ) {
                var opts = this.options;
    
                // setter
                if ( arguments.length > 1 ) {
    
                    if ( $.isPlainObject( val ) &&
                            $.isPlainObject( opts[ key ] ) ) {
                        $.extend( opts[ key ], val );
                    } else {
                        opts[ key ] = val;
                    }
    
                } else {    // getter
                    return key ? opts[ key ] : opts;
                }
            },
    
            /**
             * èŽ·å–æ–‡ä»¶ç»Ÿè®¡ä¿¡æ¯ã€‚è¿”å›žä¸€ä¸ªåŒ…å«ä¸€ä¸‹ä¿¡æ¯çš„å¯¹è±¡ã€‚
             * * `successNum` ä¸Šä¼ æˆåŠŸçš„æ–‡ä»¶æ•°
             * * `progressNum` ä¸Šä¼ ä¸­çš„æ–‡ä»¶æ•°
             * * `cancelNum` è¢«åˆ é™¤çš„æ–‡ä»¶æ•°
             * * `invalidNum` æ— æ•ˆçš„æ–‡ä»¶æ•°
             * * `uploadFailNum` ä¸Šä¼ å¤±è´¥çš„æ–‡ä»¶æ•°
             * * `queueNum` è¿˜åœ¨é˜Ÿåˆ—ä¸­çš„æ–‡ä»¶æ•°
             * * `interruptNum` è¢«æš‚åœçš„æ–‡ä»¶æ•°
             * @method getStats
             * @grammar getStats() => Object
             */
            getStats: function() {
                // return this._mgr.getStats.apply( this._mgr, arguments );
                var stats = this.request('get-stats');
    
                return stats ? {
                    successNum: stats.numOfSuccess,
                    progressNum: stats.numOfProgress,
    
                    // who care?
                    // queueFailNum: 0,
                    cancelNum: stats.numOfCancel,
                    invalidNum: stats.numOfInvalid,
                    uploadFailNum: stats.numOfUploadFailed,
                    queueNum: stats.numOfQueue,
                    interruptNum: stats.numofInterrupt
                } : {};
            },
    
            // éœ€è¦é‡å†™æ­¤æ–¹æ³•æ¥æ¥æ”¯æŒopts.onEventå’Œinstance.onEventçš„å¤„ç†å™¨
            trigger: function( type/*, args...*/ ) {
                var args = [].slice.call( arguments, 1 ),
                    opts = this.options,
                    name = 'on' + type.substring( 0, 1 ).toUpperCase() +
                        type.substring( 1 );
    
                if (
                        // è°ƒç”¨é€šè¿‡onæ–¹æ³•æ³¨å†Œçš„handler.
                        Mediator.trigger.apply( this, arguments ) === false ||
    
                        // è°ƒç”¨opts.onEvent
                        $.isFunction( opts[ name ] ) &&
                        opts[ name ].apply( this, args ) === false ||
    
                        // è°ƒç”¨this.onEvent
                        $.isFunction( this[ name ] ) &&
                        this[ name ].apply( this, args ) === false ||
    
                        // å¹¿æ’­æ‰€æœ‰uploaderçš„äº‹ä»¶ã€‚
                        Mediator.trigger.apply( Mediator,
                        [ this, type ].concat( args ) ) === false ) {
    
                    return false;
                }
    
                return true;
            },
    
            /**
             * é”€æ¯ webuploader å®žä¾‹
             * @method destroy
             * @grammar destroy() => undefined
             */
            destroy: function() {
                this.request( 'destroy', arguments );
                this.off();
            },
    
            // widgets/widget.jså°†è¡¥å……æ­¤æ–¹æ³•çš„è¯¦ç»†æ–‡æ¡£ã€‚
            request: Base.noop
        });
    
        /**
         * åˆ›å»ºUploaderå®žä¾‹ï¼Œç­‰åŒäºŽnew Uploader( opts );
         * @method create
         * @class Base
         * @static
         * @grammar Base.create( opts ) => Uploader
         */
        Base.create = Uploader.create = function( opts ) {
            return new Uploader( opts );
        };
    
        // æš´éœ²Uploaderï¼Œå¯ä»¥é€šè¿‡å®ƒæ¥æ‰©å±•ä¸šåŠ¡é€»è¾‘ã€‚
        Base.Uploader = Uploader;
    
        return Uploader;
    });
    /**
     * @fileOverview Runtimeç®¡ç†å™¨ï¼Œè´Ÿè´£Runtimeçš„é€‰æ‹©, è¿žæŽ¥
     */
    define('runtime/runtime',[
        'base',
        'mediator'
    ], function( Base, Mediator ) {
    
        var $ = Base.$,
            factories = {},
    
            // èŽ·å–å¯¹è±¡çš„ç¬¬ä¸€ä¸ªkey
            getFirstKey = function( obj ) {
                for ( var key in obj ) {
                    if ( obj.hasOwnProperty( key ) ) {
                        return key;
                    }
                }
                return null;
            };
    
        // æŽ¥å£ç±»ã€‚
        function Runtime( options ) {
            this.options = $.extend({
                container: document.body
            }, options );
            this.uid = Base.guid('rt_');
        }
    
        $.extend( Runtime.prototype, {
    
            getContainer: function() {
                var opts = this.options,
                    parent, container;
    
                if ( this._container ) {
                    return this._container;
                }
    
                parent = $( opts.container || document.body );
                container = $( document.createElement('div') );
    
                container.attr( 'id', 'rt_' + this.uid );
                container.css({
                    position: 'absolute',
                    top: '0px',
                    left: '0px',
                    width: '1px',
                    height: '1px',
                    overflow: 'hidden'
                });
    
                parent.append( container );
                parent.addClass('webuploader-container');
                this._container = container;
                this._parent = parent;
                return container;
            },
    
            init: Base.noop,
            exec: Base.noop,
    
            destroy: function() {
                this._container && this._container.remove();
                this._parent && this._parent.removeClass('webuploader-container');
                this.off();
            }
        });
    
        Runtime.orders = 'html5,flash';
    
    
        /**
         * æ·»åŠ Runtimeå®žçŽ°ã€‚
         * @param {String} type    ç±»åž‹
         * @param {Runtime} factory å…·ä½“Runtimeå®žçŽ°ã€‚
         */
        Runtime.addRuntime = function( type, factory ) {
            factories[ type ] = factory;
        };
    
        Runtime.hasRuntime = function( type ) {
            return !!(type ? factories[ type ] : getFirstKey( factories ));
        };
    
        Runtime.create = function( opts, orders ) {
            var type, runtime;
    
            orders = orders || Runtime.orders;
            $.each( orders.split( /\s*,\s*/g ), function() {
                if ( factories[ this ] ) {
                    type = this;
                    return false;
                }
            });
    
            type = type || getFirstKey( factories );
    
            if ( !type ) {
                throw new Error('Runtime Error');
            }
    
            runtime = new factories[ type ]( opts );
            return runtime;
        };
    
        Mediator.installTo( Runtime.prototype );
        return Runtime;
    });
    
    /**
     * @fileOverview Runtimeç®¡ç†å™¨ï¼Œè´Ÿè´£Runtimeçš„é€‰æ‹©, è¿žæŽ¥
     */
    define('runtime/client',[
        'base',
        'mediator',
        'runtime/runtime'
    ], function( Base, Mediator, Runtime ) {
    
        var cache;
    
        cache = (function() {
            var obj = {};
    
            return {
                add: function( runtime ) {
                    obj[ runtime.uid ] = runtime;
                },
    
                get: function( ruid, standalone ) {
                    var i;
    
                    if ( ruid ) {
                        return obj[ ruid ];
                    }
    
                    for ( i in obj ) {
                        // æœ‰äº›ç±»åž‹ä¸èƒ½é‡ç”¨ï¼Œæ¯”å¦‚filepicker.
                        if ( standalone && obj[ i ].__standalone ) {
                            continue;
                        }
    
                        return obj[ i ];
                    }
    
                    return null;
                },
    
                remove: function( runtime ) {
                    delete obj[ runtime.uid ];
                }
            };
        })();
    
        function RuntimeClient( component, standalone ) {
            var deferred = Base.Deferred(),
                runtime;
    
            this.uid = Base.guid('client_');
    
            // å…è®¸runtimeæ²¡æœ‰åˆå§‹åŒ–ä¹‹å‰ï¼Œæ³¨å†Œä¸€äº›æ–¹æ³•åœ¨åˆå§‹åŒ–åŽæ‰§è¡Œã€‚
            this.runtimeReady = function( cb ) {
                return deferred.done( cb );
            };
    
            this.connectRuntime = function( opts, cb ) {
    
                // already connected.
                if ( runtime ) {
                    throw new Error('already connected!');
                }
    
                deferred.done( cb );
    
                if ( typeof opts === 'string' && cache.get( opts ) ) {
                    runtime = cache.get( opts );
                }
    
                // åƒfilePickeråªèƒ½ç‹¬ç«‹å­˜åœ¨ï¼Œä¸èƒ½å…¬ç”¨ã€‚
                runtime = runtime || cache.get( null, standalone );
    
                // éœ€è¦åˆ›å»º
                if ( !runtime ) {
                    runtime = Runtime.create( opts, opts.runtimeOrder );
                    runtime.__promise = deferred.promise();
                    runtime.once( 'ready', deferred.resolve );
                    runtime.init();
                    cache.add( runtime );
                    runtime.__client = 1;
                } else {
                    // æ¥è‡ªcache
                    Base.$.extend( runtime.options, opts );
                    runtime.__promise.then( deferred.resolve );
                    runtime.__client++;
                }
    
                standalone && (runtime.__standalone = standalone);
                return runtime;
            };
    
            this.getRuntime = function() {
                return runtime;
            };
    
            this.disconnectRuntime = function() {
                if ( !runtime ) {
                    return;
                }
    
                runtime.__client--;
    
                if ( runtime.__client <= 0 ) {
                    cache.remove( runtime );
                    delete runtime.__promise;
                    runtime.destroy();
                }
    
                runtime = null;
            };
    
            this.exec = function() {
                if ( !runtime ) {
                    return;
                }
    
                var args = Base.slice( arguments );
                component && args.unshift( component );
    
                return runtime.exec.apply( this, args );
            };
    
            this.getRuid = function() {
                return runtime && runtime.uid;
            };
    
            this.destroy = (function( destroy ) {
                return function() {
                    destroy && destroy.apply( this, arguments );
                    this.trigger('destroy');
                    this.off();
                    this.exec('destroy');
                    this.disconnectRuntime();
                };
            })( this.destroy );
        }
    
        Mediator.installTo( RuntimeClient.prototype );
        return RuntimeClient;
    });
    /**
     * @fileOverview Blob
     */
    define('lib/blob',[
        'base',
        'runtime/client'
    ], function( Base, RuntimeClient ) {
    
        function Blob( ruid, source ) {
            var me = this;
    
            me.source = source;
            me.ruid = ruid;
            this.size = source.size || 0;
    
            // å¦‚æžœæ²¡æœ‰æŒ‡å®š mimetype, ä½†æ˜¯çŸ¥é“æ–‡ä»¶åŽç¼€ã€‚
            if ( !source.type && this.ext &&
                    ~'jpg,jpeg,png,gif,bmp'.indexOf( this.ext ) ) {
                this.type = 'image/' + (this.ext === 'jpg' ? 'jpeg' : this.ext);
            } else {
                this.type = source.type || 'application/octet-stream';
            }
    
            RuntimeClient.call( me, 'Blob' );
            this.uid = source.uid || this.uid;
    
            if ( ruid ) {
                me.connectRuntime( ruid );
            }
        }
    
        Base.inherits( RuntimeClient, {
            constructor: Blob,
    
            slice: function( start, end ) {
                return this.exec( 'slice', start, end );
            },
    
            getSource: function() {
                return this.source;
            }
        });
    
        return Blob;
    });
    /**
     * ä¸ºäº†ç»Ÿä¸€åŒ–Flashçš„Fileå’ŒHTML5çš„Fileè€Œå­˜åœ¨ã€‚
     * ä»¥è‡³äºŽè¦è°ƒç”¨Flashé‡Œé¢çš„Fileï¼Œä¹Ÿå¯ä»¥åƒè°ƒç”¨HTML5ç‰ˆæœ¬çš„Fileä¸€ä¸‹ã€‚
     * @fileOverview File
     */
    define('lib/file',[
        'base',
        'lib/blob'
    ], function( Base, Blob ) {
    
        var uid = 1,
            rExt = /\.([^.]+)$/;
    
        function File( ruid, file ) {
            var ext;
    
            this.name = file.name || ('untitled' + uid++);
            ext = rExt.exec( file.name ) ? RegExp.$1.toLowerCase() : '';
    
            // todo æ”¯æŒå…¶ä»–ç±»åž‹æ–‡ä»¶çš„è½¬æ¢ã€‚
            // å¦‚æžœæœ‰ mimetype, ä½†æ˜¯æ–‡ä»¶åé‡Œé¢æ²¡æœ‰æ‰¾å‡ºåŽç¼€è§„å¾‹
            if ( !ext && file.type ) {
                ext = /\/(jpg|jpeg|png|gif|bmp)$/i.exec( file.type ) ?
                        RegExp.$1.toLowerCase() : '';
                this.name += '.' + ext;
            }
    
            this.ext = ext;
            this.lastModifiedDate = file.lastModifiedDate ||
                    (new Date()).toLocaleString();
    
            Blob.apply( this, arguments );
        }
    
        return Base.inherits( Blob, File );
    });
    
    /**
     * @fileOverview é”™è¯¯ä¿¡æ¯
     */
    define('lib/filepicker',[
        'base',
        'runtime/client',
        'lib/file'
    ], function( Base, RuntimeClent, File ) {
    
        var $ = Base.$;
    
        function FilePicker( opts ) {
            opts = this.options = $.extend({}, FilePicker.options, opts );
    
            opts.container = $( opts.id );
    
            if ( !opts.container.length ) {
                throw new Error('æŒ‰é’®æŒ‡å®šé”™è¯¯');
            }
    
            opts.innerHTML = opts.innerHTML || opts.label ||
                    opts.container.html() || '';
    
            opts.button = $( opts.button || document.createElement('div') );
            opts.button.html( opts.innerHTML );
            opts.container.html( opts.button );
    
            RuntimeClent.call( this, 'FilePicker', true );
        }
    
        FilePicker.options = {
            button: null,
            container: null,
            label: null,
            innerHTML: null,
            multiple: true,
            accept: null,
            name: 'file'
        };
    
        Base.inherits( RuntimeClent, {
            constructor: FilePicker,
    
            init: function() {
                var me = this,
                    opts = me.options,
                    button = opts.button;
    
                button.addClass('webuploader-pick');
    
                me.on( 'all', function( type ) {
                    var files;
    
                    switch ( type ) {
                        case 'mouseenter':
                            button.addClass('webuploader-pick-hover');
                            break;
    
                        case 'mouseleave':
                            button.removeClass('webuploader-pick-hover');
                            break;
    
                        case 'change':
                            files = me.exec('getFiles');
                            me.trigger( 'select', $.map( files, function( file ) {
                                file = new File( me.getRuid(), file );
    
                                // è®°å½•æ¥æºã€‚
                                file._refer = opts.container;
                                return file;
                            }), opts.container );
                            break;
                    }
                });
    
                me.connectRuntime( opts, function() {
                    me.refresh();
                    me.exec( 'init', opts );
                    me.trigger('ready');
                });
    
                this._resizeHandler = Base.bindFn( this.refresh, this );
                $( window ).on( 'resize', this._resizeHandler );
            },
    
            refresh: function() {
                var shimContainer = this.getRuntime().getContainer(),
                    button = this.options.button,
                    width = button.outerWidth ?
                            button.outerWidth() : button.width(),
    
                    height = button.outerHeight ?
                            button.outerHeight() : button.height(),
    
                    pos = button.offset();
    
                width && height && shimContainer.css({
                    bottom: 'auto',
                    right: 'auto',
                    width: width + 'px',
                    height: height + 'px'
                }).offset( pos );
            },
    
            enable: function() {
                var btn = this.options.button;
    
                btn.removeClass('webuploader-pick-disable');
                this.refresh();
            },
    
            disable: function() {
                var btn = this.options.button;
    
                this.getRuntime().getContainer().css({
                    top: '-99999px'
                });
    
                btn.addClass('webuploader-pick-disable');
            },
    
            destroy: function() {
                var btn = this.options.button;
                $( window ).off( 'resize', this._resizeHandler );
                btn.removeClass('webuploader-pick-disable webuploader-pick-hover ' +
                    'webuploader-pick');
            }
        });
    
        return FilePicker;
    });
    
    /**
     * @fileOverview ç»„ä»¶åŸºç±»ã€‚
     */
    define('widgets/widget',[
        'base',
        'uploader'
    ], function( Base, Uploader ) {
    
        var $ = Base.$,
            _init = Uploader.prototype._init,
            _destroy = Uploader.prototype.destroy,
            IGNORE = {},
            widgetClass = [];
    
        function isArrayLike( obj ) {
            if ( !obj ) {
                return false;
            }
    
            var length = obj.length,
                type = $.type( obj );
    
            if ( obj.nodeType === 1 && length ) {
                return true;
            }
    
            return type === 'array' || type !== 'function' && type !== 'string' &&
                    (length === 0 || typeof length === 'number' && length > 0 &&
                    (length - 1) in obj);
        }
    
        function Widget( uploader ) {
            this.owner = uploader;
            this.options = uploader.options;
        }
    
        $.extend( Widget.prototype, {
    
            init: Base.noop,
    
            // ç±»Backboneçš„äº‹ä»¶ç›‘å¬å£°æ˜Žï¼Œç›‘å¬uploaderå®žä¾‹ä¸Šçš„äº‹ä»¶
            // widgetç›´æŽ¥æ— æ³•ç›‘å¬äº‹ä»¶ï¼Œäº‹ä»¶åªèƒ½é€šè¿‡uploaderæ¥ä¼ é€’
            invoke: function( apiName, args ) {
    
                /*
                    {
                        'make-thumb': 'makeThumb'
                    }
                 */
                var map = this.responseMap;
    
                // å¦‚æžœæ— APIå“åº”å£°æ˜Žåˆ™å¿½ç•¥
                if ( !map || !(apiName in map) || !(map[ apiName ] in this) ||
                        !$.isFunction( this[ map[ apiName ] ] ) ) {
    
                    return IGNORE;
                }
    
                return this[ map[ apiName ] ].apply( this, args );
    
            },
    
            /**
             * å‘é€å‘½ä»¤ã€‚å½“ä¼ å…¥`callback`æˆ–è€…`handler`ä¸­è¿”å›ž`promise`æ—¶ã€‚è¿”å›žä¸€ä¸ªå½“æ‰€æœ‰`handler`ä¸­çš„promiseéƒ½å®ŒæˆåŽå®Œæˆçš„æ–°`promise`ã€‚
             * @method request
             * @grammar request( command, args ) => * | Promise
             * @grammar request( command, args, callback ) => Promise
             * @for  Uploader
             */
            request: function() {
                return this.owner.request.apply( this.owner, arguments );
            }
        });
    
        // æ‰©å±•Uploader.
        $.extend( Uploader.prototype, {
    
            /**
             * @property {String | Array} [disableWidgets=undefined]
             * @namespace options
             * @for Uploader
             * @description é»˜è®¤æ‰€æœ‰ Uploader.register äº†çš„ widget éƒ½ä¼šè¢«åŠ è½½ï¼Œå¦‚æžœç¦ç”¨æŸä¸€éƒ¨åˆ†ï¼Œè¯·é€šè¿‡æ­¤ option æŒ‡å®šé»‘åå•ã€‚
             */
    
            // è¦†å†™_initç”¨æ¥åˆå§‹åŒ–widgets
            _init: function() {
                var me = this,
                    widgets = me._widgets = [],
                    deactives = me.options.disableWidgets || '';
    
                $.each( widgetClass, function( _, klass ) {
                    (!deactives || !~deactives.indexOf( klass._name )) &&
                        widgets.push( new klass( me ) );
                });
    
                return _init.apply( me, arguments );
            },
    
            request: function( apiName, args, callback ) {
                var i = 0,
                    widgets = this._widgets,
                    len = widgets && widgets.length,
                    rlts = [],
                    dfds = [],
                    widget, rlt, promise, key;
    
                args = isArrayLike( args ) ? args : [ args ];
    
                for ( ; i < len; i++ ) {
                    widget = widgets[ i ];
                    rlt = widget.invoke( apiName, args );
    
                    if ( rlt !== IGNORE ) {
    
                        // Deferredå¯¹è±¡
                        if ( Base.isPromise( rlt ) ) {
                            dfds.push( rlt );
                        } else {
                            rlts.push( rlt );
                        }
                    }
                }
    
                // å¦‚æžœæœ‰callbackï¼Œåˆ™ç”¨å¼‚æ­¥æ–¹å¼ã€‚
                if ( callback || dfds.length ) {
                    promise = Base.when.apply( Base, dfds );
                    key = promise.pipe ? 'pipe' : 'then';
    
                    // å¾ˆé‡è¦ä¸èƒ½åˆ é™¤ã€‚åˆ é™¤äº†ä¼šæ­»å¾ªçŽ¯ã€‚
                    // ä¿è¯æ‰§è¡Œé¡ºåºã€‚è®©callbackæ€»æ˜¯åœ¨ä¸‹ä¸€ä¸ª tick ä¸­æ‰§è¡Œã€‚
                    return promise[ key ](function() {
                                var deferred = Base.Deferred(),
                                    args = arguments;
    
                                if ( args.length === 1 ) {
                                    args = args[ 0 ];
                                }
    
                                setTimeout(function() {
                                    deferred.resolve( args );
                                }, 1 );
    
                                return deferred.promise();
                            })[ callback ? key : 'done' ]( callback || Base.noop );
                } else {
                    return rlts[ 0 ];
                }
            },
    
            destroy: function() {
                _destroy.apply( this, arguments );
                this._widgets = null;
            }
        });
    
        /**
         * æ·»åŠ ç»„ä»¶
         * @grammar Uploader.register(proto);
         * @grammar Uploader.register(map, proto);
         * @param  {object} responseMap API åç§°ä¸Žå‡½æ•°å®žçŽ°çš„æ˜ å°„
         * @param  {object} proto ç»„ä»¶åŽŸåž‹ï¼Œæž„é€ å‡½æ•°é€šè¿‡ constructor å±žæ€§å®šä¹‰
         * @method Uploader.register
         * @for Uploader
         * @example
         * Uploader.register({
         *     'make-thumb': 'makeThumb'
         * }, {
         *     init: function( options ) {},
         *     makeThumb: function() {}
         * });
         *
         * Uploader.register({
         *     'make-thumb': function() {
         *         
         *     }
         * });
         */
        Uploader.register = Widget.register = function( responseMap, widgetProto ) {
            var map = { init: 'init', destroy: 'destroy', name: 'anonymous' },
                klass;
    
            if ( arguments.length === 1 ) {
                widgetProto = responseMap;
    
                // è‡ªåŠ¨ç”Ÿæˆ map è¡¨ã€‚
                $.each(widgetProto, function(key) {
                    if ( key[0] === '_' || key === 'name' ) {
                        key === 'name' && (map.name = widgetProto.name);
                        return;
                    }
    
                    map[key.replace(/[A-Z]/g, '-$&').toLowerCase()] = key;
                });
    
            } else {
                map = $.extend( map, responseMap );
            }
    
            widgetProto.responseMap = map;
            klass = Base.inherits( Widget, widgetProto );
            klass._name = map.name;
            widgetClass.push( klass );
    
            return klass;
        };
    
        /**
         * åˆ é™¤æ’ä»¶ï¼Œåªæœ‰åœ¨æ³¨å†Œæ—¶æŒ‡å®šäº†åå­—çš„æ‰èƒ½è¢«åˆ é™¤ã€‚
         * @grammar Uploader.unRegister(name);
         * @param  {string} name ç»„ä»¶åå­—
         * @method Uploader.unRegister
         * @for Uploader
         * @example
         *
         * Uploader.register({
         *     name: 'custom',
         *     
         *     'make-thumb': function() {
         *         
         *     }
         * });
         *
         * Uploader.unRegister('custom');
         */
        Uploader.unRegister = Widget.unRegister = function( name ) {
            if ( !name || name === 'anonymous' ) {
                return;
            }
            
            // åˆ é™¤æŒ‡å®šçš„æ’ä»¶ã€‚
            for ( var i = widgetClass.length; i--; ) {
                if ( widgetClass[i]._name === name ) {
                    widgetClass.splice(i, 1)
                }
            }
        };
    
        return Widget;
    });
    /**
     * @fileOverview æ–‡ä»¶é€‰æ‹©ç›¸å…³
     */
    define('widgets/filepicker',[
        'base',
        'uploader',
        'lib/filepicker',
        'widgets/widget'
    ], function( Base, Uploader, FilePicker ) {
        var $ = Base.$;
    
        $.extend( Uploader.options, {
    
            /**
             * @property {Selector | Object} [pick=undefined]
             * @namespace options
             * @for Uploader
             * @description æŒ‡å®šé€‰æ‹©æ–‡ä»¶çš„æŒ‰é’®å®¹å™¨ï¼Œä¸æŒ‡å®šåˆ™ä¸åˆ›å»ºæŒ‰é’®ã€‚
             *
             * * `id` {Seletor|dom} æŒ‡å®šé€‰æ‹©æ–‡ä»¶çš„æŒ‰é’®å®¹å™¨ï¼Œä¸æŒ‡å®šåˆ™ä¸åˆ›å»ºæŒ‰é’®ã€‚**æ³¨æ„** è¿™é‡Œè™½ç„¶å†™çš„æ˜¯ id, ä½†æ˜¯ä¸æ˜¯åªæ”¯æŒ id, è¿˜æ”¯æŒ class, æˆ–è€… dom èŠ‚ç‚¹ã€‚
             * * `label` {String} è¯·é‡‡ç”¨ `innerHTML` ä»£æ›¿
             * * `innerHTML` {String} æŒ‡å®šæŒ‰é’®æ–‡å­—ã€‚ä¸æŒ‡å®šæ—¶ä¼˜å…ˆä»ŽæŒ‡å®šçš„å®¹å™¨ä¸­çœ‹æ˜¯å¦è‡ªå¸¦æ–‡å­—ã€‚
             * * `multiple` {Boolean} æ˜¯å¦å¼€èµ·åŒæ—¶é€‰æ‹©å¤šä¸ªæ–‡ä»¶èƒ½åŠ›ã€‚
             */
            pick: null,
    
            /**
             * @property {Arroy} [accept=null]
             * @namespace options
             * @for Uploader
             * @description æŒ‡å®šæŽ¥å—å“ªäº›ç±»åž‹çš„æ–‡ä»¶ã€‚ ç”±äºŽç›®å‰è¿˜æœ‰extè½¬mimeTypeè¡¨ï¼Œæ‰€ä»¥è¿™é‡Œéœ€è¦åˆ†å¼€æŒ‡å®šã€‚
             *
             * * `title` {String} æ–‡å­—æè¿°
             * * `extensions` {String} å…è®¸çš„æ–‡ä»¶åŽç¼€ï¼Œä¸å¸¦ç‚¹ï¼Œå¤šä¸ªç”¨é€—å·åˆ†å‰²ã€‚
             * * `mimeTypes` {String} å¤šä¸ªç”¨é€—å·åˆ†å‰²ã€‚
             *
             * å¦‚ï¼š
             *
             * ```
             * {
             *     title: 'Images',
             *     extensions: 'gif,jpg,jpeg,bmp,png',
             *     mimeTypes: 'image/*'
             * }
             * ```
             */
            accept: null/*{
                title: 'Images',
                extensions: 'gif,jpg,jpeg,bmp,png',
                mimeTypes: 'image/*'
            }*/
        });
    
        return Uploader.register({
            name: 'picker',
    
            init: function( opts ) {
                this.pickers = [];
                return opts.pick && this.addBtn( opts.pick );
            },
    
            refresh: function() {
                $.each( this.pickers, function() {
                    this.refresh();
                });
            },
    
            /**
             * @method addButton
             * @for Uploader
             * @grammar addButton( pick ) => Promise
             * @description
             * æ·»åŠ æ–‡ä»¶é€‰æ‹©æŒ‰é’®ï¼Œå¦‚æžœä¸€ä¸ªæŒ‰é’®ä¸å¤Ÿï¼Œéœ€è¦è°ƒç”¨æ­¤æ–¹æ³•æ¥æ·»åŠ ã€‚å‚æ•°è·Ÿ[options.pick](#WebUploader:Uploader:options)ä¸€è‡´ã€‚
             * @example
             * uploader.addButton({
             *     id: '#btnContainer',
             *     innerHTML: 'é€‰æ‹©æ–‡ä»¶'
             * });
             */
            addBtn: function( pick ) {
                var me = this,
                    opts = me.options,
                    accept = opts.accept,
                    promises = [];
    
                if ( !pick ) {
                    return;
                }
    
                $.isPlainObject( pick ) || (pick = {
                    id: pick
                });
    
                $( pick.id ).each(function() {
                    var options, picker, deferred;
    
                    deferred = Base.Deferred();
    
                    options = $.extend({}, pick, {
                        accept: $.isPlainObject( accept ) ? [ accept ] : accept,
                        swf: opts.swf,
                        runtimeOrder: opts.runtimeOrder,
                        id: this
                    });
    
                    picker = new FilePicker( options );
    
                    picker.once( 'ready', deferred.resolve );
                    picker.on( 'select', function( files ) {
                        me.owner.request( 'add-file', [ files ]);
                    });
                    picker.init();
    
                    me.pickers.push( picker );
    
                    promises.push( deferred.promise() );
                });
    
                return Base.when.apply( Base, promises );
            },
    
            disable: function() {
                $.each( this.pickers, function() {
                    this.disable();
                });
            },
    
            enable: function() {
                $.each( this.pickers, function() {
                    this.enable();
                });
            },
    
            destroy: function() {
                $.each( this.pickers, function() {
                    this.destroy();
                });
                this.pickers = null;
            }
        });
    });
    /**
     * @fileOverview Image
     */
    define('lib/image',[
        'base',
        'runtime/client',
        'lib/blob'
    ], function( Base, RuntimeClient, Blob ) {
        var $ = Base.$;
    
        // æž„é€ å™¨ã€‚
        function Image( opts ) {
            this.options = $.extend({}, Image.options, opts );
            RuntimeClient.call( this, 'Image' );
    
            this.on( 'load', function() {
                this._info = this.exec('info');
                this._meta = this.exec('meta');
            });
        }
    
        // é»˜è®¤é€‰é¡¹ã€‚
        Image.options = {
    
            // é»˜è®¤çš„å›¾ç‰‡å¤„ç†è´¨é‡
            quality: 90,
    
            // æ˜¯å¦è£å‰ª
            crop: false,
    
            // æ˜¯å¦ä¿ç•™å¤´éƒ¨ä¿¡æ¯
            preserveHeaders: false,
    
            // æ˜¯å¦å…è®¸æ”¾å¤§ã€‚
            allowMagnify: false
        };
    
        // ç»§æ‰¿RuntimeClient.
        Base.inherits( RuntimeClient, {
            constructor: Image,
    
            info: function( val ) {
    
                // setter
                if ( val ) {
                    this._info = val;
                    return this;
                }
    
                // getter
                return this._info;
            },
    
            meta: function( val ) {
    
                // setter
                if ( val ) {
                    this._meta = val;
                    return this;
                }
    
                // getter
                return this._meta;
            },
    
            loadFromBlob: function( blob ) {
                var me = this,
                    ruid = blob.getRuid();
    
                this.connectRuntime( ruid, function() {
                    me.exec( 'init', me.options );
                    me.exec( 'loadFromBlob', blob );
                });
            },
    
            resize: function() {
                var args = Base.slice( arguments );
                return this.exec.apply( this, [ 'resize' ].concat( args ) );
            },
    
            crop: function() {
                var args = Base.slice( arguments );
                return this.exec.apply( this, [ 'crop' ].concat( args ) );
            },
    
            getAsDataUrl: function( type ) {
                return this.exec( 'getAsDataUrl', type );
            },
    
            getAsBlob: function( type ) {
                var blob = this.exec( 'getAsBlob', type );
    
                return new Blob( this.getRuid(), blob );
            }
        });
    
        return Image;
    });
    /**
     * @fileOverview å›¾ç‰‡æ“ä½œ, è´Ÿè´£é¢„è§ˆå›¾ç‰‡å’Œä¸Šä¼ å‰åŽ‹ç¼©å›¾ç‰‡
     */
    define('widgets/image',[
        'base',
        'uploader',
        'lib/image',
        'widgets/widget'
    ], function( Base, Uploader, Image ) {
    
        var $ = Base.$,
            throttle;
    
        // æ ¹æ®è¦å¤„ç†çš„æ–‡ä»¶å¤§å°æ¥èŠ‚æµï¼Œä¸€æ¬¡ä¸èƒ½å¤„ç†å¤ªå¤šï¼Œä¼šå¡ã€‚
        throttle = (function( max ) {
            var occupied = 0,
                waiting = [],
                tick = function() {
                    var item;
    
                    while ( waiting.length && occupied < max ) {
                        item = waiting.shift();
                        occupied += item[ 0 ];
                        item[ 1 ]();
                    }
                };
    
            return function( emiter, size, cb ) {
                waiting.push([ size, cb ]);
                emiter.once( 'destroy', function() {
                    occupied -= size;
                    setTimeout( tick, 1 );
                });
                setTimeout( tick, 1 );
            };
        })( 5 * 1024 * 1024 );
    
        $.extend( Uploader.options, {
    
            /**
             * @property {Object} [thumb]
             * @namespace options
             * @for Uploader
             * @description é…ç½®ç”Ÿæˆç¼©ç•¥å›¾çš„é€‰é¡¹ã€‚
             *
             * é»˜è®¤ä¸ºï¼š
             *
             * ```javascript
             * {
             *     width: 110,
             *     height: 110,
             *
             *     // å›¾ç‰‡è´¨é‡ï¼Œåªæœ‰typeä¸º`image/jpeg`çš„æ—¶å€™æ‰æœ‰æ•ˆã€‚
             *     quality: 70,
             *
             *     // æ˜¯å¦å…è®¸æ”¾å¤§ï¼Œå¦‚æžœæƒ³è¦ç”Ÿæˆå°å›¾çš„æ—¶å€™ä¸å¤±çœŸï¼Œæ­¤é€‰é¡¹åº”è¯¥è®¾ç½®ä¸ºfalse.
             *     allowMagnify: true,
             *
             *     // æ˜¯å¦å…è®¸è£å‰ªã€‚
             *     crop: true,
             *
             *     // ä¸ºç©ºçš„è¯åˆ™ä¿ç•™åŽŸæœ‰å›¾ç‰‡æ ¼å¼ã€‚
             *     // å¦åˆ™å¼ºåˆ¶è½¬æ¢æˆæŒ‡å®šçš„ç±»åž‹ã€‚
             *     type: 'image/jpeg'
             * }
             * ```
             */
            thumb: {
                width: 110,
                height: 110,
                quality: 70,
                allowMagnify: true,
                crop: true,
                preserveHeaders: false,
    
                // ä¸ºç©ºçš„è¯åˆ™ä¿ç•™åŽŸæœ‰å›¾ç‰‡æ ¼å¼ã€‚
                // å¦åˆ™å¼ºåˆ¶è½¬æ¢æˆæŒ‡å®šçš„ç±»åž‹ã€‚
                // IE 8ä¸‹é¢ base64 å¤§å°ä¸èƒ½è¶…è¿‡ 32K å¦åˆ™é¢„è§ˆå¤±è´¥ï¼Œè€Œéž jpeg ç¼–ç çš„å›¾ç‰‡å¾ˆå¯
                // èƒ½ä¼šè¶…è¿‡ 32k, æ‰€ä»¥è¿™é‡Œè®¾ç½®æˆé¢„è§ˆçš„æ—¶å€™éƒ½æ˜¯ image/jpeg
                type: 'image/jpeg'
            },
    
            /**
             * @property {Object} [compress]
             * @namespace options
             * @for Uploader
             * @description é…ç½®åŽ‹ç¼©çš„å›¾ç‰‡çš„é€‰é¡¹ã€‚å¦‚æžœæ­¤é€‰é¡¹ä¸º`false`, åˆ™å›¾ç‰‡åœ¨ä¸Šä¼ å‰ä¸è¿›è¡ŒåŽ‹ç¼©ã€‚
             *
             * é»˜è®¤ä¸ºï¼š
             *
             * ```javascript
             * {
             *     width: 1600,
             *     height: 1600,
             *
             *     // å›¾ç‰‡è´¨é‡ï¼Œåªæœ‰typeä¸º`image/jpeg`çš„æ—¶å€™æ‰æœ‰æ•ˆã€‚
             *     quality: 90,
             *
             *     // æ˜¯å¦å…è®¸æ”¾å¤§ï¼Œå¦‚æžœæƒ³è¦ç”Ÿæˆå°å›¾çš„æ—¶å€™ä¸å¤±çœŸï¼Œæ­¤é€‰é¡¹åº”è¯¥è®¾ç½®ä¸ºfalse.
             *     allowMagnify: false,
             *
             *     // æ˜¯å¦å…è®¸è£å‰ªã€‚
             *     crop: false,
             *
             *     // æ˜¯å¦ä¿ç•™å¤´éƒ¨metaä¿¡æ¯ã€‚
             *     preserveHeaders: true,
             *
             *     // å¦‚æžœå‘çŽ°åŽ‹ç¼©åŽæ–‡ä»¶å¤§å°æ¯”åŽŸæ¥è¿˜å¤§ï¼Œåˆ™ä½¿ç”¨åŽŸæ¥å›¾ç‰‡
             *     // æ­¤å±žæ€§å¯èƒ½ä¼šå½±å“å›¾ç‰‡è‡ªåŠ¨çº æ­£åŠŸèƒ½
             *     noCompressIfLarger: false,
             *
             *     // å•ä½å­—èŠ‚ï¼Œå¦‚æžœå›¾ç‰‡å¤§å°å°äºŽæ­¤å€¼ï¼Œä¸ä¼šé‡‡ç”¨åŽ‹ç¼©ã€‚
             *     compressSize: 0
             * }
             * ```
             */
            compress: {
                width: 1600,
                height: 1600,
                quality: 90,
                allowMagnify: false,
                crop: false,
                preserveHeaders: true
            }
        });
    
        return Uploader.register({
    
            name: 'image',
    
    
            /**
             * ç”Ÿæˆç¼©ç•¥å›¾ï¼Œæ­¤è¿‡ç¨‹ä¸ºå¼‚æ­¥ï¼Œæ‰€ä»¥éœ€è¦ä¼ å…¥`callback`ã€‚
             * é€šå¸¸æƒ…å†µåœ¨å›¾ç‰‡åŠ å…¥é˜Ÿé‡ŒåŽè°ƒç”¨æ­¤æ–¹æ³•æ¥ç”Ÿæˆé¢„è§ˆå›¾ä»¥å¢žå¼ºäº¤äº’æ•ˆæžœã€‚
             *
             * å½“ width æˆ–è€… height çš„å€¼ä»‹äºŽ 0 - 1 æ—¶ï¼Œè¢«å½“æˆç™¾åˆ†æ¯”ä½¿ç”¨ã€‚
             *
             * `callback`ä¸­å¯ä»¥æŽ¥æ”¶åˆ°ä¸¤ä¸ªå‚æ•°ã€‚
             * * ç¬¬ä¸€ä¸ªä¸ºerrorï¼Œå¦‚æžœç”Ÿæˆç¼©ç•¥å›¾æœ‰é”™è¯¯ï¼Œæ­¤errorå°†ä¸ºçœŸã€‚
             * * ç¬¬äºŒä¸ªä¸ºret, ç¼©ç•¥å›¾çš„Data URLå€¼ã€‚
             *
             * **æ³¨æ„**
             * Date URLåœ¨IE6/7ä¸­ä¸æ”¯æŒï¼Œæ‰€ä»¥ä¸ç”¨è°ƒç”¨æ­¤æ–¹æ³•äº†ï¼Œç›´æŽ¥æ˜¾ç¤ºä¸€å¼ æš‚ä¸æ”¯æŒé¢„è§ˆå›¾ç‰‡å¥½äº†ã€‚
             * ä¹Ÿå¯ä»¥å€ŸåŠ©æœåŠ¡ç«¯ï¼Œå°† base64 æ•°æ®ä¼ ç»™æœåŠ¡ç«¯ï¼Œç”Ÿæˆä¸€ä¸ªä¸´æ—¶æ–‡ä»¶ä¾›é¢„è§ˆã€‚
             *
             * @method makeThumb
             * @grammar makeThumb( file, callback ) => undefined
             * @grammar makeThumb( file, callback, width, height ) => undefined
             * @for Uploader
             * @example
             *
             * uploader.on( 'fileQueued', function( file ) {
             *     var $li = ...;
             *
             *     uploader.makeThumb( file, function( error, ret ) {
             *         if ( error ) {
             *             $li.text('é¢„è§ˆé”™è¯¯');
             *         } else {
             *             $li.append('<img alt="" src="' + ret + '" />');
             *         }
             *     });
             *
             * });
             */
            makeThumb: function( file, cb, width, height ) {
                var opts, image;
    
                file = this.request( 'get-file', file );
    
                // åªé¢„è§ˆå›¾ç‰‡æ ¼å¼ã€‚
                if ( !file.type.match( /^image/ ) ) {
                    cb( true );
                    return;
                }
    
                opts = $.extend({}, this.options.thumb );
    
                // å¦‚æžœä¼ å…¥çš„æ˜¯object.
                if ( $.isPlainObject( width ) ) {
                    opts = $.extend( opts, width );
                    width = null;
                }
    
                width = width || opts.width;
                height = height || opts.height;
    
                image = new Image( opts );
    
                image.once( 'load', function() {
                    file._info = file._info || image.info();
                    file._meta = file._meta || image.meta();
    
                    // å¦‚æžœ width çš„å€¼ä»‹äºŽ 0 - 1
                    // è¯´æ˜Žè®¾ç½®çš„æ˜¯ç™¾åˆ†æ¯”ã€‚
                    if ( width <= 1 && width > 0 ) {
                        width = file._info.width * width;
                    }
    
                    // åŒæ ·çš„è§„åˆ™åº”ç”¨äºŽ height
                    if ( height <= 1 && height > 0 ) {
                        height = file._info.height * height;
                    }
    
                    image.resize( width, height );
                });
    
                // å½“ resize å®ŒåŽ
                image.once( 'complete', function() {
                    cb( false, image.getAsDataUrl( opts.type ) );
                    image.destroy();
                });
    
                image.once( 'error', function( reason ) {
                    cb( reason || true );
                    image.destroy();
                });
    
                throttle( image, file.source.size, function() {
                    file._info && image.info( file._info );
                    file._meta && image.meta( file._meta );
                    image.loadFromBlob( file.source );
                });
            },
    
            beforeSendFile: function( file ) {
                var opts = this.options.compress || this.options.resize,
                    compressSize = opts && opts.compressSize || 0,
                    noCompressIfLarger = opts && opts.noCompressIfLarger || false,
                    image, deferred;
    
                file = this.request( 'get-file', file );
    
                // åªåŽ‹ç¼© jpeg å›¾ç‰‡æ ¼å¼ã€‚
                // gif å¯èƒ½ä¼šä¸¢å¤±é’ˆ
                // bmp png åŸºæœ¬ä¸Šå°ºå¯¸éƒ½ä¸å¤§ï¼Œä¸”åŽ‹ç¼©æ¯”æ¯”è¾ƒå°ã€‚
                if ( !opts || !~'image/jpeg,image/jpg'.indexOf( file.type ) ||
                        file.size < compressSize ||
                        file._compressed ) {
                    return;
                }
    
                opts = $.extend({}, opts );
                deferred = Base.Deferred();
    
                image = new Image( opts );
    
                deferred.always(function() {
                    image.destroy();
                    image = null;
                });
                image.once( 'error', deferred.reject );
                image.once( 'load', function() {
                    var width = opts.width,
                        height = opts.height;
    
                    file._info = file._info || image.info();
                    file._meta = file._meta || image.meta();
    
                    // å¦‚æžœ width çš„å€¼ä»‹äºŽ 0 - 1
                    // è¯´æ˜Žè®¾ç½®çš„æ˜¯ç™¾åˆ†æ¯”ã€‚
                    if ( width <= 1 && width > 0 ) {
                        width = file._info.width * width;
                    }
    
                    // åŒæ ·çš„è§„åˆ™åº”ç”¨äºŽ height
                    if ( height <= 1 && height > 0 ) {
                        height = file._info.height * height;
                    }
    
                    image.resize( width, height );
                });
    
                image.once( 'complete', function() {
                    var blob, size;
    
                    // ç§»åŠ¨ç«¯ UC / qq æµè§ˆå™¨çš„æ— å›¾æ¨¡å¼ä¸‹
                    // ctx.getImageData å¤„ç†å¤§å›¾çš„æ—¶å€™ä¼šæŠ¥ Exception
                    // INDEX_SIZE_ERR: DOM Exception 1
                    try {
                        blob = image.getAsBlob( opts.type );
    
                        size = file.size;
    
                        // å¦‚æžœåŽ‹ç¼©åŽï¼Œæ¯”åŽŸæ¥è¿˜å¤§åˆ™ä¸ç”¨åŽ‹ç¼©åŽçš„ã€‚
                        if ( !noCompressIfLarger || blob.size < size ) {
                            // file.source.destroy && file.source.destroy();
                            file.source = blob;
                            file.size = blob.size;
    
                            file.trigger( 'resize', blob.size, size );
                        }
    
                        // æ ‡è®°ï¼Œé¿å…é‡å¤åŽ‹ç¼©ã€‚
                        file._compressed = true;
                        deferred.resolve();
                    } catch ( e ) {
                        // å‡ºé”™äº†ç›´æŽ¥ç»§ç»­ï¼Œè®©å…¶ä¸Šä¼ åŽŸå§‹å›¾ç‰‡
                        deferred.resolve();
                    }
                });
    
                file._info && image.info( file._info );
                file._meta && image.meta( file._meta );
    
                image.loadFromBlob( file.source );
                return deferred.promise();
            }
        });
    });
    /**
     * @fileOverview æ–‡ä»¶å±žæ€§å°è£…
     */
    define('file',[
        'base',
        'mediator'
    ], function( Base, Mediator ) {
    
        var $ = Base.$,
            idPrefix = 'WU_FILE_',
            idSuffix = 0,
            rExt = /\.([^.]+)$/,
            statusMap = {};
    
        function gid() {
            return idPrefix + idSuffix++;
        }
    
        /**
         * æ–‡ä»¶ç±»
         * @class File
         * @constructor æž„é€ å‡½æ•°
         * @grammar new File( source ) => File
         * @param {Lib.File} source [lib.File](#Lib.File)å®žä¾‹, æ­¤sourceå¯¹è±¡æ˜¯å¸¦æœ‰Runtimeä¿¡æ¯çš„ã€‚
         */
        function WUFile( source ) {
    
            /**
             * æ–‡ä»¶åï¼ŒåŒ…æ‹¬æ‰©å±•åï¼ˆåŽç¼€ï¼‰
             * @property name
             * @type {string}
             */
            this.name = source.name || 'Untitled';
    
            /**
             * æ–‡ä»¶ä½“ç§¯ï¼ˆå­—èŠ‚ï¼‰
             * @property size
             * @type {uint}
             * @default 0
             */
            this.size = source.size || 0;
    
            /**
             * æ–‡ä»¶MIMETYPEç±»åž‹ï¼Œä¸Žæ–‡ä»¶ç±»åž‹çš„å¯¹åº”å…³ç³»è¯·å‚è€ƒ[http://t.cn/z8ZnFny](http://t.cn/z8ZnFny)
             * @property type
             * @type {string}
             * @default 'application/octet-stream'
             */
            this.type = source.type || 'application/octet-stream';
    
            /**
             * æ–‡ä»¶æœ€åŽä¿®æ”¹æ—¥æœŸ
             * @property lastModifiedDate
             * @type {int}
             * @default å½“å‰æ—¶é—´æˆ³
             */
            this.lastModifiedDate = source.lastModifiedDate || (new Date() * 1);
    
            /**
             * æ–‡ä»¶IDï¼Œæ¯ä¸ªå¯¹è±¡å…·æœ‰å”¯ä¸€IDï¼Œä¸Žæ–‡ä»¶åæ— å…³
             * @property id
             * @type {string}
             */
            this.id = gid();
    
            /**
             * æ–‡ä»¶æ‰©å±•åï¼Œé€šè¿‡æ–‡ä»¶åèŽ·å–ï¼Œä¾‹å¦‚test.pngçš„æ‰©å±•åä¸ºpng
             * @property ext
             * @type {string}
             */
            this.ext = rExt.exec( this.name ) ? RegExp.$1 : '';
    
    
            /**
             * çŠ¶æ€æ–‡å­—è¯´æ˜Žã€‚åœ¨ä¸åŒçš„statusè¯­å¢ƒä¸‹æœ‰ä¸åŒçš„ç”¨é€”ã€‚
             * @property statusText
             * @type {string}
             */
            this.statusText = '';
    
            // å­˜å‚¨æ–‡ä»¶çŠ¶æ€ï¼Œé˜²æ­¢é€šè¿‡å±žæ€§ç›´æŽ¥ä¿®æ”¹
            statusMap[ this.id ] = WUFile.Status.INITED;
    
            this.source = source;
            this.loaded = 0;
    
            this.on( 'error', function( msg ) {
                this.setStatus( WUFile.Status.ERROR, msg );
            });
        }
    
        $.extend( WUFile.prototype, {
    
            /**
             * è®¾ç½®çŠ¶æ€ï¼ŒçŠ¶æ€å˜åŒ–æ—¶ä¼šè§¦å‘`change`äº‹ä»¶ã€‚
             * @method setStatus
             * @grammar setStatus( status[, statusText] );
             * @param {File.Status|String} status [æ–‡ä»¶çŠ¶æ€å€¼](#WebUploader:File:File.Status)
             * @param {String} [statusText=''] çŠ¶æ€è¯´æ˜Žï¼Œå¸¸åœ¨erroræ—¶ä½¿ç”¨ï¼Œç”¨http, abort,serverç­‰æ¥æ ‡è®°æ˜¯ç”±äºŽä»€ä¹ˆåŽŸå› å¯¼è‡´æ–‡ä»¶é”™è¯¯ã€‚
             */
            setStatus: function( status, text ) {
    
                var prevStatus = statusMap[ this.id ];
    
                typeof text !== 'undefined' && (this.statusText = text);
    
                if ( status !== prevStatus ) {
                    statusMap[ this.id ] = status;
                    /**
                     * æ–‡ä»¶çŠ¶æ€å˜åŒ–
                     * @event statuschange
                     */
                    this.trigger( 'statuschange', status, prevStatus );
                }
    
            },
    
            /**
             * èŽ·å–æ–‡ä»¶çŠ¶æ€
             * @return {File.Status}
             * @example
                     æ–‡ä»¶çŠ¶æ€å…·ä½“åŒ…æ‹¬ä»¥ä¸‹å‡ ç§ç±»åž‹ï¼š
                     {
                         // åˆå§‹åŒ–
                        INITED:     0,
                        // å·²å…¥é˜Ÿåˆ—
                        QUEUED:     1,
                        // æ­£åœ¨ä¸Šä¼ 
                        PROGRESS:     2,
                        // ä¸Šä¼ å‡ºé”™
                        ERROR:         3,
                        // ä¸Šä¼ æˆåŠŸ
                        COMPLETE:     4,
                        // ä¸Šä¼ å–æ¶ˆ
                        CANCELLED:     5
                    }
             */
            getStatus: function() {
                return statusMap[ this.id ];
            },
    
            /**
             * èŽ·å–æ–‡ä»¶åŽŸå§‹ä¿¡æ¯ã€‚
             * @return {*}
             */
            getSource: function() {
                return this.source;
            },
    
            destroy: function() {
                this.off();
                delete statusMap[ this.id ];
            }
        });
    
        Mediator.installTo( WUFile.prototype );
    
        /**
         * æ–‡ä»¶çŠ¶æ€å€¼ï¼Œå…·ä½“åŒ…æ‹¬ä»¥ä¸‹å‡ ç§ç±»åž‹ï¼š
         * * `inited` åˆå§‹çŠ¶æ€
         * * `queued` å·²ç»è¿›å…¥é˜Ÿåˆ—, ç­‰å¾…ä¸Šä¼ 
         * * `progress` ä¸Šä¼ ä¸­
         * * `complete` ä¸Šä¼ å®Œæˆã€‚
         * * `error` ä¸Šä¼ å‡ºé”™ï¼Œå¯é‡è¯•
         * * `interrupt` ä¸Šä¼ ä¸­æ–­ï¼Œå¯ç»­ä¼ ã€‚
         * * `invalid` æ–‡ä»¶ä¸åˆæ ¼ï¼Œä¸èƒ½é‡è¯•ä¸Šä¼ ã€‚ä¼šè‡ªåŠ¨ä»Žé˜Ÿåˆ—ä¸­ç§»é™¤ã€‚
         * * `cancelled` æ–‡ä»¶è¢«ç§»é™¤ã€‚
         * @property {Object} Status
         * @namespace File
         * @class File
         * @static
         */
        WUFile.Status = {
            INITED:     'inited',    // åˆå§‹çŠ¶æ€
            QUEUED:     'queued',    // å·²ç»è¿›å…¥é˜Ÿåˆ—, ç­‰å¾…ä¸Šä¼ 
            PROGRESS:   'progress',    // ä¸Šä¼ ä¸­
            ERROR:      'error',    // ä¸Šä¼ å‡ºé”™ï¼Œå¯é‡è¯•
            COMPLETE:   'complete',    // ä¸Šä¼ å®Œæˆã€‚
            CANCELLED:  'cancelled',    // ä¸Šä¼ å–æ¶ˆã€‚
            INTERRUPT:  'interrupt',    // ä¸Šä¼ ä¸­æ–­ï¼Œå¯ç»­ä¼ ã€‚
            INVALID:    'invalid'    // æ–‡ä»¶ä¸åˆæ ¼ï¼Œä¸èƒ½é‡è¯•ä¸Šä¼ ã€‚
        };
    
        return WUFile;
    });
    
    /**
     * @fileOverview æ–‡ä»¶é˜Ÿåˆ—
     */
    define('queue',[
        'base',
        'mediator',
        'file'
    ], function( Base, Mediator, WUFile ) {
    
        var $ = Base.$,
            STATUS = WUFile.Status;
    
        /**
         * æ–‡ä»¶é˜Ÿåˆ—, ç”¨æ¥å­˜å‚¨å„ä¸ªçŠ¶æ€ä¸­çš„æ–‡ä»¶ã€‚
         * @class Queue
         * @extends Mediator
         */
        function Queue() {
    
            /**
             * ç»Ÿè®¡æ–‡ä»¶æ•°ã€‚
             * * `numOfQueue` é˜Ÿåˆ—ä¸­çš„æ–‡ä»¶æ•°ã€‚
             * * `numOfSuccess` ä¸Šä¼ æˆåŠŸçš„æ–‡ä»¶æ•°
             * * `numOfCancel` è¢«å–æ¶ˆçš„æ–‡ä»¶æ•°
             * * `numOfProgress` æ­£åœ¨ä¸Šä¼ ä¸­çš„æ–‡ä»¶æ•°
             * * `numOfUploadFailed` ä¸Šä¼ é”™è¯¯çš„æ–‡ä»¶æ•°ã€‚
             * * `numOfInvalid` æ— æ•ˆçš„æ–‡ä»¶æ•°ã€‚
             * * `numofDeleted` è¢«ç§»é™¤çš„æ–‡ä»¶æ•°ã€‚
             * @property {Object} stats
             */
            this.stats = {
                numOfQueue: 0,
                numOfSuccess: 0,
                numOfCancel: 0,
                numOfProgress: 0,
                numOfUploadFailed: 0,
                numOfInvalid: 0,
                numofDeleted: 0,
                numofInterrupt: 0
            };
    
            // ä¸Šä¼ é˜Ÿåˆ—ï¼Œä»…åŒ…æ‹¬ç­‰å¾…ä¸Šä¼ çš„æ–‡ä»¶
            this._queue = [];
    
            // å­˜å‚¨æ‰€æœ‰æ–‡ä»¶
            this._map = {};
        }
    
        $.extend( Queue.prototype, {
    
            /**
             * å°†æ–°æ–‡ä»¶åŠ å…¥å¯¹é˜Ÿåˆ—å°¾éƒ¨
             *
             * @method append
             * @param  {File} file   æ–‡ä»¶å¯¹è±¡
             */
            append: function( file ) {
                this._queue.push( file );
                this._fileAdded( file );
                return this;
            },
    
            /**
             * å°†æ–°æ–‡ä»¶åŠ å…¥å¯¹é˜Ÿåˆ—å¤´éƒ¨
             *
             * @method prepend
             * @param  {File} file   æ–‡ä»¶å¯¹è±¡
             */
            prepend: function( file ) {
                this._queue.unshift( file );
                this._fileAdded( file );
                return this;
            },
    
            /**
             * èŽ·å–æ–‡ä»¶å¯¹è±¡
             *
             * @method getFile
             * @param  {String} fileId   æ–‡ä»¶ID
             * @return {File}
             */
            getFile: function( fileId ) {
                if ( typeof fileId !== 'string' ) {
                    return fileId;
                }
                return this._map[ fileId ];
            },
    
            /**
             * ä»Žé˜Ÿåˆ—ä¸­å–å‡ºä¸€ä¸ªæŒ‡å®šçŠ¶æ€çš„æ–‡ä»¶ã€‚
             * @grammar fetch( status ) => File
             * @method fetch
             * @param {String} status [æ–‡ä»¶çŠ¶æ€å€¼](#WebUploader:File:File.Status)
             * @return {File} [File](#WebUploader:File)
             */
            fetch: function( status ) {
                var len = this._queue.length,
                    i, file;
    
                status = status || STATUS.QUEUED;
    
                for ( i = 0; i < len; i++ ) {
                    file = this._queue[ i ];
    
                    if ( status === file.getStatus() ) {
                        return file;
                    }
                }
    
                return null;
            },
    
            /**
             * å¯¹é˜Ÿåˆ—è¿›è¡ŒæŽ’åºï¼Œèƒ½å¤ŸæŽ§åˆ¶æ–‡ä»¶ä¸Šä¼ é¡ºåºã€‚
             * @grammar sort( fn ) => undefined
             * @method sort
             * @param {Function} fn æŽ’åºæ–¹æ³•
             */
            sort: function( fn ) {
                if ( typeof fn === 'function' ) {
                    this._queue.sort( fn );
                }
            },
    
            /**
             * èŽ·å–æŒ‡å®šç±»åž‹çš„æ–‡ä»¶åˆ—è¡¨, åˆ—è¡¨ä¸­æ¯ä¸€ä¸ªæˆå‘˜ä¸º[File](#WebUploader:File)å¯¹è±¡ã€‚
             * @grammar getFiles( [status1[, status2 ...]] ) => Array
             * @method getFiles
             * @param {String} [status] [æ–‡ä»¶çŠ¶æ€å€¼](#WebUploader:File:File.Status)
             */
            getFiles: function() {
                var sts = [].slice.call( arguments, 0 ),
                    ret = [],
                    i = 0,
                    len = this._queue.length,
                    file;
    
                for ( ; i < len; i++ ) {
                    file = this._queue[ i ];
    
                    if ( sts.length && !~$.inArray( file.getStatus(), sts ) ) {
                        continue;
                    }
    
                    ret.push( file );
                }
    
                return ret;
            },
    
            /**
             * åœ¨é˜Ÿåˆ—ä¸­åˆ é™¤æ–‡ä»¶ã€‚
             * @grammar removeFile( file ) => Array
             * @method removeFile
             * @param {File} æ–‡ä»¶å¯¹è±¡ã€‚
             */
            removeFile: function( file ) {
                var me = this,
                    existing = this._map[ file.id ];
    
                if ( existing ) {
                    delete this._map[ file.id ];
                    file.destroy();
                    this.stats.numofDeleted++;
                }
            },
    
            _fileAdded: function( file ) {
                var me = this,
                    existing = this._map[ file.id ];
    
                if ( !existing ) {
                    this._map[ file.id ] = file;
    
                    file.on( 'statuschange', function( cur, pre ) {
                        me._onFileStatusChange( cur, pre );
                    });
                }
            },
    
            _onFileStatusChange: function( curStatus, preStatus ) {
                var stats = this.stats;
    
                switch ( preStatus ) {
                    case STATUS.PROGRESS:
                        stats.numOfProgress--;
                        break;
    
                    case STATUS.QUEUED:
                        stats.numOfQueue --;
                        break;
    
                    case STATUS.ERROR:
                        stats.numOfUploadFailed--;
                        break;
    
                    case STATUS.INVALID:
                        stats.numOfInvalid--;
                        break;
    
                    case STATUS.INTERRUPT:
                        stats.numofInterrupt--;
                        break;
                }
    
                switch ( curStatus ) {
                    case STATUS.QUEUED:
                        stats.numOfQueue++;
                        break;
    
                    case STATUS.PROGRESS:
                        stats.numOfProgress++;
                        break;
    
                    case STATUS.ERROR:
                        stats.numOfUploadFailed++;
                        break;
    
                    case STATUS.COMPLETE:
                        stats.numOfSuccess++;
                        break;
    
                    case STATUS.CANCELLED:
                        stats.numOfCancel++;
                        break;
    
    
                    case STATUS.INVALID:
                        stats.numOfInvalid++;
                        break;
    
                    case STATUS.INTERRUPT:
                        stats.numofInterrupt++;
                        break;
                }
            }
    
        });
    
        Mediator.installTo( Queue.prototype );
    
        return Queue;
    });
    /**
     * @fileOverview é˜Ÿåˆ—
     */
    define('widgets/queue',[
        'base',
        'uploader',
        'queue',
        'file',
        'lib/file',
        'runtime/client',
        'widgets/widget'
    ], function( Base, Uploader, Queue, WUFile, File, RuntimeClient ) {
    
        var $ = Base.$,
            rExt = /\.\w+$/,
            Status = WUFile.Status;
    
        return Uploader.register({
            name: 'queue',
    
            init: function( opts ) {
                var me = this,
                    deferred, len, i, item, arr, accept, runtime;
    
                if ( $.isPlainObject( opts.accept ) ) {
                    opts.accept = [ opts.accept ];
                }
    
                // acceptä¸­çš„ä¸­ç”ŸæˆåŒ¹é…æ­£åˆ™ã€‚
                if ( opts.accept ) {
                    arr = [];
    
                    for ( i = 0, len = opts.accept.length; i < len; i++ ) {
                        item = opts.accept[ i ].extensions;
                        item && arr.push( item );
                    }
    
                    if ( arr.length ) {
                        accept = '\\.' + arr.join(',')
                                .replace( /,/g, '$|\\.' )
                                .replace( /\*/g, '.*' ) + '$';
                    }
    
                    me.accept = new RegExp( accept, 'i' );
                }
    
                me.queue = new Queue();
                me.stats = me.queue.stats;
    
                // å¦‚æžœå½“å‰ä¸æ˜¯html5è¿è¡Œæ—¶ï¼Œé‚£å°±ç®—äº†ã€‚
                // ä¸æ‰§è¡ŒåŽç»­æ“ä½œ
                if ( this.request('predict-runtime-type') !== 'html5' ) {
                    return;
                }
    
                // åˆ›å»ºä¸€ä¸ª html5 è¿è¡Œæ—¶çš„ placeholder
                // ä»¥è‡³äºŽå¤–éƒ¨æ·»åŠ åŽŸç”Ÿ File å¯¹è±¡çš„æ—¶å€™èƒ½æ­£ç¡®åŒ…è£¹ä¸€ä¸‹ä¾› webuploader ä½¿ç”¨ã€‚
                deferred = Base.Deferred();
                this.placeholder = runtime = new RuntimeClient('Placeholder');
                runtime.connectRuntime({
                    runtimeOrder: 'html5'
                }, function() {
                    me._ruid = runtime.getRuid();
                    deferred.resolve();
                });
                return deferred.promise();
            },
    
    
            // ä¸ºäº†æ”¯æŒå¤–éƒ¨ç›´æŽ¥æ·»åŠ ä¸€ä¸ªåŽŸç”ŸFileå¯¹è±¡ã€‚
            _wrapFile: function( file ) {
                if ( !(file instanceof WUFile) ) {
    
                    if ( !(file instanceof File) ) {
                        if ( !this._ruid ) {
                            throw new Error('Can\'t add external files.');
                        }
                        file = new File( this._ruid, file );
                    }
    
                    file = new WUFile( file );
                }
    
                return file;
            },
    
            // åˆ¤æ–­æ–‡ä»¶æ˜¯å¦å¯ä»¥è¢«åŠ å…¥é˜Ÿåˆ—
            acceptFile: function( file ) {
                var invalid = !file || !file.size || this.accept &&
    
                        // å¦‚æžœåå­—ä¸­æœ‰åŽç¼€ï¼Œæ‰åšåŽç¼€ç™½åå•å¤„ç†ã€‚
                        rExt.exec( file.name ) && !this.accept.test( file.name );
    
                return !invalid;
            },
    
    
            /**
             * @event beforeFileQueued
             * @param {File} file Fileå¯¹è±¡
             * @description å½“æ–‡ä»¶è¢«åŠ å…¥é˜Ÿåˆ—ä¹‹å‰è§¦å‘ï¼Œæ­¤äº‹ä»¶çš„handlerè¿”å›žå€¼ä¸º`false`ï¼Œåˆ™æ­¤æ–‡ä»¶ä¸ä¼šè¢«æ·»åŠ è¿›å…¥é˜Ÿåˆ—ã€‚
             * @for  Uploader
             */
    
            /**
             * @event fileQueued
             * @param {File} file Fileå¯¹è±¡
             * @description å½“æ–‡ä»¶è¢«åŠ å…¥é˜Ÿåˆ—ä»¥åŽè§¦å‘ã€‚
             * @for  Uploader
             */
    
            _addFile: function( file ) {
                var me = this;
    
                file = me._wrapFile( file );
    
                // ä¸è¿‡ç±»åž‹åˆ¤æ–­å…è®¸ä¸å…è®¸ï¼Œå…ˆæ´¾é€ `beforeFileQueued`
                if ( !me.owner.trigger( 'beforeFileQueued', file ) ) {
                    return;
                }
    
                // ç±»åž‹ä¸åŒ¹é…ï¼Œåˆ™æ´¾é€é”™è¯¯äº‹ä»¶ï¼Œå¹¶è¿”å›žã€‚
                if ( !me.acceptFile( file ) ) {
                    me.owner.trigger( 'error', 'Q_TYPE_DENIED', file );
                    return;
                }
    
                me.queue.append( file );
                me.owner.trigger( 'fileQueued', file );
                return file;
            },
    
            getFile: function( fileId ) {
                return this.queue.getFile( fileId );
            },
    
            /**
             * @event filesQueued
             * @param {File} files æ•°ç»„ï¼Œå†…å®¹ä¸ºåŽŸå§‹File(lib/Fileï¼‰å¯¹è±¡ã€‚
             * @description å½“ä¸€æ‰¹æ–‡ä»¶æ·»åŠ è¿›é˜Ÿåˆ—ä»¥åŽè§¦å‘ã€‚
             * @for  Uploader
             */
            
            /**
             * @property {Boolean} [auto=false]
             * @namespace options
             * @for Uploader
             * @description è®¾ç½®ä¸º true åŽï¼Œä¸éœ€è¦æ‰‹åŠ¨è°ƒç”¨ä¸Šä¼ ï¼Œæœ‰æ–‡ä»¶é€‰æ‹©å³å¼€å§‹ä¸Šä¼ ã€‚
             * 
             */
    
            /**
             * @method addFiles
             * @grammar addFiles( file ) => undefined
             * @grammar addFiles( [file1, file2 ...] ) => undefined
             * @param {Array of File or File} [files] Files å¯¹è±¡ æ•°ç»„
             * @description æ·»åŠ æ–‡ä»¶åˆ°é˜Ÿåˆ—
             * @for  Uploader
             */
            addFile: function( files ) {
                var me = this;
    
                if ( !files.length ) {
                    files = [ files ];
                }
    
                files = $.map( files, function( file ) {
                    return me._addFile( file );
                });
    
                me.owner.trigger( 'filesQueued', files );
    
                if ( me.options.auto ) {
                    setTimeout(function() {
                        me.request('start-upload');
                    }, 20 );
                }
            },
    
            getStats: function() {
                return this.stats;
            },
    
            /**
             * @event fileDequeued
             * @param {File} file Fileå¯¹è±¡
             * @description å½“æ–‡ä»¶è¢«ç§»é™¤é˜Ÿåˆ—åŽè§¦å‘ã€‚
             * @for  Uploader
             */
    
             /**
             * @method removeFile
             * @grammar removeFile( file ) => undefined
             * @grammar removeFile( id ) => undefined
             * @grammar removeFile( file, true ) => undefined
             * @grammar removeFile( id, true ) => undefined
             * @param {File|id} file Fileå¯¹è±¡æˆ–è¿™Fileå¯¹è±¡çš„id
             * @description ç§»é™¤æŸä¸€æ–‡ä»¶, é»˜è®¤åªä¼šæ ‡è®°æ–‡ä»¶çŠ¶æ€ä¸ºå·²å–æ¶ˆï¼Œå¦‚æžœç¬¬äºŒä¸ªå‚æ•°ä¸º `true` åˆ™ä¼šä»Ž queue ä¸­ç§»é™¤ã€‚
             * @for  Uploader
             * @example
             *
             * $li.on('click', '.remove-this', function() {
             *     uploader.removeFile( file );
             * })
             */
            removeFile: function( file, remove ) {
                var me = this;
    
                file = file.id ? file : me.queue.getFile( file );
    
                this.request( 'cancel-file', file );
    
                if ( remove ) {
                    this.queue.removeFile( file );
                }
            },
    
            /**
             * @method getFiles
             * @grammar getFiles() => Array
             * @grammar getFiles( status1, status2, status... ) => Array
             * @description è¿”å›žæŒ‡å®šçŠ¶æ€çš„æ–‡ä»¶é›†åˆï¼Œä¸ä¼ å‚æ•°å°†è¿”å›žæ‰€æœ‰çŠ¶æ€çš„æ–‡ä»¶ã€‚
             * @for  Uploader
             * @example
             * console.log( uploader.getFiles() );    // => all files
             * console.log( uploader.getFiles('error') )    // => all error files.
             */
            getFiles: function() {
                return this.queue.getFiles.apply( this.queue, arguments );
            },
    
            fetchFile: function() {
                return this.queue.fetch.apply( this.queue, arguments );
            },
    
            /**
             * @method retry
             * @grammar retry() => undefined
             * @grammar retry( file ) => undefined
             * @description é‡è¯•ä¸Šä¼ ï¼Œé‡è¯•æŒ‡å®šæ–‡ä»¶ï¼Œæˆ–è€…ä»Žå‡ºé”™çš„æ–‡ä»¶å¼€å§‹é‡æ–°ä¸Šä¼ ã€‚
             * @for  Uploader
             * @example
             * function retry() {
             *     uploader.retry();
             * }
             */
            retry: function( file, noForceStart ) {
                var me = this,
                    files, i, len;
    
                if ( file ) {
                    file = file.id ? file : me.queue.getFile( file );
                    file.setStatus( Status.QUEUED );
                    noForceStart || me.request('start-upload');
                    return;
                }
    
                files = me.queue.getFiles( Status.ERROR );
                i = 0;
                len = files.length;
    
                for ( ; i < len; i++ ) {
                    file = files[ i ];
                    file.setStatus( Status.QUEUED );
                }
    
                me.request('start-upload');
            },
    
            /**
             * @method sort
             * @grammar sort( fn ) => undefined
             * @description æŽ’åºé˜Ÿåˆ—ä¸­çš„æ–‡ä»¶ï¼Œåœ¨ä¸Šä¼ ä¹‹å‰è°ƒæ•´å¯ä»¥æŽ§åˆ¶ä¸Šä¼ é¡ºåºã€‚
             * @for  Uploader
             */
            sortFiles: function() {
                return this.queue.sort.apply( this.queue, arguments );
            },
    
            /**
             * @event reset
             * @description å½“ uploader è¢«é‡ç½®çš„æ—¶å€™è§¦å‘ã€‚
             * @for  Uploader
             */
    
            /**
             * @method reset
             * @grammar reset() => undefined
             * @description é‡ç½®uploaderã€‚ç›®å‰åªé‡ç½®äº†é˜Ÿåˆ—ã€‚
             * @for  Uploader
             * @example
             * uploader.reset();
             */
            reset: function() {
                this.owner.trigger('reset');
                this.queue = new Queue();
                this.stats = this.queue.stats;
            },
    
            destroy: function() {
                this.reset();
                this.placeholder && this.placeholder.destroy();
            }
        });
    
    });
    /**
     * @fileOverview æ·»åŠ èŽ·å–Runtimeç›¸å…³ä¿¡æ¯çš„æ–¹æ³•ã€‚
     */
    define('widgets/runtime',[
        'uploader',
        'runtime/runtime',
        'widgets/widget'
    ], function( Uploader, Runtime ) {
    
        Uploader.support = function() {
            return Runtime.hasRuntime.apply( Runtime, arguments );
        };
    
        /**
         * @property {Object} [runtimeOrder=html5,flash]
         * @namespace options
         * @for Uploader
         * @description æŒ‡å®šè¿è¡Œæ—¶å¯åŠ¨é¡ºåºã€‚é»˜è®¤ä¼šæƒ³å°è¯• html5 æ˜¯å¦æ”¯æŒï¼Œå¦‚æžœæ”¯æŒåˆ™ä½¿ç”¨ html5, å¦åˆ™åˆ™ä½¿ç”¨ flash.
         *
         * å¯ä»¥å°†æ­¤å€¼è®¾ç½®æˆ `flash`ï¼Œæ¥å¼ºåˆ¶ä½¿ç”¨ flash è¿è¡Œæ—¶ã€‚
         */
    
        return Uploader.register({
            name: 'runtime',
    
            init: function() {
                if ( !this.predictRuntimeType() ) {
                    throw Error('Runtime Error');
                }
            },
    
            /**
             * é¢„æµ‹Uploaderå°†é‡‡ç”¨å“ªä¸ª`Runtime`
             * @grammar predictRuntimeType() => String
             * @method predictRuntimeType
             * @for  Uploader
             */
            predictRuntimeType: function() {
                var orders = this.options.runtimeOrder || Runtime.orders,
                    type = this.type,
                    i, len;
    
                if ( !type ) {
                    orders = orders.split( /\s*,\s*/g );
    
                    for ( i = 0, len = orders.length; i < len; i++ ) {
                        if ( Runtime.hasRuntime( orders[ i ] ) ) {
                            this.type = type = orders[ i ];
                            break;
                        }
                    }
                }
    
                return type;
            }
        });
    });
    /**
     * @fileOverview Transport
     */
    define('lib/transport',[
        'base',
        'runtime/client',
        'mediator'
    ], function( Base, RuntimeClient, Mediator ) {
    
        var $ = Base.$;
    
        function Transport( opts ) {
            var me = this;
    
            opts = me.options = $.extend( true, {}, Transport.options, opts || {} );
            RuntimeClient.call( this, 'Transport' );
    
            this._blob = null;
            this._formData = opts.formData || {};
            this._headers = opts.headers || {};
    
            this.on( 'progress', this._timeout );
            this.on( 'load error', function() {
                me.trigger( 'progress', 1 );
                clearTimeout( me._timer );
            });
        }
    
        Transport.options = {
            server: '',
            method: 'POST',
    
            // è·¨åŸŸæ—¶ï¼Œæ˜¯å¦å…è®¸æºå¸¦cookie, åªæœ‰html5 runtimeæ‰æœ‰æ•ˆ
            withCredentials: false,
            fileVal: 'file',
            timeout: 2 * 60 * 1000,    // 2åˆ†é’Ÿ
            formData: {},
            headers: {},
            sendAsBinary: false
        };
    
        $.extend( Transport.prototype, {
    
            // æ·»åŠ Blob, åªèƒ½æ·»åŠ ä¸€æ¬¡ï¼Œæœ€åŽä¸€æ¬¡æœ‰æ•ˆã€‚
            appendBlob: function( key, blob, filename ) {
                var me = this,
                    opts = me.options;
    
                if ( me.getRuid() ) {
                    me.disconnectRuntime();
                }
    
                // è¿žæŽ¥åˆ°blobå½’å±žçš„åŒä¸€ä¸ªruntime.
                me.connectRuntime( blob.ruid, function() {
                    me.exec('init');
                });
    
                me._blob = blob;
                opts.fileVal = key || opts.fileVal;
                opts.filename = filename || opts.filename;
            },
    
            // æ·»åŠ å…¶ä»–å­—æ®µ
            append: function( key, value ) {
                if ( typeof key === 'object' ) {
                    $.extend( this._formData, key );
                } else {
                    this._formData[ key ] = value;
                }
            },
    
            setRequestHeader: function( key, value ) {
                if ( typeof key === 'object' ) {
                    $.extend( this._headers, key );
                } else {
                    this._headers[ key ] = value;
                }
            },
    
            send: function( method ) {
                this.exec( 'send', method );
                this._timeout();
            },
    
            abort: function() {
                clearTimeout( this._timer );
                return this.exec('abort');
            },
    
            destroy: function() {
                this.trigger('destroy');
                this.off();
                this.exec('destroy');
                this.disconnectRuntime();
            },
    
            getResponse: function() {
                return this.exec('getResponse');
            },
    
            getResponseAsJson: function() {
                return this.exec('getResponseAsJson');
            },
    
            getStatus: function() {
                return this.exec('getStatus');
            },
    
            _timeout: function() {
                var me = this,
                    duration = me.options.timeout;
    
                if ( !duration ) {
                    return;
                }
    
                clearTimeout( me._timer );
                me._timer = setTimeout(function() {
                    me.abort();
                    me.trigger( 'error', 'timeout' );
                }, duration );
            }
    
        });
    
        // è®©Transportå…·å¤‡äº‹ä»¶åŠŸèƒ½ã€‚
        Mediator.installTo( Transport.prototype );
    
        return Transport;
    });
    /**
     * @fileOverview è´Ÿè´£æ–‡ä»¶ä¸Šä¼ ç›¸å…³ã€‚
     */
    define('widgets/upload',[
        'base',
        'uploader',
        'file',
        'lib/transport',
        'widgets/widget'
    ], function( Base, Uploader, WUFile, Transport ) {
    
        var $ = Base.$,
            isPromise = Base.isPromise,
            Status = WUFile.Status;
    
        // æ·»åŠ é»˜è®¤é…ç½®é¡¹
        $.extend( Uploader.options, {
    
    
            /**
             * @property {Boolean} [prepareNextFile=false]
             * @namespace options
             * @for Uploader
             * @description æ˜¯å¦å…è®¸åœ¨æ–‡ä»¶ä¼ è¾“æ—¶æå‰æŠŠä¸‹ä¸€ä¸ªæ–‡ä»¶å‡†å¤‡å¥½ã€‚
             * å¯¹äºŽä¸€ä¸ªæ–‡ä»¶çš„å‡†å¤‡å·¥ä½œæ¯”è¾ƒè€—æ—¶ï¼Œæ¯”å¦‚å›¾ç‰‡åŽ‹ç¼©ï¼Œmd5åºåˆ—åŒ–ã€‚
             * å¦‚æžœèƒ½æå‰åœ¨å½“å‰æ–‡ä»¶ä¼ è¾“æœŸå¤„ç†ï¼Œå¯ä»¥èŠ‚çœæ€»ä½“è€—æ—¶ã€‚
             */
            prepareNextFile: false,
    
            /**
             * @property {Boolean} [chunked=false]
             * @namespace options
             * @for Uploader
             * @description æ˜¯å¦è¦åˆ†ç‰‡å¤„ç†å¤§æ–‡ä»¶ä¸Šä¼ ã€‚
             */
            chunked: false,
    
            /**
             * @property {Boolean} [chunkSize=5242880]
             * @namespace options
             * @for Uploader
             * @description å¦‚æžœè¦åˆ†ç‰‡ï¼Œåˆ†å¤šå¤§ä¸€ç‰‡ï¼Ÿ é»˜è®¤å¤§å°ä¸º5M.
             */
            chunkSize: 40 * 1024 * 1024,
    
            /**
             * @property {Boolean} [chunkRetry=2]
             * @namespace options
             * @for Uploader
             * @description å¦‚æžœæŸä¸ªåˆ†ç‰‡ç”±äºŽç½‘ç»œé—®é¢˜å‡ºé”™ï¼Œå…è®¸è‡ªåŠ¨é‡ä¼ å¤šå°‘æ¬¡ï¼Ÿ
             */
            chunkRetry: 3,
    
            /**
             * @property {Boolean} [threads=3]
             * @namespace options
             * @for Uploader
             * @description ä¸Šä¼ å¹¶å‘æ•°ã€‚å…è®¸åŒæ—¶æœ€å¤§ä¸Šä¼ è¿›ç¨‹æ•°ã€‚
             */
            threads: 2,
    
    
            /**
             * @property {Object} [formData={}]
             * @namespace options
             * @for Uploader
             * @description æ–‡ä»¶ä¸Šä¼ è¯·æ±‚çš„å‚æ•°è¡¨ï¼Œæ¯æ¬¡å‘é€éƒ½ä¼šå‘é€æ­¤å¯¹è±¡ä¸­çš„å‚æ•°ã€‚
             */
            formData: {}
    
            /**
             * @property {Object} [fileVal='file']
             * @namespace options
             * @for Uploader
             * @description è®¾ç½®æ–‡ä»¶ä¸Šä¼ åŸŸçš„nameã€‚
             */
    
            /**
             * @property {Object} [method='POST']
             * @namespace options
             * @for Uploader
             * @description æ–‡ä»¶ä¸Šä¼ æ–¹å¼ï¼Œ`POST`æˆ–è€…`GET`ã€‚
             */
    
            /**
             * @property {Object} [sendAsBinary=false]
             * @namespace options
             * @for Uploader
             * @description æ˜¯å¦å·²äºŒè¿›åˆ¶çš„æµçš„æ–¹å¼å‘é€æ–‡ä»¶ï¼Œè¿™æ ·æ•´ä¸ªä¸Šä¼ å†…å®¹`php://input`éƒ½ä¸ºæ–‡ä»¶å†…å®¹ï¼Œ
             * å…¶ä»–å‚æ•°åœ¨$_GETæ•°ç»„ä¸­ã€‚
             */
        });
    
        // è´Ÿè´£å°†æ–‡ä»¶åˆ‡ç‰‡ã€‚
        function CuteFile( file, chunkSize ) {
            var pending = [],
                blob = file.source,
                total = blob.size,
                chunks = chunkSize ? Math.ceil( total / chunkSize ) : 1,
                start = 0,
                index = 0,
                len, api;
    
            api = {
                file: file,
    
                has: function() {
                    return !!pending.length;
                },
    
                shift: function() {
                    return pending.shift();
                },
    
                unshift: function( block ) {
                    pending.unshift( block );
                }
            };
    
            while ( index < chunks ) {
                len = Math.min( chunkSize, total - start );
    
                pending.push({
                    file: file,
                    start: start,
                    end: chunkSize ? (start + len) : total,
                    total: total,
                    chunks: chunks,
                    chunk: index++,
                    cuted: api
                });
                start += len;
            }
    
            file.blocks = pending.concat();
            file.remaning = pending.length;
    
            return api;
        }
    
        Uploader.register({
            name: 'upload',
    
            init: function() {
                var owner = this.owner,
                    me = this;
    
                this.runing = false;
                this.progress = false;
    
                owner
                    .on( 'startUpload', function() {
                        me.progress = true;
                    })
                    .on( 'uploadFinished', function() {
                        me.progress = false;
                    });
    
                // è®°å½•å½“å‰æ­£åœ¨ä¼ çš„æ•°æ®ï¼Œè·Ÿthreadsç›¸å…³
                this.pool = [];
    
                // ç¼“å­˜åˆ†å¥½ç‰‡çš„æ–‡ä»¶ã€‚
                this.stack = [];
    
                // ç¼“å­˜å³å°†ä¸Šä¼ çš„æ–‡ä»¶ã€‚
                this.pending = [];
    
                // è·Ÿè¸ªè¿˜æœ‰å¤šå°‘åˆ†ç‰‡åœ¨ä¸Šä¼ ä¸­ä½†æ˜¯æ²¡æœ‰å®Œæˆä¸Šä¼ ã€‚
                this.remaning = 0;
                this.__tick = Base.bindFn( this._tick, this );
    
                owner.on( 'uploadComplete', function( file ) {
    
                    // æŠŠå…¶ä»–å—å–æ¶ˆäº†ã€‚
                    file.blocks && $.each( file.blocks, function( _, v ) {
                        v.transport && (v.transport.abort(), v.transport.destroy());
                        delete v.transport;
                    });
    
                    delete file.blocks;
                    delete file.remaning;
                });
            },
    
            reset: function() {
                this.request( 'stop-upload', true );
                this.runing = false;
                this.pool = [];
                this.stack = [];
                this.pending = [];
                this.remaning = 0;
                this._trigged = false;
                this._promise = null;
            },
    
            /**
             * @event startUpload
             * @description å½“å¼€å§‹ä¸Šä¼ æµç¨‹æ—¶è§¦å‘ã€‚
             * @for  Uploader
             */
    
            /**
             * å¼€å§‹ä¸Šä¼ ã€‚æ­¤æ–¹æ³•å¯ä»¥ä»Žåˆå§‹çŠ¶æ€è°ƒç”¨å¼€å§‹ä¸Šä¼ æµç¨‹ï¼Œä¹Ÿå¯ä»¥ä»Žæš‚åœçŠ¶æ€è°ƒç”¨ï¼Œç»§ç»­ä¸Šä¼ æµç¨‹ã€‚
             *
             * å¯ä»¥æŒ‡å®šå¼€å§‹æŸä¸€ä¸ªæ–‡ä»¶ã€‚
             * @grammar upload() => undefined
             * @grammar upload( file | fileId) => undefined
             * @method upload
             * @for  Uploader
             */
            startUpload: function(file) {
                var me = this;
    
                // ç§»å‡ºinvalidçš„æ–‡ä»¶
                $.each( me.request( 'get-files', Status.INVALID ), function() {
                    me.request( 'remove-file', this );
                });
    
                // å¦‚æžœæŒ‡å®šäº†å¼€å§‹æŸä¸ªæ–‡ä»¶ï¼Œåˆ™åªå¼€å§‹æŒ‡å®šæ–‡ä»¶ã€‚
                if ( file ) {
                    file = file.id ? file : me.request( 'get-file', file );
    
                    if (file.getStatus() === Status.INTERRUPT) {
                        $.each( me.pool, function( _, v ) {
    
                            // ä¹‹å‰æš‚åœè¿‡ã€‚
                            if (v.file !== file) {
                                return;
                            }
    
                            v.transport && v.transport.send();
                        });
    
                        file.setStatus( Status.QUEUED );
                    } else if (file.getStatus() === Status.PROGRESS) {
                        return;
                    } else {
                        file.setStatus( Status.QUEUED );
                    }
                } else {
                    $.each( me.request( 'get-files', [ Status.INITED ] ), function() {
                        this.setStatus( Status.QUEUED );
                    });
                }
    
                if ( me.runing ) {
                    return;
                }
    
                me.runing = true;
    
                var files = [];
    
                // å¦‚æžœæœ‰æš‚åœçš„ï¼Œåˆ™ç»­ä¼ 
                $.each( me.pool, function( _, v ) {
                    var file = v.file;
    
                    if ( file.getStatus() === Status.INTERRUPT ) {
                        files.push(file);
                        me._trigged = false;
                        v.transport && v.transport.send();
                    }
                });
    
                var file;
                while ( (file = files.shift()) ) {
                    file.setStatus( Status.PROGRESS );
                }
    
                file || $.each( me.request( 'get-files',
                        Status.INTERRUPT ), function() {
                    this.setStatus( Status.PROGRESS );
                });
    
                me._trigged = false;
                Base.nextTick( me.__tick );
                me.owner.trigger('startUpload');
            },
    
            /**
             * @event stopUpload
             * @description å½“å¼€å§‹ä¸Šä¼ æµç¨‹æš‚åœæ—¶è§¦å‘ã€‚
             * @for  Uploader
             */
    
            /**
             * æš‚åœä¸Šä¼ ã€‚ç¬¬ä¸€ä¸ªå‚æ•°ä¸ºæ˜¯å¦ä¸­æ–­ä¸Šä¼ å½“å‰æ­£åœ¨ä¸Šä¼ çš„æ–‡ä»¶ã€‚
             *
             * å¦‚æžœç¬¬ä¸€ä¸ªå‚æ•°æ˜¯æ–‡ä»¶ï¼Œåˆ™åªæš‚åœæŒ‡å®šæ–‡ä»¶ã€‚
             * @grammar stop() => undefined
             * @grammar stop( true ) => undefined
             * @grammar stop( file ) => undefined
             * @method stop
             * @for  Uploader
             */
            stopUpload: function( file, interrupt ) {
                var me = this;
    
                if (file === true) {
                    interrupt = file;
                    file = null;
                }
    
                if ( me.runing === false ) {
                    return;
                }
    
                // å¦‚æžœåªæ˜¯æš‚åœæŸä¸ªæ–‡ä»¶ã€‚
                if ( file ) {
                    file = file.id ? file : me.request( 'get-file', file );
    
                    if ( file.getStatus() !== Status.PROGRESS &&
                            file.getStatus() !== Status.QUEUED ) {
                        return;
                    }
    
                    file.setStatus( Status.INTERRUPT );
                    $.each( me.pool, function( _, v ) {
    
                        // åª abort æŒ‡å®šçš„æ–‡ä»¶ã€‚
                        if (v.file !== file) {
                            return;
                        }
    
                        v.transport && v.transport.abort();
                        me._putback(v);
                        me._popBlock(v);
                    });
    
                    return Base.nextTick( me.__tick );
                }
    
                me.runing = false;
    
                if (this._promise && this._promise.file) {
                    this._promise.file.setStatus( Status.INTERRUPT );
                }
    
                interrupt && $.each( me.pool, function( _, v ) {
                    v.transport && v.transport.abort();
                    v.file.setStatus( Status.INTERRUPT );
                });
    
                me.owner.trigger('stopUpload');
            },
    
            /**
             * @method cancelFile
             * @grammar cancelFile( file ) => undefined
             * @grammar cancelFile( id ) => undefined
             * @param {File|id} file Fileå¯¹è±¡æˆ–è¿™Fileå¯¹è±¡çš„id
             * @description æ ‡è®°æ–‡ä»¶çŠ¶æ€ä¸ºå·²å–æ¶ˆ, åŒæ—¶å°†ä¸­æ–­æ–‡ä»¶ä¼ è¾“ã€‚
             * @for  Uploader
             * @example
             *
             * $li.on('click', '.remove-this', function() {
             *     uploader.cancelFile( file );
             * })
             */
            cancelFile: function( file ) {
                file = file.id ? file : this.request( 'get-file', file );
    
                // å¦‚æžœæ­£åœ¨ä¸Šä¼ ã€‚
                file.blocks && $.each( file.blocks, function( _, v ) {
                    var _tr = v.transport;
    
                    if ( _tr ) {
                        _tr.abort();
                        _tr.destroy();
                        delete v.transport;
                    }
                });
    
                file.setStatus( Status.CANCELLED );
                this.owner.trigger( 'fileDequeued', file );
            },
    
            /**
             * åˆ¤æ–­`Uplaode`ræ˜¯å¦æ­£åœ¨ä¸Šä¼ ä¸­ã€‚
             * @grammar isInProgress() => Boolean
             * @method isInProgress
             * @for  Uploader
             */
            isInProgress: function() {
                return !!this.progress;
            },
    
            _getStats: function() {
                return this.request('get-stats');
            },
    
            /**
             * æŽ‰è¿‡ä¸€ä¸ªæ–‡ä»¶ä¸Šä¼ ï¼Œç›´æŽ¥æ ‡è®°æŒ‡å®šæ–‡ä»¶ä¸ºå·²ä¸Šä¼ çŠ¶æ€ã€‚
             * @grammar skipFile( file ) => undefined
             * @method skipFile
             * @for  Uploader
             */
            skipFile: function( file, status ) {
                file = file.id ? file : this.request( 'get-file', file );
    
                file.setStatus( status || Status.COMPLETE );
                file.skipped = true;
    
                // å¦‚æžœæ­£åœ¨ä¸Šä¼ ã€‚
                file.blocks && $.each( file.blocks, function( _, v ) {
                    var _tr = v.transport;
    
                    if ( _tr ) {
                        _tr.abort();
                        _tr.destroy();
                        delete v.transport;
                    }
                });
    
                this.owner.trigger( 'uploadSkip', file );
            },
    
            /**
             * @event uploadFinished
             * @description å½“æ‰€æœ‰æ–‡ä»¶ä¸Šä¼ ç»“æŸæ—¶è§¦å‘ã€‚
             * @for  Uploader
             */
            _tick: function() {
                var me = this,
                    opts = me.options,
                    fn, val;
    
                // ä¸Šä¸€ä¸ªpromiseè¿˜æ²¡æœ‰ç»“æŸï¼Œåˆ™ç­‰å¾…å®ŒæˆåŽå†æ‰§è¡Œã€‚
                if ( me._promise ) {
                    return me._promise.always( me.__tick );
                }
    
                // è¿˜æœ‰ä½ç½®ï¼Œä¸”è¿˜æœ‰æ–‡ä»¶è¦å¤„ç†çš„è¯ã€‚
                if ( me.pool.length < opts.threads && (val = me._nextBlock()) ) {
                    me._trigged = false;
    
                    fn = function( val ) {
                        me._promise = null;
    
                        // æœ‰å¯èƒ½æ˜¯rejectè¿‡æ¥çš„ï¼Œæ‰€ä»¥è¦æ£€æµ‹valçš„ç±»åž‹ã€‚
                        val && val.file && me._startSend( val );
                        Base.nextTick( me.__tick );
                    };
    
                    me._promise = isPromise( val ) ? val.always( fn ) : fn( val );
    
                // æ²¡æœ‰è¦ä¸Šä¼ çš„äº†ï¼Œä¸”æ²¡æœ‰æ­£åœ¨ä¼ è¾“çš„äº†ã€‚
                } else if ( !me.remaning && !me._getStats().numOfQueue &&
                    !me._getStats().numofInterrupt ) {
                    me.runing = false;
    
                    me._trigged || Base.nextTick(function() {
                        me.owner.trigger('uploadFinished');
                    });
                    me._trigged = true;
                }
            },
    
            _putback: function(block) {
                var idx;
    
                block.cuted.unshift(block);
                idx = this.stack.indexOf(block.cuted);
    
                if (!~idx) {
                    this.stack.unshift(block.cuted);
                }
            },
    
            _getStack: function() {
                var i = 0,
                    act;
    
                while ( (act = this.stack[ i++ ]) ) {
                    if ( act.has() && act.file.getStatus() === Status.PROGRESS ) {
                        return act;
                    } else if (!act.has() ||
                            act.file.getStatus() !== Status.PROGRESS &&
                            act.file.getStatus() !== Status.INTERRUPT ) {
    
                        // æŠŠå·²ç»å¤„ç†å®Œäº†çš„ï¼Œæˆ–è€…ï¼ŒçŠ¶æ€ä¸ºéž progressï¼ˆä¸Šä¼ ä¸­ï¼‰ã€
                        // interuptï¼ˆæš‚åœä¸­ï¼‰ çš„ç§»é™¤ã€‚
                        this.stack.splice( --i, 1 );
                    }
                }
    
                return null;
            },
    
            _nextBlock: function() {
                var me = this,
                    opts = me.options,
                    act, next, done, preparing;
    
                // å¦‚æžœå½“å‰æ–‡ä»¶è¿˜æœ‰æ²¡æœ‰éœ€è¦ä¼ è¾“çš„ï¼Œåˆ™ç›´æŽ¥è¿”å›žå‰©ä¸‹çš„ã€‚
                if ( (act = this._getStack()) ) {
    
                    // æ˜¯å¦æå‰å‡†å¤‡ä¸‹ä¸€ä¸ªæ–‡ä»¶
                    if ( opts.prepareNextFile && !me.pending.length ) {
                        me._prepareNextFile();
                    }
    
                    return act.shift();
    
                // å¦åˆ™ï¼Œå¦‚æžœæ­£åœ¨è¿è¡Œï¼Œåˆ™å‡†å¤‡ä¸‹ä¸€ä¸ªæ–‡ä»¶ï¼Œå¹¶ç­‰å¾…å®ŒæˆåŽè¿”å›žä¸‹ä¸ªåˆ†ç‰‡ã€‚
                } else if ( me.runing ) {
    
                    // å¦‚æžœç¼“å­˜ä¸­æœ‰ï¼Œåˆ™ç›´æŽ¥åœ¨ç¼“å­˜ä¸­å–ï¼Œæ²¡æœ‰åˆ™åŽ»queueä¸­å–ã€‚
                    if ( !me.pending.length && me._getStats().numOfQueue ) {
                        me._prepareNextFile();
                    }
    
                    next = me.pending.shift();
                    done = function( file ) {
                        if ( !file ) {
                            return null;
                        }
    
                        act = CuteFile( file, opts.chunked ? opts.chunkSize : 0 );
                        me.stack.push(act);
                        return act.shift();
                    };
    
                    // æ–‡ä»¶å¯èƒ½è¿˜åœ¨prepareä¸­ï¼Œä¹Ÿæœ‰å¯èƒ½å·²ç»å®Œå…¨å‡†å¤‡å¥½äº†ã€‚
                    if ( isPromise( next) ) {
                        preparing = next.file;
                        next = next[ next.pipe ? 'pipe' : 'then' ]( done );
                        next.file = preparing;
                        return next;
                    }
    
                    return done( next );
                }
            },
    
    
            /**
             * @event uploadStart
             * @param {File} file Fileå¯¹è±¡
             * @description æŸä¸ªæ–‡ä»¶å¼€å§‹ä¸Šä¼ å‰è§¦å‘ï¼Œä¸€ä¸ªæ–‡ä»¶åªä¼šè§¦å‘ä¸€æ¬¡ã€‚
             * @for  Uploader
             */
            _prepareNextFile: function() {
                var me = this,
                    file = me.request('fetch-file'),
                    pending = me.pending,
                    promise;
    
                if ( file ) {
                    promise = me.request( 'before-send-file', file, function() {
    
                        // æœ‰å¯èƒ½æ–‡ä»¶è¢«skipæŽ‰äº†ã€‚æ–‡ä»¶è¢«skipæŽ‰åŽï¼ŒçŠ¶æ€å‘å®šä¸æ˜¯Queued.
                        if ( file.getStatus() === Status.PROGRESS ||
                            file.getStatus() === Status.INTERRUPT ) {
                            return file;
                        }
    
                        return me._finishFile( file );
                    });
    
                    me.owner.trigger( 'uploadStart', file );
                    file.setStatus( Status.PROGRESS );
    
                    promise.file = file;
    
                    // å¦‚æžœè¿˜åœ¨pendingä¸­ï¼Œåˆ™æ›¿æ¢æˆæ–‡ä»¶æœ¬èº«ã€‚
                    promise.done(function() {
                        var idx = $.inArray( promise, pending );
    
                        ~idx && pending.splice( idx, 1, file );
                    });
    
                    // befeore-send-fileçš„é’©å­å°±æœ‰é”™è¯¯å‘ç”Ÿã€‚
                    promise.fail(function( reason ) {
                        file.setStatus( Status.ERROR, reason );
                        me.owner.trigger( 'uploadError', file, reason );
                        me.owner.trigger( 'uploadComplete', file );
                    });
    
                    pending.push( promise );
                }
            },
    
            // è®©å‡ºä½ç½®äº†ï¼Œå¯ä»¥è®©å…¶ä»–åˆ†ç‰‡å¼€å§‹ä¸Šä¼ 
            _popBlock: function( block ) {
                var idx = $.inArray( block, this.pool );
    
                this.pool.splice( idx, 1 );
                block.file.remaning--;
                this.remaning--;
            },
    
            // å¼€å§‹ä¸Šä¼ ï¼Œå¯ä»¥è¢«æŽ‰è¿‡ã€‚å¦‚æžœpromiseè¢«rejectäº†ï¼Œåˆ™è¡¨ç¤ºè·³è¿‡æ­¤åˆ†ç‰‡ã€‚
            _startSend: function( block ) {
                var me = this,
                    file = block.file,
                    promise;
    
                // æœ‰å¯èƒ½åœ¨ before-send-file çš„ promise æœŸé—´æ”¹å˜äº†æ–‡ä»¶çŠ¶æ€ã€‚
                // å¦‚ï¼šæš‚åœï¼Œå–æ¶ˆ
                // æˆ‘ä»¬ä¸èƒ½ä¸­æ–­ promise, ä½†æ˜¯å¯ä»¥åœ¨ promise å®ŒåŽï¼Œä¸åšä¸Šä¼ æ“ä½œã€‚
                if ( file.getStatus() !== Status.PROGRESS ) {
    
                    // å¦‚æžœæ˜¯ä¸­æ–­ï¼Œåˆ™è¿˜éœ€è¦æ”¾å›žåŽ»ã€‚
                    if (file.getStatus() === Status.INTERRUPT) {
                        me._putback(block);
                    }
    
                    return;
                }
    
                me.pool.push( block );
                me.remaning++;
    
                // å¦‚æžœæ²¡æœ‰åˆ†ç‰‡ï¼Œåˆ™ç›´æŽ¥ä½¿ç”¨åŽŸå§‹çš„ã€‚
                // ä¸ä¼šä¸¢å¤±content-typeä¿¡æ¯ã€‚
                block.blob = block.chunks === 1 ? file.source :
                        file.source.slice( block.start, block.end );
    
                // hook, æ¯ä¸ªåˆ†ç‰‡å‘é€ä¹‹å‰å¯èƒ½è¦åšäº›å¼‚æ­¥çš„äº‹æƒ…ã€‚
                promise = me.request( 'before-send', block, function() {
    
                    // æœ‰å¯èƒ½æ–‡ä»¶å·²ç»ä¸Šä¼ å‡ºé”™äº†ï¼Œæ‰€ä»¥ä¸éœ€è¦å†ä¼ è¾“äº†ã€‚
                    if ( file.getStatus() === Status.PROGRESS ) {
                        me._doSend( block );
                    } else {
                        me._popBlock( block );
                        Base.nextTick( me.__tick );
                    }
                });
    
                // å¦‚æžœä¸ºfailäº†ï¼Œåˆ™è·³è¿‡æ­¤åˆ†ç‰‡ã€‚
                promise.fail(function() {
                    if ( file.remaning === 1 ) {
                        me._finishFile( file ).always(function() {
                            block.percentage = 1;
                            me._popBlock( block );
                            me.owner.trigger( 'uploadComplete', file );
                            Base.nextTick( me.__tick );
                        });
                    } else {
                        block.percentage = 1;
                        me.updateFileProgress( file );
                        me._popBlock( block );
                        Base.nextTick( me.__tick );
                    }
                });
            },
    
    
            /**
             * @event uploadBeforeSend
             * @param {Object} object
             * @param {Object} data é»˜è®¤çš„ä¸Šä¼ å‚æ•°ï¼Œå¯ä»¥æ‰©å±•æ­¤å¯¹è±¡æ¥æŽ§åˆ¶ä¸Šä¼ å‚æ•°ã€‚
             * @param {Object} headers å¯ä»¥æ‰©å±•æ­¤å¯¹è±¡æ¥æŽ§åˆ¶ä¸Šä¼ å¤´éƒ¨ã€‚
             * @description å½“æŸä¸ªæ–‡ä»¶çš„åˆ†å—åœ¨å‘é€å‰è§¦å‘ï¼Œä¸»è¦ç”¨æ¥è¯¢é—®æ˜¯å¦è¦æ·»åŠ é™„å¸¦å‚æ•°ï¼Œå¤§æ–‡ä»¶åœ¨å¼€èµ·åˆ†ç‰‡ä¸Šä¼ çš„å‰æä¸‹æ­¤äº‹ä»¶å¯èƒ½ä¼šè§¦å‘å¤šæ¬¡ã€‚
             * @for  Uploader
             */
    
            /**
             * @event uploadAccept
             * @param {Object} object
             * @param {Object} ret æœåŠ¡ç«¯çš„è¿”å›žæ•°æ®ï¼Œjsonæ ¼å¼ï¼Œå¦‚æžœæœåŠ¡ç«¯ä¸æ˜¯jsonæ ¼å¼ï¼Œä»Žret._rawä¸­å–æ•°æ®ï¼Œè‡ªè¡Œè§£æžã€‚
             * @description å½“æŸä¸ªæ–‡ä»¶ä¸Šä¼ åˆ°æœåŠ¡ç«¯å“åº”åŽï¼Œä¼šæ´¾é€æ­¤äº‹ä»¶æ¥è¯¢é—®æœåŠ¡ç«¯å“åº”æ˜¯å¦æœ‰æ•ˆã€‚å¦‚æžœæ­¤äº‹ä»¶handlerè¿”å›žå€¼ä¸º`false`, åˆ™æ­¤æ–‡ä»¶å°†æ´¾é€`server`ç±»åž‹çš„`uploadError`äº‹ä»¶ã€‚
             * @for  Uploader
             */
    
            /**
             * @event uploadProgress
             * @param {File} file Fileå¯¹è±¡
             * @param {Number} percentage ä¸Šä¼ è¿›åº¦
             * @description ä¸Šä¼ è¿‡ç¨‹ä¸­è§¦å‘ï¼Œæºå¸¦ä¸Šä¼ è¿›åº¦ã€‚
             * @for  Uploader
             */
    
    
            /**
             * @event uploadError
             * @param {File} file Fileå¯¹è±¡
             * @param {String} reason å‡ºé”™çš„code
             * @description å½“æ–‡ä»¶ä¸Šä¼ å‡ºé”™æ—¶è§¦å‘ã€‚
             * @for  Uploader
             */
    
            /**
             * @event uploadSuccess
             * @param {File} file Fileå¯¹è±¡
             * @param {Object} response æœåŠ¡ç«¯è¿”å›žçš„æ•°æ®
             * @description å½“æ–‡ä»¶ä¸Šä¼ æˆåŠŸæ—¶è§¦å‘ã€‚
             * @for  Uploader
             */
    
            /**
             * @event uploadComplete
             * @param {File} [file] Fileå¯¹è±¡
             * @description ä¸ç®¡æˆåŠŸæˆ–è€…å¤±è´¥ï¼Œæ–‡ä»¶ä¸Šä¼ å®Œæˆæ—¶è§¦å‘ã€‚
             * @for  Uploader
             */
    
            // åšä¸Šä¼ æ“ä½œã€‚
            _doSend: function( block ) {
                var me = this,
                    owner = me.owner,
                    opts = me.options,
                    file = block.file,
                    tr = new Transport( opts ),
                    data = $.extend({}, opts.formData ),
                    headers = $.extend({}, opts.headers ),
                    requestAccept, ret;
    
                block.transport = tr;
    
                tr.on( 'destroy', function() {
                    delete block.transport;
                    me._popBlock( block );
                    Base.nextTick( me.__tick );
                });
    
                // å¹¿æ’­ä¸Šä¼ è¿›åº¦ã€‚ä»¥æ–‡ä»¶ä¸ºå•ä½ã€‚
                tr.on( 'progress', function( percentage ) {
                    block.percentage = percentage;
                    me.updateFileProgress( file );
                });
    
                // ç”¨æ¥è¯¢é—®ï¼Œæ˜¯å¦è¿”å›žçš„ç»“æžœæ˜¯æœ‰é”™è¯¯çš„ã€‚
                requestAccept = function( reject ) {
                    var fn;
    
                    ret = tr.getResponseAsJson() || {};
                    ret._raw = tr.getResponse();
                    fn = function( value ) {
                        reject = value;
                    };
    
                    // æœåŠ¡ç«¯å“åº”äº†ï¼Œä¸ä»£è¡¨æˆåŠŸäº†ï¼Œè¯¢é—®æ˜¯å¦å“åº”æ­£ç¡®ã€‚
                    if ( !owner.trigger( 'uploadAccept', block, ret, fn ) ) {
                        reject = reject || 'server';
                    }
    
                    return reject;
                };
    
                // å°è¯•é‡è¯•ï¼Œç„¶åŽå¹¿æ’­æ–‡ä»¶ä¸Šä¼ å‡ºé”™ã€‚
                tr.on( 'error', function( type, flag ) {
                    block.retried = block.retried || 0;
    
                    // è‡ªåŠ¨é‡è¯•
                    if ( block.chunks > 1 && ~'http,abort'.indexOf( type ) &&
                            block.retried < opts.chunkRetry ) {
    
                        block.retried++;
                        tr.send();
    
                    } else {
    
                        // http status 500 ~ 600
                        if ( !flag && type === 'server' ) {
                            type = requestAccept( type );
                        }
    
                        file.setStatus( Status.ERROR, type );
                        owner.trigger( 'uploadError', file, type );
                        owner.trigger( 'uploadComplete', file );
                    }
                });
    
                // ä¸Šä¼ æˆåŠŸ
                tr.on( 'load', function() {
                    var reason;
    
                    // å¦‚æžœéžé¢„æœŸï¼Œè½¬å‘ä¸Šä¼ å‡ºé”™ã€‚
                    if ( (reason = requestAccept()) ) {
                        tr.trigger( 'error', reason, true );
                        return;
                    }
    
                    // å…¨éƒ¨ä¸Šä¼ å®Œæˆã€‚
                    if ( file.remaning === 1 ) {
                        me._finishFile( file, ret );
                    } else {
                        tr.destroy();
                    }
                });
    
                // é…ç½®é»˜è®¤çš„ä¸Šä¼ å­—æ®µã€‚
                data = $.extend( data, {
                    id: file.id,
                    name: file.name,
                    type: file.type,
                    lastModifiedDate: file.lastModifiedDate,
                    size: file.size
                });
    
                block.chunks > 1 && $.extend( data, {
                    chunks: block.chunks,
                    chunk: block.chunk
                });
    
                // åœ¨å‘é€ä¹‹é—´å¯ä»¥æ·»åŠ å­—æ®µä»€ä¹ˆçš„ã€‚ã€‚ã€‚
                // å¦‚æžœé»˜è®¤çš„å­—æ®µä¸å¤Ÿä½¿ç”¨ï¼Œå¯ä»¥é€šè¿‡ç›‘å¬æ­¤äº‹ä»¶æ¥æ‰©å±•
                owner.trigger( 'uploadBeforeSend', block, data, headers );
    
                // å¼€å§‹å‘é€ã€‚
                tr.appendBlob( opts.fileVal, block.blob, file.name );
                tr.append( data );
                tr.setRequestHeader( headers );
                tr.send();
            },
    
            // å®Œæˆä¸Šä¼ ã€‚
            _finishFile: function( file, ret, hds ) {
                var owner = this.owner;
    
                return owner
                        .request( 'after-send-file', arguments, function() {
                            file.setStatus( Status.COMPLETE );
                            owner.trigger( 'uploadSuccess', file, ret, hds );
                        })
                        .fail(function( reason ) {
    
                            // å¦‚æžœå¤–éƒ¨å·²ç»æ ‡è®°ä¸ºinvalidä»€ä¹ˆçš„ï¼Œä¸å†æ”¹çŠ¶æ€ã€‚
                            if ( file.getStatus() === Status.PROGRESS ) {
                                file.setStatus( Status.ERROR, reason );
                            }
    
                            owner.trigger( 'uploadError', file, reason );
                        })
                        .always(function() {
                            owner.trigger( 'uploadComplete', file );
                        });
            },
    
            updateFileProgress: function(file) {
                var totalPercent = 0,
                    uploaded = 0;
    
                if (!file.blocks) {
                    return;
                }
    
                $.each( file.blocks, function( _, v ) {
                    uploaded += (v.percentage || 0) * (v.end - v.start);
                });
    
                totalPercent = uploaded / file.size;
                this.owner.trigger( 'uploadProgress', file, totalPercent || 0 );
            }
    
        });
    });
    /**
     * @fileOverview æ—¥å¿—ç»„ä»¶ï¼Œä¸»è¦ç”¨æ¥æ”¶é›†é”™è¯¯ä¿¡æ¯ï¼Œå¯ä»¥å¸®åŠ© webuploader æ›´å¥½çš„å®šä½é—®é¢˜å’Œå‘å±•ã€‚
     *
     * å¦‚æžœæ‚¨ä¸æƒ³è¦å¯ç”¨æ­¤åŠŸèƒ½ï¼Œè¯·åœ¨æ‰“åŒ…çš„æ—¶å€™åŽ»æŽ‰ log æ¨¡å—ã€‚
     *
     * æˆ–è€…å¯ä»¥åœ¨åˆå§‹åŒ–çš„æ—¶å€™é€šè¿‡ options.disableWidgets å±žæ€§ç¦ç”¨ã€‚
     *
     * å¦‚ï¼š
     * WebUploader.create({
     *     ...
     *
     *     disableWidgets: 'log',
     *
     *     ...
     * })
     */
    define('widgets/log',[
        'base',
        'uploader',
        'widgets/widget'
    ], function( Base, Uploader ) {
        var $ = Base.$,
            logUrl = ' http://static.tieba.baidu.com/tb/pms/img/st.gif??',
            product = (location.hostname || location.host || 'protected').toLowerCase(),
    
            // åªé’ˆå¯¹ baidu å†…éƒ¨äº§å“ç”¨æˆ·åšç»Ÿè®¡åŠŸèƒ½ã€‚
            enable = product && /baidu/i.exec(product),
            base;
    
        if (!enable) {
            return;
        }
    
        base = {
            dv: 3,
            master: 'webuploader',
            online: /test/.exec(product) ? 0 : 1,
            module: '',
            product: product,
            type: 0
        };
    
        function send(data) {
            var obj = $.extend({}, base, data),
                url = logUrl.replace(/^(.*)\?/, '$1' + $.param( obj )),
                image = new Image();
    
            image.src = url;
        }
    
        return Uploader.register({
            name: 'log',
    
            init: function() {
                var owner = this.owner,
                    count = 0,
                    size = 0;
    
                owner
                    .on('error', function(code) {
                        send({
                            type: 2,
                            c_error_code: code
                        });
                    })
                    .on('uploadError', function(file, reason) {
                        send({
                            type: 2,
                            c_error_code: 'UPLOAD_ERROR',
                            c_reason: '' + reason
                        });
                    })
                    .on('uploadComplete', function(file) {
                        count++;
                        size += file.size;
                    }).
                    on('uploadFinished', function() {
                        send({
                            c_count: count,
                            c_size: size
                        });
                        count = size = 0;
                    });
    
                send({
                    c_usage: 1
                });
            }
        });
    });
    /**
     * @fileOverview Runtimeç®¡ç†å™¨ï¼Œè´Ÿè´£Runtimeçš„é€‰æ‹©, è¿žæŽ¥
     */
    define('runtime/compbase',[],function() {
    
        function CompBase( owner, runtime ) {
    
            this.owner = owner;
            this.options = owner.options;
    
            this.getRuntime = function() {
                return runtime;
            };
    
            this.getRuid = function() {
                return runtime.uid;
            };
    
            this.trigger = function() {
                return owner.trigger.apply( owner, arguments );
            };
        }
    
        return CompBase;
    });
    /**
     * @fileOverview Html5Runtime
     */
    define('runtime/html5/runtime',[
        'base',
        'runtime/runtime',
        'runtime/compbase'
    ], function( Base, Runtime, CompBase ) {
    
        var type = 'html5',
            components = {};
    
        function Html5Runtime() {
            var pool = {},
                me = this,
                destroy = this.destroy;
    
            Runtime.apply( me, arguments );
            me.type = type;
    
    
            // è¿™ä¸ªæ–¹æ³•çš„è°ƒç”¨è€…ï¼Œå®žé™…ä¸Šæ˜¯RuntimeClient
            me.exec = function( comp, fn/*, args...*/) {
                var client = this,
                    uid = client.uid,
                    args = Base.slice( arguments, 2 ),
                    instance;
    
                if ( components[ comp ] ) {
                    instance = pool[ uid ] = pool[ uid ] ||
                            new components[ comp ]( client, me );
    
                    if ( instance[ fn ] ) {
                        return instance[ fn ].apply( instance, args );
                    }
                }
            };
    
            me.destroy = function() {
                // @todo åˆ é™¤æ± å­ä¸­çš„æ‰€æœ‰å®žä¾‹
                return destroy && destroy.apply( this, arguments );
            };
        }
    
        Base.inherits( Runtime, {
            constructor: Html5Runtime,
    
            // ä¸éœ€è¦è¿žæŽ¥å…¶ä»–ç¨‹åºï¼Œç›´æŽ¥æ‰§è¡Œcallback
            init: function() {
                var me = this;
                setTimeout(function() {
                    me.trigger('ready');
                }, 1 );
            }
    
        });
    
        // æ³¨å†ŒComponents
        Html5Runtime.register = function( name, component ) {
            var klass = components[ name ] = Base.inherits( CompBase, component );
            return klass;
        };
    
        // æ³¨å†Œhtml5è¿è¡Œæ—¶ã€‚
        // åªæœ‰åœ¨æ”¯æŒçš„å‰æä¸‹æ³¨å†Œã€‚
        if ( window.Blob && window.FileReader && window.DataView ) {
            Runtime.addRuntime( type, Html5Runtime );
        }
    
        return Html5Runtime;
    });
    /**
     * @fileOverview Blob Htmlå®žçŽ°
     */
    define('runtime/html5/blob',[
        'runtime/html5/runtime',
        'lib/blob'
    ], function( Html5Runtime, Blob ) {
    
        return Html5Runtime.register( 'Blob', {
            slice: function( start, end ) {
                var blob = this.owner.source,
                    slice = blob.slice || blob.webkitSlice || blob.mozSlice;
    
                blob = slice.call( blob, start, end );
    
                return new Blob( this.getRuid(), blob );
            }
        });
    });
    /**
     * @fileOverview FilePicker
     */
    define('runtime/html5/filepicker',[
        'base',
        'runtime/html5/runtime'
    ], function( Base, Html5Runtime ) {
    
        var $ = Base.$;
    
        return Html5Runtime.register( 'FilePicker', {
            init: function() {
                var container = this.getRuntime().getContainer(),
                    me = this,
                    owner = me.owner,
                    opts = me.options,
                    label = this.label = $( document.createElement('label') ),
                    input =  this.input = $( document.createElement('input') ),
                    arr, i, len, mouseHandler;
    
                input.attr( 'type', 'file' );
                input.attr( 'name', opts.name );
                input.addClass('webuploader-element-invisible');
    
                label.on( 'click', function() {
                    input.trigger('click');
                });
    
                label.css({
                    opacity: 0,
                    width: '100%',
                    height: '100%',
                    display: 'block',
                    cursor: 'pointer',
                    background: '#ffffff'
                });
    
                if ( opts.multiple ) {
                    input.attr( 'multiple', 'multiple' );
                }
    
                // @todo Firefoxä¸æ”¯æŒå•ç‹¬æŒ‡å®šåŽç¼€
                if ( opts.accept && opts.accept.length > 0 ) {
                    arr = [];
    
                    for ( i = 0, len = opts.accept.length; i < len; i++ ) {
                        arr.push( opts.accept[ i ].mimeTypes );
                    }
    
                    input.attr( 'accept', arr.join(',') );
                }
    
                container.append( input );
                container.append( label );
    
                mouseHandler = function( e ) {
                    owner.trigger( e.type );
                };
    
                input.on( 'change', function( e ) {
                    var fn = arguments.callee,
                        clone;
    
                    me.files = e.target.files;
    
                    // reset input
                    clone = this.cloneNode( true );
                    clone.value = null;
                    this.parentNode.replaceChild( clone, this );
    
                    input.off();
                    input = $( clone ).on( 'change', fn )
                            .on( 'mouseenter mouseleave', mouseHandler );
    
                    owner.trigger('change');
                });
    
                label.on( 'mouseenter mouseleave', mouseHandler );
    
            },
    
    
            getFiles: function() {
                return this.files;
            },
    
            destroy: function() {
                this.input.off();
                this.label.off();
            }
        });
    });
    /**
     * Terms:
     *
     * Uint8Array, FileReader, BlobBuilder, atob, ArrayBuffer
     * @fileOverview ImageæŽ§ä»¶
     */
    define('runtime/html5/util',[
        'base'
    ], function( Base ) {
    
        var urlAPI = window.createObjectURL && window ||
                window.URL && URL.revokeObjectURL && URL ||
                window.webkitURL,
            createObjectURL = Base.noop,
            revokeObjectURL = createObjectURL;
    
        if ( urlAPI ) {
    
            // æ›´å®‰å…¨çš„æ–¹å¼è°ƒç”¨ï¼Œæ¯”å¦‚androidé‡Œé¢å°±èƒ½æŠŠcontextæ”¹æˆå…¶ä»–çš„å¯¹è±¡ã€‚
            createObjectURL = function() {
                return urlAPI.createObjectURL.apply( urlAPI, arguments );
            };
    
            revokeObjectURL = function() {
                return urlAPI.revokeObjectURL.apply( urlAPI, arguments );
            };
        }
    
        return {
            createObjectURL: createObjectURL,
            revokeObjectURL: revokeObjectURL,
    
            dataURL2Blob: function( dataURI ) {
                var byteStr, intArray, ab, i, mimetype, parts;
    
                parts = dataURI.split(',');
    
                if ( ~parts[ 0 ].indexOf('base64') ) {
                    byteStr = atob( parts[ 1 ] );
                } else {
                    byteStr = decodeURIComponent( parts[ 1 ] );
                }
    
                ab = new ArrayBuffer( byteStr.length );
                intArray = new Uint8Array( ab );
    
                for ( i = 0; i < byteStr.length; i++ ) {
                    intArray[ i ] = byteStr.charCodeAt( i );
                }
    
                mimetype = parts[ 0 ].split(':')[ 1 ].split(';')[ 0 ];
    
                return this.arrayBufferToBlob( ab, mimetype );
            },
    
            dataURL2ArrayBuffer: function( dataURI ) {
                var byteStr, intArray, i, parts;
    
                parts = dataURI.split(',');
    
                if ( ~parts[ 0 ].indexOf('base64') ) {
                    byteStr = atob( parts[ 1 ] );
                } else {
                    byteStr = decodeURIComponent( parts[ 1 ] );
                }
    
                intArray = new Uint8Array( byteStr.length );
    
                for ( i = 0; i < byteStr.length; i++ ) {
                    intArray[ i ] = byteStr.charCodeAt( i );
                }
    
                return intArray.buffer;
            },
    
            arrayBufferToBlob: function( buffer, type ) {
                var builder = window.BlobBuilder || window.WebKitBlobBuilder,
                    bb;
    
                // androidä¸æ”¯æŒç›´æŽ¥new Blob, åªèƒ½å€ŸåŠ©blobbuilder.
                if ( builder ) {
                    bb = new builder();
                    bb.append( buffer );
                    return bb.getBlob( type );
                }
    
                return new Blob([ buffer ], type ? { type: type } : {} );
            },
    
            // æŠ½å‡ºæ¥ä¸»è¦æ˜¯ä¸ºäº†è§£å†³androidä¸‹é¢canvas.toDataUrlä¸æ”¯æŒjpeg.
            // ä½ å¾—åˆ°çš„ç»“æžœæ˜¯png.
            canvasToDataUrl: function( canvas, type, quality ) {
                return canvas.toDataURL( type, quality / 100 );
            },
    
            // imagemeatä¼šå¤å†™è¿™ä¸ªæ–¹æ³•ï¼Œå¦‚æžœç”¨æˆ·é€‰æ‹©åŠ è½½é‚£ä¸ªæ–‡ä»¶äº†çš„è¯ã€‚
            parseMeta: function( blob, callback ) {
                callback( false, {});
            },
    
            // imagemeatä¼šå¤å†™è¿™ä¸ªæ–¹æ³•ï¼Œå¦‚æžœç”¨æˆ·é€‰æ‹©åŠ è½½é‚£ä¸ªæ–‡ä»¶äº†çš„è¯ã€‚
            updateImageHead: function( data ) {
                return data;
            }
        };
    });
    /**
     * Terms:
     *
     * Uint8Array, FileReader, BlobBuilder, atob, ArrayBuffer
     * @fileOverview ImageæŽ§ä»¶
     */
    define('runtime/html5/imagemeta',[
        'runtime/html5/util'
    ], function( Util ) {
    
        var api;
    
        api = {
            parsers: {
                0xffe1: []
            },
    
            maxMetaDataSize: 262144,
    
            parse: function( blob, cb ) {
                var me = this,
                    fr = new FileReader();
    
                fr.onload = function() {
                    cb( false, me._parse( this.result ) );
                    fr = fr.onload = fr.onerror = null;
                };
    
                fr.onerror = function( e ) {
                    cb( e.message );
                    fr = fr.onload = fr.onerror = null;
                };
    
                blob = blob.slice( 0, me.maxMetaDataSize );
                fr.readAsArrayBuffer( blob.getSource() );
            },
    
            _parse: function( buffer, noParse ) {
                if ( buffer.byteLength < 6 ) {
                    return;
                }
    
                var dataview = new DataView( buffer ),
                    offset = 2,
                    maxOffset = dataview.byteLength - 4,
                    headLength = offset,
                    ret = {},
                    markerBytes, markerLength, parsers, i;
    
                if ( dataview.getUint16( 0 ) === 0xffd8 ) {
    
                    while ( offset < maxOffset ) {
                        markerBytes = dataview.getUint16( offset );
    
                        if ( markerBytes >= 0xffe0 && markerBytes <= 0xffef ||
                                markerBytes === 0xfffe ) {
    
                            markerLength = dataview.getUint16( offset + 2 ) + 2;
    
                            if ( offset + markerLength > dataview.byteLength ) {
                                break;
                            }
    
                            parsers = api.parsers[ markerBytes ];
    
                            if ( !noParse && parsers ) {
                                for ( i = 0; i < parsers.length; i += 1 ) {
                                    parsers[ i ].call( api, dataview, offset,
                                            markerLength, ret );
                                }
                            }
    
                            offset += markerLength;
                            headLength = offset;
                        } else {
                            break;
                        }
                    }
    
                    if ( headLength > 6 ) {
                        if ( buffer.slice ) {
                            ret.imageHead = buffer.slice( 2, headLength );
                        } else {
                            // Workaround for IE10, which does not yet
                            // support ArrayBuffer.slice:
                            ret.imageHead = new Uint8Array( buffer )
                                    .subarray( 2, headLength );
                        }
                    }
                }
    
                return ret;
            },
    
            updateImageHead: function( buffer, head ) {
                var data = this._parse( buffer, true ),
                    buf1, buf2, bodyoffset;
    
    
                bodyoffset = 2;
                if ( data.imageHead ) {
                    bodyoffset = 2 + data.imageHead.byteLength;
                }
    
                if ( buffer.slice ) {
                    buf2 = buffer.slice( bodyoffset );
                } else {
                    buf2 = new Uint8Array( buffer ).subarray( bodyoffset );
                }
    
                buf1 = new Uint8Array( head.byteLength + 2 + buf2.byteLength );
    
                buf1[ 0 ] = 0xFF;
                buf1[ 1 ] = 0xD8;
                buf1.set( new Uint8Array( head ), 2 );
                buf1.set( new Uint8Array( buf2 ), head.byteLength + 2 );
    
                return buf1.buffer;
            }
        };
    
        Util.parseMeta = function() {
            return api.parse.apply( api, arguments );
        };
    
        Util.updateImageHead = function() {
            return api.updateImageHead.apply( api, arguments );
        };
    
        return api;
    });
    /**
     * ä»£ç æ¥è‡ªäºŽï¼šhttps://github.com/blueimp/JavaScript-Load-Image
     * æš‚æ—¶é¡¹ç›®ä¸­åªç”¨äº†orientation.
     *
     * åŽ»é™¤äº† Exif Sub IFD Pointer, GPS Info IFD Pointer, Exif Thumbnail.
     * @fileOverview EXIFè§£æž
     */
    
    // Sample
    // ====================================
    // Make : Apple
    // Model : iPhone 4S
    // Orientation : 1
    // XResolution : 72 [72/1]
    // YResolution : 72 [72/1]
    // ResolutionUnit : 2
    // Software : QuickTime 7.7.1
    // DateTime : 2013:09:01 22:53:55
    // ExifIFDPointer : 190
    // ExposureTime : 0.058823529411764705 [1/17]
    // FNumber : 2.4 [12/5]
    // ExposureProgram : Normal program
    // ISOSpeedRatings : 800
    // ExifVersion : 0220
    // DateTimeOriginal : 2013:09:01 22:52:51
    // DateTimeDigitized : 2013:09:01 22:52:51
    // ComponentsConfiguration : YCbCr
    // ShutterSpeedValue : 4.058893515764426
    // ApertureValue : 2.5260688216892597 [4845/1918]
    // BrightnessValue : -0.3126686601998395
    // MeteringMode : Pattern
    // Flash : Flash did not fire, compulsory flash mode
    // FocalLength : 4.28 [107/25]
    // SubjectArea : [4 values]
    // FlashpixVersion : 0100
    // ColorSpace : 1
    // PixelXDimension : 2448
    // PixelYDimension : 3264
    // SensingMethod : One-chip color area sensor
    // ExposureMode : 0
    // WhiteBalance : Auto white balance
    // FocalLengthIn35mmFilm : 35
    // SceneCaptureType : Standard
    define('runtime/html5/imagemeta/exif',[
        'base',
        'runtime/html5/imagemeta'
    ], function( Base, ImageMeta ) {
    
        var EXIF = {};
    
        EXIF.ExifMap = function() {
            return this;
        };
    
        EXIF.ExifMap.prototype.map = {
            'Orientation': 0x0112
        };
    
        EXIF.ExifMap.prototype.get = function( id ) {
            return this[ id ] || this[ this.map[ id ] ];
        };
    
        EXIF.exifTagTypes = {
            // byte, 8-bit unsigned int:
            1: {
                getValue: function( dataView, dataOffset ) {
                    return dataView.getUint8( dataOffset );
                },
                size: 1
            },
    
            // ascii, 8-bit byte:
            2: {
                getValue: function( dataView, dataOffset ) {
                    return String.fromCharCode( dataView.getUint8( dataOffset ) );
                },
                size: 1,
                ascii: true
            },
    
            // short, 16 bit int:
            3: {
                getValue: function( dataView, dataOffset, littleEndian ) {
                    return dataView.getUint16( dataOffset, littleEndian );
                },
                size: 2
            },
    
            // long, 32 bit int:
            4: {
                getValue: function( dataView, dataOffset, littleEndian ) {
                    return dataView.getUint32( dataOffset, littleEndian );
                },
                size: 4
            },
    
            // rational = two long values,
            // first is numerator, second is denominator:
            5: {
                getValue: function( dataView, dataOffset, littleEndian ) {
                    return dataView.getUint32( dataOffset, littleEndian ) /
                        dataView.getUint32( dataOffset + 4, littleEndian );
                },
                size: 8
            },
    
            // slong, 32 bit signed int:
            9: {
                getValue: function( dataView, dataOffset, littleEndian ) {
                    return dataView.getInt32( dataOffset, littleEndian );
                },
                size: 4
            },
    
            // srational, two slongs, first is numerator, second is denominator:
            10: {
                getValue: function( dataView, dataOffset, littleEndian ) {
                    return dataView.getInt32( dataOffset, littleEndian ) /
                        dataView.getInt32( dataOffset + 4, littleEndian );
                },
                size: 8
            }
        };
    
        // undefined, 8-bit byte, value depending on field:
        EXIF.exifTagTypes[ 7 ] = EXIF.exifTagTypes[ 1 ];
    
        EXIF.getExifValue = function( dataView, tiffOffset, offset, type, length,
                littleEndian ) {
    
            var tagType = EXIF.exifTagTypes[ type ],
                tagSize, dataOffset, values, i, str, c;
    
            if ( !tagType ) {
                Base.log('Invalid Exif data: Invalid tag type.');
                return;
            }
    
            tagSize = tagType.size * length;
    
            // Determine if the value is contained in the dataOffset bytes,
            // or if the value at the dataOffset is a pointer to the actual data:
            dataOffset = tagSize > 4 ? tiffOffset + dataView.getUint32( offset + 8,
                    littleEndian ) : (offset + 8);
    
            if ( dataOffset + tagSize > dataView.byteLength ) {
                Base.log('Invalid Exif data: Invalid data offset.');
                return;
            }
    
            if ( length === 1 ) {
                return tagType.getValue( dataView, dataOffset, littleEndian );
            }
    
            values = [];
    
            for ( i = 0; i < length; i += 1 ) {
                values[ i ] = tagType.getValue( dataView,
                        dataOffset + i * tagType.size, littleEndian );
            }
    
            if ( tagType.ascii ) {
                str = '';
    
                // Concatenate the chars:
                for ( i = 0; i < values.length; i += 1 ) {
                    c = values[ i ];
    
                    // Ignore the terminating NULL byte(s):
                    if ( c === '\u0000' ) {
                        break;
                    }
                    str += c;
                }
    
                return str;
            }
            return values;
        };
    
        EXIF.parseExifTag = function( dataView, tiffOffset, offset, littleEndian,
                data ) {
    
            var tag = dataView.getUint16( offset, littleEndian );
            data.exif[ tag ] = EXIF.getExifValue( dataView, tiffOffset, offset,
                    dataView.getUint16( offset + 2, littleEndian ),    // tag type
                    dataView.getUint32( offset + 4, littleEndian ),    // tag length
                    littleEndian );
        };
    
        EXIF.parseExifTags = function( dataView, tiffOffset, dirOffset,
                littleEndian, data ) {
    
            var tagsNumber, dirEndOffset, i;
    
            if ( dirOffset + 6 > dataView.byteLength ) {
                Base.log('Invalid Exif data: Invalid directory offset.');
                return;
            }
    
            tagsNumber = dataView.getUint16( dirOffset, littleEndian );
            dirEndOffset = dirOffset + 2 + 12 * tagsNumber;
    
            if ( dirEndOffset + 4 > dataView.byteLength ) {
                Base.log('Invalid Exif data: Invalid directory size.');
                return;
            }
    
            for ( i = 0; i < tagsNumber; i += 1 ) {
                this.parseExifTag( dataView, tiffOffset,
                        dirOffset + 2 + 12 * i,    // tag offset
                        littleEndian, data );
            }
    
            // Return the offset to the next directory:
            return dataView.getUint32( dirEndOffset, littleEndian );
        };
    
        // EXIF.getExifThumbnail = function(dataView, offset, length) {
        //     var hexData,
        //         i,
        //         b;
        //     if (!length || offset + length > dataView.byteLength) {
        //         Base.log('Invalid Exif data: Invalid thumbnail data.');
        //         return;
        //     }
        //     hexData = [];
        //     for (i = 0; i < length; i += 1) {
        //         b = dataView.getUint8(offset + i);
        //         hexData.push((b < 16 ? '0' : '') + b.toString(16));
        //     }
        //     return 'data:image/jpeg,%' + hexData.join('%');
        // };
    
        EXIF.parseExifData = function( dataView, offset, length, data ) {
    
            var tiffOffset = offset + 10,
                littleEndian, dirOffset;
    
            // Check for the ASCII code for "Exif" (0x45786966):
            if ( dataView.getUint32( offset + 4 ) !== 0x45786966 ) {
                // No Exif data, might be XMP data instead
                return;
            }
            if ( tiffOffset + 8 > dataView.byteLength ) {
                Base.log('Invalid Exif data: Invalid segment size.');
                return;
            }
    
            // Check for the two null bytes:
            if ( dataView.getUint16( offset + 8 ) !== 0x0000 ) {
                Base.log('Invalid Exif data: Missing byte alignment offset.');
                return;
            }
    
            // Check the byte alignment:
            switch ( dataView.getUint16( tiffOffset ) ) {
                case 0x4949:
                    littleEndian = true;
                    break;
    
                case 0x4D4D:
                    littleEndian = false;
                    break;
    
                default:
                    Base.log('Invalid Exif data: Invalid byte alignment marker.');
                    return;
            }
    
            // Check for the TIFF tag marker (0x002A):
            if ( dataView.getUint16( tiffOffset + 2, littleEndian ) !== 0x002A ) {
                Base.log('Invalid Exif data: Missing TIFF marker.');
                return;
            }
    
            // Retrieve the directory offset bytes, usually 0x00000008 or 8 decimal:
            dirOffset = dataView.getUint32( tiffOffset + 4, littleEndian );
            // Create the exif object to store the tags:
            data.exif = new EXIF.ExifMap();
            // Parse the tags of the main image directory and retrieve the
            // offset to the next directory, usually the thumbnail directory:
            dirOffset = EXIF.parseExifTags( dataView, tiffOffset,
                    tiffOffset + dirOffset, littleEndian, data );
    
            // å°è¯•è¯»å–ç¼©ç•¥å›¾
            // if ( dirOffset ) {
            //     thumbnailData = {exif: {}};
            //     dirOffset = EXIF.parseExifTags(
            //         dataView,
            //         tiffOffset,
            //         tiffOffset + dirOffset,
            //         littleEndian,
            //         thumbnailData
            //     );
    
            //     // Check for JPEG Thumbnail offset:
            //     if (thumbnailData.exif[0x0201]) {
            //         data.exif.Thumbnail = EXIF.getExifThumbnail(
            //             dataView,
            //             tiffOffset + thumbnailData.exif[0x0201],
            //             thumbnailData.exif[0x0202] // Thumbnail data length
            //         );
            //     }
            // }
        };
    
        ImageMeta.parsers[ 0xffe1 ].push( EXIF.parseExifData );
        return EXIF;
    });
    /**
     * @fileOverview Image
     */
    define('runtime/html5/image',[
        'base',
        'runtime/html5/runtime',
        'runtime/html5/util'
    ], function( Base, Html5Runtime, Util ) {
    
        var BLANK = 'data:image/gif;base64,R0lGODlhAQABAAD/ACwAAAAAAQABAAACADs%3D';
    
        return Html5Runtime.register( 'Image', {
    
            // flag: æ ‡è®°æ˜¯å¦è¢«ä¿®æ”¹è¿‡ã€‚
            modified: false,
    
            init: function() {
                var me = this,
                    img = new Image();
    
                img.onload = function() {
    
                    me._info = {
                        type: me.type,
                        width: this.width,
                        height: this.height
                    };
    
                    // è¯»å–metaä¿¡æ¯ã€‚
                    if ( !me._metas && 'image/jpeg' === me.type ) {
                        Util.parseMeta( me._blob, function( error, ret ) {
                            me._metas = ret;
                            me.owner.trigger('load');
                        });
                    } else {
                        me.owner.trigger('load');
                    }
                };
    
                img.onerror = function() {
                    me.owner.trigger('error');
                };
    
                me._img = img;
            },
    
            loadFromBlob: function( blob ) {
                var me = this,
                    img = me._img;
    
                me._blob = blob;
                me.type = blob.type;
                img.src = Util.createObjectURL( blob.getSource() );
                me.owner.once( 'load', function() {
                    Util.revokeObjectURL( img.src );
                });
            },
    
            resize: function( width, height ) {
                var canvas = this._canvas ||
                        (this._canvas = document.createElement('canvas'));
    
                this._resize( this._img, canvas, width, height );
                this._blob = null;    // æ²¡ç”¨äº†ï¼Œå¯ä»¥åˆ æŽ‰äº†ã€‚
                this.modified = true;
                this.owner.trigger( 'complete', 'resize' );
            },
    
            crop: function( x, y, w, h, s ) {
                var cvs = this._canvas ||
                        (this._canvas = document.createElement('canvas')),
                    opts = this.options,
                    img = this._img,
                    iw = img.naturalWidth,
                    ih = img.naturalHeight,
                    orientation = this.getOrientation();
    
                s = s || 1;
    
                // todo è§£å†³ orientation çš„é—®é¢˜ã€‚
                // values that require 90 degree rotation
                // if ( ~[ 5, 6, 7, 8 ].indexOf( orientation ) ) {
    
                //     switch ( orientation ) {
                //         case 6:
                //             tmp = x;
                //             x = y;
                //             y = iw * s - tmp - w;
                //             console.log(ih * s, tmp, w)
                //             break;
                //     }
    
                //     (w ^= h, h ^= w, w ^= h);
                // }
    
                cvs.width = w;
                cvs.height = h;
    
                opts.preserveHeaders || this._rotate2Orientaion( cvs, orientation );
                this._renderImageToCanvas( cvs, img, -x, -y, iw * s, ih * s );
    
                this._blob = null;    // æ²¡ç”¨äº†ï¼Œå¯ä»¥åˆ æŽ‰äº†ã€‚
                this.modified = true;
                this.owner.trigger( 'complete', 'crop' );
            },
    
            getAsBlob: function( type ) {
                var blob = this._blob,
                    opts = this.options,
                    canvas;
    
                type = type || this.type;
    
                // blobéœ€è¦é‡æ–°ç”Ÿæˆã€‚
                if ( this.modified || this.type !== type ) {
                    canvas = this._canvas;
    
                    if ( type === 'image/jpeg' ) {
    
                        blob = Util.canvasToDataUrl( canvas, type, opts.quality );
    
                        if ( opts.preserveHeaders && this._metas &&
                                this._metas.imageHead ) {
    
                            blob = Util.dataURL2ArrayBuffer( blob );
                            blob = Util.updateImageHead( blob,
                                    this._metas.imageHead );
                            blob = Util.arrayBufferToBlob( blob, type );
                            return blob;
                        }
                    } else {
                        blob = Util.canvasToDataUrl( canvas, type );
                    }
    
                    blob = Util.dataURL2Blob( blob );
                }
    
                return blob;
            },
    
            getAsDataUrl: function( type ) {
                var opts = this.options;
    
                type = type || this.type;
    
                if ( type === 'image/jpeg' ) {
                    return Util.canvasToDataUrl( this._canvas, type, opts.quality );
                } else {
                    return this._canvas.toDataURL( type );
                }
            },
    
            getOrientation: function() {
                return this._metas && this._metas.exif &&
                        this._metas.exif.get('Orientation') || 1;
            },
    
            info: function( val ) {
    
                // setter
                if ( val ) {
                    this._info = val;
                    return this;
                }
    
                // getter
                return this._info;
            },
    
            meta: function( val ) {
    
                // setter
                if ( val ) {
                    this._meta = val;
                    return this;
                }
    
                // getter
                return this._meta;
            },
    
            destroy: function() {
                var canvas = this._canvas;
                this._img.onload = null;
    
                if ( canvas ) {
                    canvas.getContext('2d')
                            .clearRect( 0, 0, canvas.width, canvas.height );
                    canvas.width = canvas.height = 0;
                    this._canvas = null;
                }
    
                // é‡Šæ”¾å†…å­˜ã€‚éžå¸¸é‡è¦ï¼Œå¦åˆ™é‡Šæ”¾ä¸äº†imageçš„å†…å­˜ã€‚
                this._img.src = BLANK;
                this._img = this._blob = null;
            },
    
            _resize: function( img, cvs, width, height ) {
                var opts = this.options,
                    naturalWidth = img.width,
                    naturalHeight = img.height,
                    orientation = this.getOrientation(),
                    scale, w, h, x, y;
    
                // values that require 90 degree rotation
                if ( ~[ 5, 6, 7, 8 ].indexOf( orientation ) ) {
    
                    // äº¤æ¢width, heightçš„å€¼ã€‚
                    width ^= height;
                    height ^= width;
                    width ^= height;
                }
    
                scale = Math[ opts.crop ? 'max' : 'min' ]( width / naturalWidth,
                        height / naturalHeight );
    
                // ä¸å…è®¸æ”¾å¤§ã€‚
                opts.allowMagnify || (scale = Math.min( 1, scale ));
    
                w = naturalWidth * scale;
                h = naturalHeight * scale;
    
                if ( opts.crop ) {
                    cvs.width = width;
                    cvs.height = height;
                } else {
                    cvs.width = w;
                    cvs.height = h;
                }
    
                x = (cvs.width - w) / 2;
                y = (cvs.height - h) / 2;
    
                opts.preserveHeaders || this._rotate2Orientaion( cvs, orientation );
    
                this._renderImageToCanvas( cvs, img, x, y, w, h );
            },
    
            _rotate2Orientaion: function( canvas, orientation ) {
                var width = canvas.width,
                    height = canvas.height,
                    ctx = canvas.getContext('2d');
    
                switch ( orientation ) {
                    case 5:
                    case 6:
                    case 7:
                    case 8:
                        canvas.width = height;
                        canvas.height = width;
                        break;
                }
    
                switch ( orientation ) {
                    case 2:    // horizontal flip
                        ctx.translate( width, 0 );
                        ctx.scale( -1, 1 );
                        break;
    
                    case 3:    // 180 rotate left
                        ctx.translate( width, height );
                        ctx.rotate( Math.PI );
                        break;
    
                    case 4:    // vertical flip
                        ctx.translate( 0, height );
                        ctx.scale( 1, -1 );
                        break;
    
                    case 5:    // vertical flip + 90 rotate right
                        ctx.rotate( 0.5 * Math.PI );
                        ctx.scale( 1, -1 );
                        break;
    
                    case 6:    // 90 rotate right
                        ctx.rotate( 0.5 * Math.PI );
                        ctx.translate( 0, -height );
                        break;
    
                    case 7:    // horizontal flip + 90 rotate right
                        ctx.rotate( 0.5 * Math.PI );
                        ctx.translate( width, -height );
                        ctx.scale( -1, 1 );
                        break;
    
                    case 8:    // 90 rotate left
                        ctx.rotate( -0.5 * Math.PI );
                        ctx.translate( -width, 0 );
                        break;
                }
            },
    
            // https://github.com/stomita/ios-imagefile-megapixel/
            // blob/master/src/megapix-image.js
            _renderImageToCanvas: (function() {
    
                // å¦‚æžœä¸æ˜¯ios, ä¸éœ€è¦è¿™ä¹ˆå¤æ‚ï¼
                if ( !Base.os.ios ) {
                    return function( canvas ) {
                        var args = Base.slice( arguments, 1 ),
                            ctx = canvas.getContext('2d');
    
                        ctx.drawImage.apply( ctx, args );
                    };
                }
    
                /**
                 * Detecting vertical squash in loaded image.
                 * Fixes a bug which squash image vertically while drawing into
                 * canvas for some images.
                 */
                function detectVerticalSquash( img, iw, ih ) {
                    var canvas = document.createElement('canvas'),
                        ctx = canvas.getContext('2d'),
                        sy = 0,
                        ey = ih,
                        py = ih,
                        data, alpha, ratio;
    
    
                    canvas.width = 1;
                    canvas.height = ih;
                    ctx.drawImage( img, 0, 0 );
                    data = ctx.getImageData( 0, 0, 1, ih ).data;
    
                    // search image edge pixel position in case
                    // it is squashed vertically.
                    while ( py > sy ) {
                        alpha = data[ (py - 1) * 4 + 3 ];
    
                        if ( alpha === 0 ) {
                            ey = py;
                        } else {
                            sy = py;
                        }
    
                        py = (ey + sy) >> 1;
                    }
    
                    ratio = (py / ih);
                    return (ratio === 0) ? 1 : ratio;
                }
    
                // fix ie7 bug
                // http://stackoverflow.com/questions/11929099/
                // html5-canvas-drawimage-ratio-bug-ios
                if ( Base.os.ios >= 7 ) {
                    return function( canvas, img, x, y, w, h ) {
                        var iw = img.naturalWidth,
                            ih = img.naturalHeight,
                            vertSquashRatio = detectVerticalSquash( img, iw, ih );
    
                        return canvas.getContext('2d').drawImage( img, 0, 0,
                                iw * vertSquashRatio, ih * vertSquashRatio,
                                x, y, w, h );
                    };
                }
    
                /**
                 * Detect subsampling in loaded image.
                 * In iOS, larger images than 2M pixels may be
                 * subsampled in rendering.
                 */
                function detectSubsampling( img ) {
                    var iw = img.naturalWidth,
                        ih = img.naturalHeight,
                        canvas, ctx;
    
                    // subsampling may happen overmegapixel image
                    if ( iw * ih > 1024 * 1024 ) {
                        canvas = document.createElement('canvas');
                        canvas.width = canvas.height = 1;
                        ctx = canvas.getContext('2d');
                        ctx.drawImage( img, -iw + 1, 0 );
    
                        // subsampled image becomes half smaller in rendering size.
                        // check alpha channel value to confirm image is covering
                        // edge pixel or not. if alpha value is 0
                        // image is not covering, hence subsampled.
                        return ctx.getImageData( 0, 0, 1, 1 ).data[ 3 ] === 0;
                    } else {
                        return false;
                    }
                }
    
    
                return function( canvas, img, x, y, width, height ) {
                    var iw = img.naturalWidth,
                        ih = img.naturalHeight,
                        ctx = canvas.getContext('2d'),
                        subsampled = detectSubsampling( img ),
                        doSquash = this.type === 'image/jpeg',
                        d = 1024,
                        sy = 0,
                        dy = 0,
                        tmpCanvas, tmpCtx, vertSquashRatio, dw, dh, sx, dx;
    
                    if ( subsampled ) {
                        iw /= 2;
                        ih /= 2;
                    }
    
                    ctx.save();
                    tmpCanvas = document.createElement('canvas');
                    tmpCanvas.width = tmpCanvas.height = d;
    
                    tmpCtx = tmpCanvas.getContext('2d');
                    vertSquashRatio = doSquash ?
                            detectVerticalSquash( img, iw, ih ) : 1;
    
                    dw = Math.ceil( d * width / iw );
                    dh = Math.ceil( d * height / ih / vertSquashRatio );
    
                    while ( sy < ih ) {
                        sx = 0;
                        dx = 0;
                        while ( sx < iw ) {
                            tmpCtx.clearRect( 0, 0, d, d );
                            tmpCtx.drawImage( img, -sx, -sy );
                            ctx.drawImage( tmpCanvas, 0, 0, d, d,
                                    x + dx, y + dy, dw, dh );
                            sx += d;
                            dx += dw;
                        }
                        sy += d;
                        dy += dh;
                    }
                    ctx.restore();
                    tmpCanvas = tmpCtx = null;
                };
            })()
        });
    });
    /**
     * è¿™ä¸ªæ–¹å¼æ€§èƒ½ä¸è¡Œï¼Œä½†æ˜¯å¯ä»¥è§£å†³androidé‡Œé¢çš„toDataUrlçš„bug
     * androidé‡Œé¢toDataUrl('image/jpege')å¾—åˆ°çš„ç»“æžœå´æ˜¯png.
     *
     * æ‰€ä»¥è¿™é‡Œæ²¡è¾™ï¼Œåªèƒ½å€ŸåŠ©è¿™ä¸ªå·¥å…·
     * @fileOverview jpeg encoder
     */
    define('runtime/html5/jpegencoder',[], function( require, exports, module ) {
    
        /*
          Copyright (c) 2008, Adobe Systems Incorporated
          All rights reserved.
    
          Redistribution and use in source and binary forms, with or without
          modification, are permitted provided that the following conditions are
          met:
    
          * Redistributions of source code must retain the above copyright notice,
            this list of conditions and the following disclaimer.
    
          * Redistributions in binary form must reproduce the above copyright
            notice, this list of conditions and the following disclaimer in the
            documentation and/or other materials provided with the distribution.
    
          * Neither the name of Adobe Systems Incorporated nor the names of its
            contributors may be used to endorse or promote products derived from
            this software without specific prior written permission.
    
          THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
          IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
          THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
          PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
          CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
          EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
          PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
          PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
          LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
          NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
          SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
        */
        /*
        JPEG encoder ported to JavaScript and optimized by Andreas Ritter, www.bytestrom.eu, 11/2009
    
        Basic GUI blocking jpeg encoder
        */
    
        function JPEGEncoder(quality) {
          var self = this;
            var fround = Math.round;
            var ffloor = Math.floor;
            var YTable = new Array(64);
            var UVTable = new Array(64);
            var fdtbl_Y = new Array(64);
            var fdtbl_UV = new Array(64);
            var YDC_HT;
            var UVDC_HT;
            var YAC_HT;
            var UVAC_HT;
    
            var bitcode = new Array(65535);
            var category = new Array(65535);
            var outputfDCTQuant = new Array(64);
            var DU = new Array(64);
            var byteout = [];
            var bytenew = 0;
            var bytepos = 7;
    
            var YDU = new Array(64);
            var UDU = new Array(64);
            var VDU = new Array(64);
            var clt = new Array(256);
            var RGB_YUV_TABLE = new Array(2048);
            var currentQuality;
    
            var ZigZag = [
                     0, 1, 5, 6,14,15,27,28,
                     2, 4, 7,13,16,26,29,42,
                     3, 8,12,17,25,30,41,43,
                     9,11,18,24,31,40,44,53,
                    10,19,23,32,39,45,52,54,
                    20,22,33,38,46,51,55,60,
                    21,34,37,47,50,56,59,61,
                    35,36,48,49,57,58,62,63
                ];
    
            var std_dc_luminance_nrcodes = [0,0,1,5,1,1,1,1,1,1,0,0,0,0,0,0,0];
            var std_dc_luminance_values = [0,1,2,3,4,5,6,7,8,9,10,11];
            var std_ac_luminance_nrcodes = [0,0,2,1,3,3,2,4,3,5,5,4,4,0,0,1,0x7d];
            var std_ac_luminance_values = [
                    0x01,0x02,0x03,0x00,0x04,0x11,0x05,0x12,
                    0x21,0x31,0x41,0x06,0x13,0x51,0x61,0x07,
                    0x22,0x71,0x14,0x32,0x81,0x91,0xa1,0x08,
                    0x23,0x42,0xb1,0xc1,0x15,0x52,0xd1,0xf0,
                    0x24,0x33,0x62,0x72,0x82,0x09,0x0a,0x16,
                    0x17,0x18,0x19,0x1a,0x25,0x26,0x27,0x28,
                    0x29,0x2a,0x34,0x35,0x36,0x37,0x38,0x39,
                    0x3a,0x43,0x44,0x45,0x46,0x47,0x48,0x49,
                    0x4a,0x53,0x54,0x55,0x56,0x57,0x58,0x59,
                    0x5a,0x63,0x64,0x65,0x66,0x67,0x68,0x69,
                    0x6a,0x73,0x74,0x75,0x76,0x77,0x78,0x79,
                    0x7a,0x83,0x84,0x85,0x86,0x87,0x88,0x89,
                    0x8a,0x92,0x93,0x94,0x95,0x96,0x97,0x98,
                    0x99,0x9a,0xa2,0xa3,0xa4,0xa5,0xa6,0xa7,
                    0xa8,0xa9,0xaa,0xb2,0xb3,0xb4,0xb5,0xb6,
                    0xb7,0xb8,0xb9,0xba,0xc2,0xc3,0xc4,0xc5,
                    0xc6,0xc7,0xc8,0xc9,0xca,0xd2,0xd3,0xd4,
                    0xd5,0xd6,0xd7,0xd8,0xd9,0xda,0xe1,0xe2,
                    0xe3,0xe4,0xe5,0xe6,0xe7,0xe8,0xe9,0xea,
                    0xf1,0xf2,0xf3,0xf4,0xf5,0xf6,0xf7,0xf8,
                    0xf9,0xfa
                ];
    
            var std_dc_chrominance_nrcodes = [0,0,3,1,1,1,1,1,1,1,1,1,0,0,0,0,0];
            var std_dc_chrominance_values = [0,1,2,3,4,5,6,7,8,9,10,11];
            var std_ac_chrominance_nrcodes = [0,0,2,1,2,4,4,3,4,7,5,4,4,0,1,2,0x77];
            var std_ac_chrominance_values = [
                    0x00,0x01,0x02,0x03,0x11,0x04,0x05,0x21,
                    0x31,0x06,0x12,0x41,0x51,0x07,0x61,0x71,
                    0x13,0x22,0x32,0x81,0x08,0x14,0x42,0x91,
                    0xa1,0xb1,0xc1,0x09,0x23,0x33,0x52,0xf0,
                    0x15,0x62,0x72,0xd1,0x0a,0x16,0x24,0x34,
                    0xe1,0x25,0xf1,0x17,0x18,0x19,0x1a,0x26,
                    0x27,0x28,0x29,0x2a,0x35,0x36,0x37,0x38,
                    0x39,0x3a,0x43,0x44,0x45,0x46,0x47,0x48,
                    0x49,0x4a,0x53,0x54,0x55,0x56,0x57,0x58,
                    0x59,0x5a,0x63,0x64,0x65,0x66,0x67,0x68,
                    0x69,0x6a,0x73,0x74,0x75,0x76,0x77,0x78,
                    0x79,0x7a,0x82,0x83,0x84,0x85,0x86,0x87,
                    0x88,0x89,0x8a,0x92,0x93,0x94,0x95,0x96,
                    0x97,0x98,0x99,0x9a,0xa2,0xa3,0xa4,0xa5,
                    0xa6,0xa7,0xa8,0xa9,0xaa,0xb2,0xb3,0xb4,
                    0xb5,0xb6,0xb7,0xb8,0xb9,0xba,0xc2,0xc3,
                    0xc4,0xc5,0xc6,0xc7,0xc8,0xc9,0xca,0xd2,
                    0xd3,0xd4,0xd5,0xd6,0xd7,0xd8,0xd9,0xda,
                    0xe2,0xe3,0xe4,0xe5,0xe6,0xe7,0xe8,0xe9,
                    0xea,0xf2,0xf3,0xf4,0xf5,0xf6,0xf7,0xf8,
                    0xf9,0xfa
                ];
    
            function initQuantTables(sf){
                    var YQT = [
                        16, 11, 10, 16, 24, 40, 51, 61,
                        12, 12, 14, 19, 26, 58, 60, 55,
                        14, 13, 16, 24, 40, 57, 69, 56,
                        14, 17, 22, 29, 51, 87, 80, 62,
                        18, 22, 37, 56, 68,109,103, 77,
                        24, 35, 55, 64, 81,104,113, 92,
                        49, 64, 78, 87,103,121,120,101,
                        72, 92, 95, 98,112,100,103, 99
                    ];
    
                    for (var i = 0; i < 64; i++) {
                        var t = ffloor((YQT[i]*sf+50)/100);
                        if (t < 1) {
                            t = 1;
                        } else if (t > 255) {
                            t = 255;
                        }
                        YTable[ZigZag[i]] = t;
                    }
                    var UVQT = [
                        17, 18, 24, 47, 99, 99, 99, 99,
                        18, 21, 26, 66, 99, 99, 99, 99,
                        24, 26, 56, 99, 99, 99, 99, 99,
                        47, 66, 99, 99, 99, 99, 99, 99,
                        99, 99, 99, 99, 99, 99, 99, 99,
                        99, 99, 99, 99, 99, 99, 99, 99,
                        99, 99, 99, 99, 99, 99, 99, 99,
                        99, 99, 99, 99, 99, 99, 99, 99
                    ];
                    for (var j = 0; j < 64; j++) {
                        var u = ffloor((UVQT[j]*sf+50)/100);
                        if (u < 1) {
                            u = 1;
                        } else if (u > 255) {
                            u = 255;
                        }
                        UVTable[ZigZag[j]] = u;
                    }
                    var aasf = [
                        1.0, 1.387039845, 1.306562965, 1.175875602,
                        1.0, 0.785694958, 0.541196100, 0.275899379
                    ];
                    var k = 0;
                    for (var row = 0; row < 8; row++)
                    {
                        for (var col = 0; col < 8; col++)
                        {
                            fdtbl_Y[k]  = (1.0 / (YTable [ZigZag[k]] * aasf[row] * aasf[col] * 8.0));
                            fdtbl_UV[k] = (1.0 / (UVTable[ZigZag[k]] * aasf[row] * aasf[col] * 8.0));
                            k++;
                        }
                    }
                }
    
                function computeHuffmanTbl(nrcodes, std_table){
                    var codevalue = 0;
                    var pos_in_table = 0;
                    var HT = new Array();
                    for (var k = 1; k <= 16; k++) {
                        for (var j = 1; j <= nrcodes[k]; j++) {
                            HT[std_table[pos_in_table]] = [];
                            HT[std_table[pos_in_table]][0] = codevalue;
                            HT[std_table[pos_in_table]][1] = k;
                            pos_in_table++;
                            codevalue++;
                        }
                        codevalue*=2;
                    }
                    return HT;
                }
    
                function initHuffmanTbl()
                {
                    YDC_HT = computeHuffmanTbl(std_dc_luminance_nrcodes,std_dc_luminance_values);
                    UVDC_HT = computeHuffmanTbl(std_dc_chrominance_nrcodes,std_dc_chrominance_values);
                    YAC_HT = computeHuffmanTbl(std_ac_luminance_nrcodes,std_ac_luminance_values);
                    UVAC_HT = computeHuffmanTbl(std_ac_chrominance_nrcodes,std_ac_chrominance_values);
                }
    
                function initCategoryNumber()
                {
                    var nrlower = 1;
                    var nrupper = 2;
                    for (var cat = 1; cat <= 15; cat++) {
                        //Positive numbers
                        for (var nr = nrlower; nr<nrupper; nr++) {
                            category[32767+nr] = cat;
                            bitcode[32767+nr] = [];
                            bitcode[32767+nr][1] = cat;
                            bitcode[32767+nr][0] = nr;
                        }
                        //Negative numbers
                        for (var nrneg =-(nrupper-1); nrneg<=-nrlower; nrneg++) {
                            category[32767+nrneg] = cat;
                            bitcode[32767+nrneg] = [];
                            bitcode[32767+nrneg][1] = cat;
                            bitcode[32767+nrneg][0] = nrupper-1+nrneg;
                        }
                        nrlower <<= 1;
                        nrupper <<= 1;
                    }
                }
    
                function initRGBYUVTable() {
                    for(var i = 0; i < 256;i++) {
                        RGB_YUV_TABLE[i]            =  19595 * i;
                        RGB_YUV_TABLE[(i+ 256)>>0]  =  38470 * i;
                        RGB_YUV_TABLE[(i+ 512)>>0]  =   7471 * i + 0x8000;
                        RGB_YUV_TABLE[(i+ 768)>>0]  = -11059 * i;
                        RGB_YUV_TABLE[(i+1024)>>0]  = -21709 * i;
                        RGB_YUV_TABLE[(i+1280)>>0]  =  32768 * i + 0x807FFF;
                        RGB_YUV_TABLE[(i+1536)>>0]  = -27439 * i;
                        RGB_YUV_TABLE[(i+1792)>>0]  = - 5329 * i;
                    }
                }
    
                // IO functions
                function writeBits(bs)
                {
                    var value = bs[0];
                    var posval = bs[1]-1;
                    while ( posval >= 0 ) {
                        if (value & (1 << posval) ) {
                            bytenew |= (1 << bytepos);
                        }
                        posval--;
                        bytepos--;
                        if (bytepos < 0) {
                            if (bytenew == 0xFF) {
                                writeByte(0xFF);
                                writeByte(0);
                            }
                            else {
                                writeByte(bytenew);
                            }
                            bytepos=7;
                            bytenew=0;
                        }
                    }
                }
    
                function writeByte(value)
                {
                    byteout.push(clt[value]); // write char directly instead of converting later
                }
    
                function writeWord(value)
                {
                    writeByte((value>>8)&0xFF);
                    writeByte((value   )&0xFF);
                }
    
                // DCT & quantization core
                function fDCTQuant(data, fdtbl)
                {
                    var d0, d1, d2, d3, d4, d5, d6, d7;
                    /* Pass 1: process rows. */
                    var dataOff=0;
                    var i;
                    var I8 = 8;
                    var I64 = 64;
                    for (i=0; i<I8; ++i)
                    {
                        d0 = data[dataOff];
                        d1 = data[dataOff+1];
                        d2 = data[dataOff+2];
                        d3 = data[dataOff+3];
                        d4 = data[dataOff+4];
                        d5 = data[dataOff+5];
                        d6 = data[dataOff+6];
                        d7 = data[dataOff+7];
    
                        var tmp0 = d0 + d7;
                        var tmp7 = d0 - d7;
                        var tmp1 = d1 + d6;
                        var tmp6 = d1 - d6;
                        var tmp2 = d2 + d5;
                        var tmp5 = d2 - d5;
                        var tmp3 = d3 + d4;
                        var tmp4 = d3 - d4;
    
                        /* Even part */
                        var tmp10 = tmp0 + tmp3;    /* phase 2 */
                        var tmp13 = tmp0 - tmp3;
                        var tmp11 = tmp1 + tmp2;
                        var tmp12 = tmp1 - tmp2;
    
                        data[dataOff] = tmp10 + tmp11; /* phase 3 */
                        data[dataOff+4] = tmp10 - tmp11;
    
                        var z1 = (tmp12 + tmp13) * 0.707106781; /* c4 */
                        data[dataOff+2] = tmp13 + z1; /* phase 5 */
                        data[dataOff+6] = tmp13 - z1;
    
                        /* Odd part */
                        tmp10 = tmp4 + tmp5; /* phase 2 */
                        tmp11 = tmp5 + tmp6;
                        tmp12 = tmp6 + tmp7;
    
                        /* The rotator is modified from fig 4-8 to avoid extra negations. */
                        var z5 = (tmp10 - tmp12) * 0.382683433; /* c6 */
                        var z2 = 0.541196100 * tmp10 + z5; /* c2-c6 */
                        var z4 = 1.306562965 * tmp12 + z5; /* c2+c6 */
                        var z3 = tmp11 * 0.707106781; /* c4 */
    
                        var z11 = tmp7 + z3;    /* phase 5 */
                        var z13 = tmp7 - z3;
    
                        data[dataOff+5] = z13 + z2; /* phase 6 */
                        data[dataOff+3] = z13 - z2;
                        data[dataOff+1] = z11 + z4;
                        data[dataOff+7] = z11 - z4;
    
                        dataOff += 8; /* advance pointer to next row */
                    }
    
                    /* Pass 2: process columns. */
                    dataOff = 0;
                    for (i=0; i<I8; ++i)
                    {
                        d0 = data[dataOff];
                        d1 = data[dataOff + 8];
                        d2 = data[dataOff + 16];
                        d3 = data[dataOff + 24];
                        d4 = data[dataOff + 32];
                        d5 = data[dataOff + 40];
                        d6 = data[dataOff + 48];
                        d7 = data[dataOff + 56];
    
                        var tmp0p2 = d0 + d7;
                        var tmp7p2 = d0 - d7;
                        var tmp1p2 = d1 + d6;
                        var tmp6p2 = d1 - d6;
                        var tmp2p2 = d2 + d5;
                        var tmp5p2 = d2 - d5;
                        var tmp3p2 = d3 + d4;
                        var tmp4p2 = d3 - d4;
    
                        /* Even part */
                        var tmp10p2 = tmp0p2 + tmp3p2;  /* phase 2 */
                        var tmp13p2 = tmp0p2 - tmp3p2;
                        var tmp11p2 = tmp1p2 + tmp2p2;
                        var tmp12p2 = tmp1p2 - tmp2p2;
    
                        data[dataOff] = tmp10p2 + tmp11p2; /* phase 3 */
                        data[dataOff+32] = tmp10p2 - tmp11p2;
    
                        var z1p2 = (tmp12p2 + tmp13p2) * 0.707106781; /* c4 */
                        data[dataOff+16] = tmp13p2 + z1p2; /* phase 5 */
                        data[dataOff+48] = tmp13p2 - z1p2;
    
                        /* Odd part */
                        tmp10p2 = tmp4p2 + tmp5p2; /* phase 2 */
                        tmp11p2 = tmp5p2 + tmp6p2;
                        tmp12p2 = tmp6p2 + tmp7p2;
    
                        /* The rotator is modified from fig 4-8 to avoid extra negations. */
                        var z5p2 = (tmp10p2 - tmp12p2) * 0.382683433; /* c6 */
                        var z2p2 = 0.541196100 * tmp10p2 + z5p2; /* c2-c6 */
                        var z4p2 = 1.306562965 * tmp12p2 + z5p2; /* c2+c6 */
                        var z3p2 = tmp11p2 * 0.707106781; /* c4 */
    
                        var z11p2 = tmp7p2 + z3p2;  /* phase 5 */
                        var z13p2 = tmp7p2 - z3p2;
    
                        data[dataOff+40] = z13p2 + z2p2; /* phase 6 */
                        data[dataOff+24] = z13p2 - z2p2;
                        data[dataOff+ 8] = z11p2 + z4p2;
                        data[dataOff+56] = z11p2 - z4p2;
    
                        dataOff++; /* advance pointer to next column */
                    }
    
                    // Quantize/descale the coefficients
                    var fDCTQuant;
                    for (i=0; i<I64; ++i)
                    {
                        // Apply the quantization and scaling factor & Round to nearest integer
                        fDCTQuant = data[i]*fdtbl[i];
                        outputfDCTQuant[i] = (fDCTQuant > 0.0) ? ((fDCTQuant + 0.5)|0) : ((fDCTQuant - 0.5)|0);
                        //outputfDCTQuant[i] = fround(fDCTQuant);
    
                    }
                    return outputfDCTQuant;
                }
    
                function writeAPP0()
                {
                    writeWord(0xFFE0); // marker
                    writeWord(16); // length
                    writeByte(0x4A); // J
                    writeByte(0x46); // F
                    writeByte(0x49); // I
                    writeByte(0x46); // F
                    writeByte(0); // = "JFIF",'\0'
                    writeByte(1); // versionhi
                    writeByte(1); // versionlo
                    writeByte(0); // xyunits
                    writeWord(1); // xdensity
                    writeWord(1); // ydensity
                    writeByte(0); // thumbnwidth
                    writeByte(0); // thumbnheight
                }
    
                function writeSOF0(width, height)
                {
                    writeWord(0xFFC0); // marker
                    writeWord(17);   // length, truecolor YUV JPG
                    writeByte(8);    // precision
                    writeWord(height);
                    writeWord(width);
                    writeByte(3);    // nrofcomponents
                    writeByte(1);    // IdY
                    writeByte(0x11); // HVY
                    writeByte(0);    // QTY
                    writeByte(2);    // IdU
                    writeByte(0x11); // HVU
                    writeByte(1);    // QTU
                    writeByte(3);    // IdV
                    writeByte(0x11); // HVV
                    writeByte(1);    // QTV
                }
    
                function writeDQT()
                {
                    writeWord(0xFFDB); // marker
                    writeWord(132);    // length
                    writeByte(0);
                    for (var i=0; i<64; i++) {
                        writeByte(YTable[i]);
                    }
                    writeByte(1);
                    for (var j=0; j<64; j++) {
                        writeByte(UVTable[j]);
                    }
                }
    
                function writeDHT()
                {
                    writeWord(0xFFC4); // marker
                    writeWord(0x01A2); // length
    
                    writeByte(0); // HTYDCinfo
                    for (var i=0; i<16; i++) {
                        writeByte(std_dc_luminance_nrcodes[i+1]);
                    }
                    for (var j=0; j<=11; j++) {
                        writeByte(std_dc_luminance_values[j]);
                    }
    
                    writeByte(0x10); // HTYACinfo
                    for (var k=0; k<16; k++) {
                        writeByte(std_ac_luminance_nrcodes[k+1]);
                    }
                    for (var l=0; l<=161; l++) {
                        writeByte(std_ac_luminance_values[l]);
                    }
    
                    writeByte(1); // HTUDCinfo
                    for (var m=0; m<16; m++) {
                        writeByte(std_dc_chrominance_nrcodes[m+1]);
                    }
                    for (var n=0; n<=11; n++) {
                        writeByte(std_dc_chrominance_values[n]);
                    }
    
                    writeByte(0x11); // HTUACinfo
                    for (var o=0; o<16; o++) {
                        writeByte(std_ac_chrominance_nrcodes[o+1]);
                    }
                    for (var p=0; p<=161; p++) {
                        writeByte(std_ac_chrominance_values[p]);
                    }
                }
    
                function writeSOS()
                {
                    writeWord(0xFFDA); // marker
                    writeWord(12); // length
                    writeByte(3); // nrofcomponents
                    writeByte(1); // IdY
                    writeByte(0); // HTY
                    writeByte(2); // IdU
                    writeByte(0x11); // HTU
                    writeByte(3); // IdV
                    writeByte(0x11); // HTV
                    writeByte(0); // Ss
                    writeByte(0x3f); // Se
                    writeByte(0); // Bf
                }
    
                function processDU(CDU, fdtbl, DC, HTDC, HTAC){
                    var EOB = HTAC[0x00];
                    var M16zeroes = HTAC[0xF0];
                    var pos;
                    var I16 = 16;
                    var I63 = 63;
                    var I64 = 64;
                    var DU_DCT = fDCTQuant(CDU, fdtbl);
                    //ZigZag reorder
                    for (var j=0;j<I64;++j) {
                        DU[ZigZag[j]]=DU_DCT[j];
                    }
                    var Diff = DU[0] - DC; DC = DU[0];
                    //Encode DC
                    if (Diff==0) {
                        writeBits(HTDC[0]); // Diff might be 0
                    } else {
                        pos = 32767+Diff;
                        writeBits(HTDC[category[pos]]);
                        writeBits(bitcode[pos]);
                    }
                    //Encode ACs
                    var end0pos = 63; // was const... which is crazy
                    for (; (end0pos>0)&&(DU[end0pos]==0); end0pos--) {};
                    //end0pos = first element in reverse order !=0
                    if ( end0pos == 0) {
                        writeBits(EOB);
                        return DC;
                    }
                    var i = 1;
                    var lng;
                    while ( i <= end0pos ) {
                        var startpos = i;
                        for (; (DU[i]==0) && (i<=end0pos); ++i) {}
                        var nrzeroes = i-startpos;
                        if ( nrzeroes >= I16 ) {
                            lng = nrzeroes>>4;
                            for (var nrmarker=1; nrmarker <= lng; ++nrmarker)
                                writeBits(M16zeroes);
                            nrzeroes = nrzeroes&0xF;
                        }
                        pos = 32767+DU[i];
                        writeBits(HTAC[(nrzeroes<<4)+category[pos]]);
                        writeBits(bitcode[pos]);
                        i++;
                    }
                    if ( end0pos != I63 ) {
                        writeBits(EOB);
                    }
                    return DC;
                }
    
                function initCharLookupTable(){
                    var sfcc = String.fromCharCode;
                    for(var i=0; i < 256; i++){ ///// ACHTUNG // 255
                        clt[i] = sfcc(i);
                    }
                }
    
                this.encode = function(image,quality) // image data object
                {
                    // var time_start = new Date().getTime();
    
                    if(quality) setQuality(quality);
    
                    // Initialize bit writer
                    byteout = new Array();
                    bytenew=0;
                    bytepos=7;
    
                    // Add JPEG headers
                    writeWord(0xFFD8); // SOI
                    writeAPP0();
                    writeDQT();
                    writeSOF0(image.width,image.height);
                    writeDHT();
                    writeSOS();
    
    
                    // Encode 8x8 macroblocks
                    var DCY=0;
                    var DCU=0;
                    var DCV=0;
    
                    bytenew=0;
                    bytepos=7;
    
    
                    this.encode.displayName = "_encode_";
    
                    var imageData = image.data;
                    var width = image.width;
                    var height = image.height;
    
                    var quadWidth = width*4;
                    var tripleWidth = width*3;
    
                    var x, y = 0;
                    var r, g, b;
                    var start,p, col,row,pos;
                    while(y < height){
                        x = 0;
                        while(x < quadWidth){
                        start = quadWidth * y + x;
                        p = start;
                        col = -1;
                        row = 0;
    
                        for(pos=0; pos < 64; pos++){
                            row = pos >> 3;// /8
                            col = ( pos & 7 ) * 4; // %8
                            p = start + ( row * quadWidth ) + col;
    
                            if(y+row >= height){ // padding bottom
                                p-= (quadWidth*(y+1+row-height));
                            }
    
                            if(x+col >= quadWidth){ // padding right
                                p-= ((x+col) - quadWidth +4)
                            }
    
                            r = imageData[ p++ ];
                            g = imageData[ p++ ];
                            b = imageData[ p++ ];
    
    
                            /* // calculate YUV values dynamically
                            YDU[pos]=((( 0.29900)*r+( 0.58700)*g+( 0.11400)*b))-128; //-0x80
                            UDU[pos]=(((-0.16874)*r+(-0.33126)*g+( 0.50000)*b));
                            VDU[pos]=((( 0.50000)*r+(-0.41869)*g+(-0.08131)*b));
                            */
    
                            // use lookup table (slightly faster)
                            YDU[pos] = ((RGB_YUV_TABLE[r]             + RGB_YUV_TABLE[(g +  256)>>0] + RGB_YUV_TABLE[(b +  512)>>0]) >> 16)-128;
                            UDU[pos] = ((RGB_YUV_TABLE[(r +  768)>>0] + RGB_YUV_TABLE[(g + 1024)>>0] + RGB_YUV_TABLE[(b + 1280)>>0]) >> 16)-128;
                            VDU[pos] = ((RGB_YUV_TABLE[(r + 1280)>>0] + RGB_YUV_TABLE[(g + 1536)>>0] + RGB_YUV_TABLE[(b + 1792)>>0]) >> 16)-128;
    
                        }
    
                        DCY = processDU(YDU, fdtbl_Y, DCY, YDC_HT, YAC_HT);
                        DCU = processDU(UDU, fdtbl_UV, DCU, UVDC_HT, UVAC_HT);
                        DCV = processDU(VDU, fdtbl_UV, DCV, UVDC_HT, UVAC_HT);
                        x+=32;
                        }
                        y+=8;
                    }
    
    
                    ////////////////////////////////////////////////////////////////
    
                    // Do the bit alignment of the EOI marker
                    if ( bytepos >= 0 ) {
                        var fillbits = [];
                        fillbits[1] = bytepos+1;
                        fillbits[0] = (1<<(bytepos+1))-1;
                        writeBits(fillbits);
                    }
    
                    writeWord(0xFFD9); //EOI
    
                    var jpegDataUri = 'data:image/jpeg;base64,' + btoa(byteout.join(''));
    
                    byteout = [];
    
                    // benchmarking
                    // var duration = new Date().getTime() - time_start;
                    // console.log('Encoding time: '+ currentQuality + 'ms');
                    //
    
                    return jpegDataUri
            }
    
            function setQuality(quality){
                if (quality <= 0) {
                    quality = 1;
                }
                if (quality > 100) {
                    quality = 100;
                }
    
                if(currentQuality == quality) return // don't recalc if unchanged
    
                var sf = 0;
                if (quality < 50) {
                    sf = Math.floor(5000 / quality);
                } else {
                    sf = Math.floor(200 - quality*2);
                }
    
                initQuantTables(sf);
                currentQuality = quality;
                // console.log('Quality set to: '+quality +'%');
            }
    
            function init(){
                // var time_start = new Date().getTime();
                if(!quality) quality = 50;
                // Create tables
                initCharLookupTable()
                initHuffmanTbl();
                initCategoryNumber();
                initRGBYUVTable();
    
                setQuality(quality);
                // var duration = new Date().getTime() - time_start;
                // console.log('Initialization '+ duration + 'ms');
            }
    
            init();
    
        };
    
        JPEGEncoder.encode = function( data, quality ) {
            var encoder = new JPEGEncoder( quality );
    
            return encoder.encode( data );
        }
    
        return JPEGEncoder;
    });
    /**
     * @fileOverview Fix android canvas.toDataUrl bug.
     */
    define('runtime/html5/androidpatch',[
        'runtime/html5/util',
        'runtime/html5/jpegencoder',
        'base'
    ], function( Util, encoder, Base ) {
        var origin = Util.canvasToDataUrl,
            supportJpeg;
    
        Util.canvasToDataUrl = function( canvas, type, quality ) {
            var ctx, w, h, fragement, parts;
    
            // éžandroidæ‰‹æœºç›´æŽ¥è·³è¿‡ã€‚
            if ( !Base.os.android ) {
                return origin.apply( null, arguments );
            }
    
            // æ£€æµ‹æ˜¯å¦canvasæ”¯æŒjpegå¯¼å‡ºï¼Œæ ¹æ®æ•°æ®æ ¼å¼æ¥åˆ¤æ–­ã€‚
            // JPEG å‰ä¸¤ä½åˆ†åˆ«æ˜¯ï¼š255, 216
            if ( type === 'image/jpeg' && typeof supportJpeg === 'undefined' ) {
                fragement = origin.apply( null, arguments );
    
                parts = fragement.split(',');
    
                if ( ~parts[ 0 ].indexOf('base64') ) {
                    fragement = atob( parts[ 1 ] );
                } else {
                    fragement = decodeURIComponent( parts[ 1 ] );
                }
    
                fragement = fragement.substring( 0, 2 );
    
                supportJpeg = fragement.charCodeAt( 0 ) === 255 &&
                        fragement.charCodeAt( 1 ) === 216;
            }
    
            // åªæœ‰åœ¨androidçŽ¯å¢ƒä¸‹æ‰ä¿®å¤
            if ( type === 'image/jpeg' && !supportJpeg ) {
                w = canvas.width;
                h = canvas.height;
                ctx = canvas.getContext('2d');
    
                return encoder.encode( ctx.getImageData( 0, 0, w, h ), quality );
            }
    
            return origin.apply( null, arguments );
        };
    });
    /**
     * @fileOverview Transport
     * @todo æ”¯æŒchunkedä¼ è¾“ï¼Œä¼˜åŠ¿ï¼š
     * å¯ä»¥å°†å¤§æ–‡ä»¶åˆ†æˆå°å—ï¼ŒæŒ¨ä¸ªä¼ è¾“ï¼Œå¯ä»¥æé«˜å¤§æ–‡ä»¶æˆåŠŸçŽ‡ï¼Œå½“å¤±è´¥çš„æ—¶å€™ï¼Œä¹Ÿåªéœ€è¦é‡ä¼ é‚£å°éƒ¨åˆ†ï¼Œ
     * è€Œä¸éœ€è¦é‡å¤´å†ä¼ ä¸€æ¬¡ã€‚å¦å¤–æ–­ç‚¹ç»­ä¼ ä¹Ÿéœ€è¦ç”¨chunkedæ–¹å¼ã€‚
     */
    define('runtime/html5/transport',[
        'base',
        'runtime/html5/runtime'
    ], function( Base, Html5Runtime ) {
    
        var noop = Base.noop,
            $ = Base.$;
    
        return Html5Runtime.register( 'Transport', {
            init: function() {
                this._status = 0;
                this._response = null;
            },
    
            send: function() {
                var owner = this.owner,
                    opts = this.options,
                    xhr = this._initAjax(),
                    blob = owner._blob,
                    server = opts.server,
                    formData, binary, fr;
    
                if ( opts.sendAsBinary ) {
                    server += (/\?/.test( server ) ? '&' : '?') +
                            $.param( owner._formData );
    
                    binary = blob.getSource();
                } else {
                    formData = new FormData();
                    $.each( owner._formData, function( k, v ) {
                        formData.append( k, v );
                    });
    
                    formData.append( opts.fileVal, blob.getSource(),
                            opts.filename || owner._formData.name || '' );
                }
    
                if ( opts.withCredentials && 'withCredentials' in xhr ) {
                    xhr.open( opts.method, server, true );
                    xhr.withCredentials = true;
                } else {
                    xhr.open( opts.method, server );
                }
    
                this._setRequestHeader( xhr, opts.headers );
    
                if ( binary ) {
                    // å¼ºåˆ¶è®¾ç½®æˆ content-type ä¸ºæ–‡ä»¶æµã€‚
                    xhr.overrideMimeType &&
                            xhr.overrideMimeType('application/octet-stream');
    
                    // androidç›´æŽ¥å‘é€blobä¼šå¯¼è‡´æœåŠ¡ç«¯æŽ¥æ”¶åˆ°çš„æ˜¯ç©ºæ–‡ä»¶ã€‚
                    // bugè¯¦æƒ…ã€‚
                    // https://code.google.com/p/android/issues/detail?id=39882
                    // æ‰€ä»¥å…ˆç”¨fileReaderè¯»å–å‡ºæ¥å†é€šè¿‡arraybufferçš„æ–¹å¼å‘é€ã€‚
                    if ( Base.os.android ) {
                        fr = new FileReader();
    
                        fr.onload = function() {
                            xhr.send( this.result );
                            fr = fr.onload = null;
                        };
    
                        fr.readAsArrayBuffer( binary );
                    } else {
                        xhr.send( binary );
                    }
                } else {
                    xhr.send( formData );
                }
            },
    
            getResponse: function() {
                return this._response;
            },
    
            getResponseAsJson: function() {
                return this._parseJson( this._response );
            },
    
            getStatus: function() {
                return this._status;
            },
    
            abort: function() {
                var xhr = this._xhr;
    
                if ( xhr ) {
                    xhr.upload.onprogress = noop;
                    xhr.onreadystatechange = noop;
                    xhr.abort();
    
                    this._xhr = xhr = null;
                }
            },
    
            destroy: function() {
                this.abort();
            },
    
            _initAjax: function() {
                var me = this,
                    xhr = new XMLHttpRequest(),
                    opts = this.options;
    
                if ( opts.withCredentials && !('withCredentials' in xhr) &&
                        typeof XDomainRequest !== 'undefined' ) {
                    xhr = new XDomainRequest();
                }
    
                xhr.upload.onprogress = function( e ) {
                    var percentage = 0;
    
                    if ( e.lengthComputable ) {
                        percentage = e.loaded / e.total;
                    }
    
                    return me.trigger( 'progress', percentage );
                };
    
                xhr.onreadystatechange = function() {
    
                    if ( xhr.readyState !== 4 ) {
                        return;
                    }
    
                    xhr.upload.onprogress = noop;
                    xhr.onreadystatechange = noop;
                    me._xhr = null;
                    me._status = xhr.status;
    
                    if ( xhr.status >= 200 && xhr.status < 300 ) {
                        me._response = xhr.responseText;
                        return me.trigger('load');
                    } else if ( xhr.status >= 500 && xhr.status < 600 ) {
                        me._response = xhr.responseText;
                        return me.trigger( 'error', 'server' );
                    }
    
    
                    return me.trigger( 'error', me._status ? 'http' : 'abort' );
                };
    
                me._xhr = xhr;
                return xhr;
            },
    
            _setRequestHeader: function( xhr, headers ) {
                $.each( headers, function( key, val ) {
                    xhr.setRequestHeader( key, val );
                });
            },
    
            _parseJson: function( str ) {
                var json;
    
                try {
                    json = JSON.parse( str );
                } catch ( ex ) {
                    json = {};
                }
    
                return json;
            }
        });
    });
    define('webuploader',[
        'base',
        'widgets/filepicker',
        'widgets/image',
        'widgets/queue',
        'widgets/runtime',
        'widgets/upload',
        'widgets/log',
        'runtime/html5/blob',
        'runtime/html5/filepicker',
        'runtime/html5/imagemeta/exif',
        'runtime/html5/image',
        'runtime/html5/androidpatch',
        'runtime/html5/transport'
    ], function( Base ) {
        return Base;
    });
    return require('webuploader');
});